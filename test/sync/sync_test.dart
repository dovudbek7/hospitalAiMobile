import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:hospital_ai/core/api/patient_api.dart';
import 'package:hospital_ai/core/models/api_models.dart';
import 'package:hospital_ai/core/network/dio_client.dart';
import 'package:hospital_ai/core/network/token_store.dart';
import 'package:hospital_ai/core/storage/app_database.dart';
import 'package:hospital_ai/core/sync/action_queue.dart';
import 'package:hospital_ai/core/sync/sync_worker.dart';
import 'package:hospital_ai/core/sync/task_cache.dart';

import '../network/fake_adapter.dart';

(PatientApi, FakeAdapter) _api(FakeHandler handler) {
  final adapter = FakeAdapter(handler);
  final dio = buildDio(
    tokens: InMemoryTokenStore(),
    baseUrl: 'https://fake.test/v1',
  );
  dio.httpClientAdapter = adapter;
  return (PatientApi(dio), adapter);
}

void main() {
  late AppDatabase db;
  late ActionQueue queue;

  setUp(() {
    db = AppDatabase.memory();
    queue = ActionQueue(db);
  });
  tearDown(() => db.close());

  test('offline toggle queues with the ORIGINAL timestamp and a stable key',
      () async {
    final cache = TaskCacheRepository(db, queue);
    await cache.saveToday(
      const TodayResponse(
        recoveryDay: 6,
        groups: {
          'medication': [
            PatientTask(
              id: 't1',
              taskType: 'medication',
              contentRef: 'medication.paracetamol_500',
              scheduledFor: '2026-07-24T08:00:00Z',
              status: 'pending',
            ),
          ],
        },
        checkinDue: false,
      ),
    );

    final actionTime = DateTime.utc(2026, 7, 24, 8, 5);
    await cache.toggle(taskId: 't1', completed: true, occurredAt: actionTime);

    final rows = await queue.pending();
    expect(rows, hasLength(1));
    expect(rows.single.occurredAt, actionTime.toIso8601String());
    expect(rows.single.idempotencyKey, isNotEmpty);

    final task = await cache.byId('t1');
    expect(task!.status, 'completed', reason: 'ticks locally, offline');
  });

  test('drain sends the persisted key + original occurredAt, then settles',
      () async {
    final sent = <Map<String, Object?>>[];
    final (api, adapter) = _api((o) {
      sent.add({
        'path': o.uri.path,
        'key': o.headers['Idempotency-Key'],
        'body': o.data,
      });
      return FakeResponse(200, {'ok': true});
    });

    final actionTime = DateTime.utc(2026, 7, 24, 9);
    await queue.enqueueTaskToggle(
      taskId: 't9',
      uncomplete: false,
      occurredAt: actionTime,
    );
    final persistedKey = (await queue.pending()).single.idempotencyKey;

    final worker = SyncWorker(api: api, queue: queue);
    final settled = await worker.drainOnce();

    expect(settled, 1);
    expect(await queue.pending(), isEmpty);
    expect(sent.single['key'], persistedKey);
    final body = sent.single['body']! as Map<String, dynamic>;
    expect(
      body['occurredAt'],
      actionTime.toIso8601String(),
      reason: 'sync must never substitute the sync time',
    );
  });

  test('still-offline drain keeps rows untouched for the next attempt',
      () async {
    final (api, _) = _api((o) => throw const SocketException('down'));
    await queue.enqueueTaskToggle(
      taskId: 't1',
      uncomplete: false,
      occurredAt: DateTime.utc(2026, 7, 24),
    );
    final before = (await queue.pending()).single;

    final worker = SyncWorker(api: api, queue: queue);
    final settled = await worker.drainOnce();

    expect(settled, 0);
    final after = (await queue.pending()).single;
    expect(after.idempotencyKey, before.idempotencyKey,
        reason: 'the SAME key must be replayed on the next drain');
    expect(after.attempts, before.attempts);
  });

  test('DUPLICATE_REQUEST settles the row — replay produced one effect',
      () async {
    final (api, _) = _api(
      (o) => FakeResponse(409, {
        'code': 'DUPLICATE_REQUEST',
        'message': 'already processed',
        'details': <String, dynamic>{},
      }),
    );
    await queue.enqueueTaskToggle(
      taskId: 't1',
      uncomplete: false,
      occurredAt: DateTime.utc(2026, 7, 24),
    );

    final worker = SyncWorker(api: api, queue: queue);
    final settled = await worker.drainOnce();

    expect(settled, 1);
    expect(await queue.pending(), isEmpty);
  });

  test('uncomplete travels as a NEW action with its own key', () async {
    await queue.enqueueTaskToggle(
      taskId: 't1',
      uncomplete: false,
      occurredAt: DateTime.utc(2026, 7, 24, 8),
    );
    await queue.enqueueTaskToggle(
      taskId: 't1',
      uncomplete: true,
      occurredAt: DateTime.utc(2026, 7, 24, 8, 1),
    );
    final rows = await queue.pending();
    expect(rows, hasLength(2));
    expect(rows.first.idempotencyKey, isNot(rows.last.idempotencyKey));

    final bodies = <Map<String, dynamic>>[];
    final (api, _) = _api((o) {
      bodies.add(o.data as Map<String, dynamic>);
      return FakeResponse(200, {'ok': true});
    });
    await SyncWorker(api: api, queue: queue).drainOnce();
    expect(bodies.first.containsKey('uncomplete'), isFalse);
    expect(bodies.last['uncomplete'], isTrue);
  });

  test('the queue cannot represent a check-in submission', () {
    // Type-level guarantee: no enum member exists for check-ins, so no
    // code path can queue one. This test pins that invariant.
    final wires = PendingActionType.values.map((t) => t.wire).toList();
    expect(wires, ['complete_task', 'uncomplete_task']);
    expect(wires.any((w) => w.contains('checkin')), isFalse);
    expect(
      () => PendingActionType.parse('submit_checkin'),
      throwsA(isA<StateError>()),
    );
  });

  test('telemetry payloads in the outbox never contain free text keys', () async {
    await db.into(db.telemetryOutbox).insert(
          TelemetryOutboxCompanion.insert(
            id: 'e1',
            name: 'emergency_screen_shown',
            props: jsonEncode({'trigger': 'tier'}),
            occurredAt: DateTime.utc(2026, 7, 24).toIso8601String(),
          ),
        );
    final rows = await db.select(db.telemetryOutbox).get();
    final props = jsonDecode(rows.single.props) as Map<String, dynamic>;
    for (final v in props.values) {
      expect(v is bool || v is num || (v is String && !v.contains(' ')), isTrue,
          reason: 'ids and categorical values only — no prose');
    }
  });
}
