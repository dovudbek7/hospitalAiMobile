import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hospital_ai/core/auth/session.dart';
import 'package:hospital_ai/core/providers.dart';
import 'package:hospital_ai/core/storage/app_database.dart';
import 'package:hospital_ai/features/checkin/checkin_providers.dart';

import '../network/fake_adapter.dart';

Future<(ProviderContainer, FakeAdapter)> _setup(FakeHandler handler) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final adapter = FakeAdapter(handler);
  final container = ProviderContainer(
    overrides: [
      sharedPrefsProvider.overrideWithValue(prefs),
      databaseProvider.overrideWith((ref) {
        final db = AppDatabase.memory();
        ref.onDispose(db.close);
        return db;
      }),
    ],
  );
  addTearDown(container.dispose);
  container.read(dioProvider).httpClientAdapter = adapter;
  return (container, adapter);
}

FakeResponse _result(String tier, {bool withinHours = true}) =>
    FakeResponse(200, {
      'checkinId': 'c1',
      'tier': tier,
      'ruleVersion': 'placeholder-v1',
      'recoveryDay': 6,
      'withinClinicHours': withinHours,
      'contentKey': 'checkin.submitted.$tier',
      'body': 'approved body for $tier',
      'escalationId': tier == 'routine' ? null : 'e1',
    });

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('routeForTier maps ONLY the three server tiers; unknown = null', () {
    expect(routeForTier('routine'), '/checkin/result/routine');
    expect(routeForTier('urgent'), '/checkin/result/urgent');
    expect(routeForTier('emergency'), '/emergency');
    expect(routeForTier('ROUTINE'), isNull, reason: 'no case folding');
    expect(routeForTier('mild'), isNull);
    expect(routeForTier(''), isNull);
  });

  for (final tier in ['routine', 'urgent', 'emergency']) {
    test('submit routes on the SERVER tier verbatim — $tier', () async {
      final (c, _) = await _setup((o) => _result(tier));
      final notifier = c.read(checkinFlowProvider.notifier)
        ..answer('q1_temp', 'under_37_5');
      final route = await notifier.submit();
      expect(route, routeForTier(tier));
      expect(c.read(checkinFlowProvider).phase, CheckinPhase.submitted);
      expect(c.read(checkinFlowProvider).result!.tier, tier);
    });
  }

  test('an unrecognised tier is a FAILURE, never a guessed screen',
      () async {
    final (c, _) = await _setup((o) => _result('mystery'));
    final notifier = c.read(checkinFlowProvider.notifier)
      ..answer('q1_temp', 'under_37_5');
    final route = await notifier.submit();
    expect(route, isNull);
    expect(c.read(checkinFlowProvider).phase, CheckinPhase.failed);
  });

  test('offline submit is BLOCKED and nothing enters any queue', () async {
    final (c, adapter) = await _setup(
      (o) => throw const SocketException('down'),
    );
    final notifier = c.read(checkinFlowProvider.notifier)
      ..answer('q1_temp', 'under_37_5');
    final route = await notifier.submit();

    expect(route, isNull);
    expect(c.read(checkinFlowProvider).phase, CheckinPhase.blockedOffline);

    // NOTHING was queued — the action queue stays empty.
    final db = c.read(databaseProvider);
    expect(await db.select(db.pendingActions).get(), isEmpty);
    // And the attempt hit the wire directly, no retry loop enqueued it.
    expect(
      adapter.requests.every((r) => r.uri.path.endsWith('/checkins')),
      isTrue,
    );
  });

  test('a 500 renders as FAILURE, never success', () async {
    final (c, _) = await _setup(
      (o) => FakeResponse(500, {
        'code': 'INTERNAL_ERROR',
        'message': 'boom',
        'details': <String, dynamic>{},
      }),
    );
    final notifier = c.read(checkinFlowProvider.notifier)
      ..answer('q1_temp', 'under_37_5');
    final route = await notifier.submit();
    expect(route, isNull);
    expect(c.read(checkinFlowProvider).phase, CheckinPhase.failed);
    expect(c.read(checkinFlowProvider).result, isNull);
  });

  test('retrying the SAME submission replays the SAME idempotency key',
      () async {
    var fail = true;
    final keys = <String?>[];
    final (c, _) = await _setup((o) {
      keys.add(o.headers['Idempotency-Key'] as String?);
      if (fail) {
        return FakeResponse(500, {
          'code': 'INTERNAL_ERROR',
          'message': 'x',
          'details': <String, dynamic>{},
        });
      }
      return _result('routine');
    });

    final notifier = c.read(checkinFlowProvider.notifier)
      ..answer('q1_temp', 'under_37_5');
    await notifier.submit(); // fails
    fail = false;
    notifier.backToAnswering();
    await notifier.submit(); // retry of the same logical submission

    expect(keys, hasLength(2));
    expect(keys.first, keys.last,
        reason: 'a replay must dedupe server-side');
  });

  test('a same-day draft resumes; submit clears it', () async {
    final (c, _) = await _setup((o) => _result('routine'));
    final notifier = c.read(checkinFlowProvider.notifier)
      ..answer('q1_temp', 'under_37_5')
      ..answer('q2_pain', 4);

    // A fresh container (same prefs) resumes the draft.
    final prefs = await SharedPreferences.getInstance();
    final c2 = ProviderContainer(
      overrides: [
        sharedPrefsProvider.overrideWithValue(prefs),
        databaseProvider.overrideWith((ref) {
          final db = AppDatabase.memory();
          ref.onDispose(db.close);
          return db;
        }),
      ],
    );
    addTearDown(c2.dispose);
    expect(
      c2.read(checkinFlowProvider).answers,
      {'q1_temp': 'under_37_5', 'q2_pain': 4},
    );

    await notifier.submit();
    final c3 = ProviderContainer(
      overrides: [sharedPrefsProvider.overrideWithValue(prefs)],
    );
    addTearDown(c3.dispose);
    expect(c3.read(checkinFlowProvider).answers, isEmpty,
        reason: 'submitted drafts never resume');
  });

  test('multi-select: none-of-these is exclusive both ways', () async {
    final (c, _) = await _setup((o) => _result('routine'));
    final notifier = c.read(checkinFlowProvider.notifier)
      ..toggleMulti('q5_redflags', 'chills')
      ..toggleMulti('q5_redflags', 'chest_pain');
    expect(
      c.read(checkinFlowProvider).answers['q5_redflags'],
      ['chills', 'chest_pain'],
    );
    notifier.toggleMulti('q5_redflags', 'none');
    expect(c.read(checkinFlowProvider).answers['q5_redflags'], ['none']);
    notifier.toggleMulti('q5_redflags', 'heavy_bleeding');
    expect(
      c.read(checkinFlowProvider).answers['q5_redflags'],
      ['heavy_bleeding'],
      reason: 'picking a flag clears none-of-these',
    );
  });

  test('NO tier logic exists in the checkin feature — the client never '
      'reads an answer to decide anything', () {
    final dir = Directory('lib/features/checkin');
    final sources = dir
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))
        .map((f) => f.readAsStringSync())
        .join('\n');

    // Signature strings of the placeholder-v1 rules — none may appear in
    // client code. The tier arrives; it is never computed.
    const ruleFragments = [
      '38_5_or_above',
      'chest_pain',
      'difficulty_breathing',
      'heavy_bleeding',
      'q2_pain >= 8',
      'opening',
      'very_red',
    ];
    for (final fragment in ruleFragments) {
      expect(sources.contains(fragment), isFalse,
          reason: 'client code must not know the rule "$fragment"');
    }
  });
}
