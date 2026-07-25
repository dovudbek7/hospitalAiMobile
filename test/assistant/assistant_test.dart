import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hospital_ai/core/auth/session.dart';
import 'package:hospital_ai/core/providers.dart';
import 'package:hospital_ai/core/storage/app_database.dart';
import 'package:hospital_ai/features/assistant/assistant_models.dart';
import 'package:hospital_ai/features/assistant/assistant_providers.dart';

/// Adapter that streams caller-supplied SSE frames (or throws for offline).
class _SseAdapter implements HttpClientAdapter {
  _SseAdapter(this.frames, {this.throwOffline = false});
  final List<String> frames;
  final bool throwOffline;
  int calls = 0;

  @override
  Future<ResponseBody> fetch(RequestOptions o, Stream<Uint8List>? s,
      Future<void>? c) async {
    calls++;
    if (throwOffline) throw const SocketException('down');
    final stream = () async* {
      for (final f in frames) {
        yield Uint8List.fromList(utf8.encode(f));
      }
    }();
    return ResponseBody(stream, 201, headers: {
      Headers.contentTypeHeader: ['text/event-stream'],
    });
  }

  @override
  void close({bool force = false}) {}
}

String _sse(Map<String, dynamic> o) => 'data: ${jsonEncode(o)}\n\n';

Future<ProviderContainer> _container(_SseAdapter adapter) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final c = ProviderContainer(
    overrides: [
      sharedPrefsProvider.overrideWithValue(prefs),
      databaseProvider.overrideWith((ref) {
        final db = AppDatabase.memory();
        ref.onDispose(db.close);
        return db;
      }),
    ],
  );
  addTearDown(c.dispose);
  c.read(dioProvider).httpClientAdapter = adapter;
  return c;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('chunk parsing', () {
    test('delta / done / error shapes', () {
      expect(AssistantChunk.parse({'type': 'delta', 'text': 'hi'}),
          isA<AssistantDelta>());
      final done = AssistantChunk.parse(
        {'type': 'done', 'verdict': 'red_flag_bypass', 'contentKey': 'k'},
      )! as AssistantDone;
      expect(done.isRedFlag, isTrue);
      expect(done.contentKey, 'k');
      expect(AssistantChunk.parse({'type': 'error', 'code': 'X'}),
          isA<AssistantError>());
      expect(AssistantChunk.parse({'type': 'nonsense'}), isNull);
    });
  });

  test('passed: streamed deltas ARE the answer', () async {
    final c = await _container(_SseAdapter([
      _sse({'type': 'delta', 'text': 'Your clinic’s guidance '}),
      _sse({'type': 'delta', 'text': 'is in Learn.'}),
      _sse({'type': 'done', 'verdict': 'passed'}),
    ]));
    final key = await c.read(assistantProvider.notifier).send('walking?');
    expect(key, isNull);
    final msgs = c.read(assistantProvider).messages;
    expect(msgs.last.text, 'Your clinic’s guidance is in Learn.');
    expect(msgs.last.contentKey, isNull);
    expect(msgs.last.streaming, isFalse);
  });

  test('red_flag_bypass: returns the emergency key, sets redFlag outcome',
      () async {
    final c = await _container(_SseAdapter([
      _sse({
        'type': 'done',
        'verdict': 'red_flag_bypass',
        'contentKey': 'emergency.headline',
      }),
    ]));
    final key = await c.read(assistantProvider.notifier).send('chest pain');
    expect(key, 'emergency.headline');
    expect(c.read(assistantProvider).outcome, AssistantOutcome.redFlag);
  });

  test('replaced: the bubble shows the contentKey, not composed text',
      () async {
    final c = await _container(_SseAdapter([
      _sse({
        'type': 'done',
        'verdict': 'replaced',
        'contentKey': 'contact.body',
      }),
    ]));
    final key = await c.read(assistantProvider.notifier).send('hmm');
    expect(key, isNull);
    expect(c.read(assistantProvider).messages.last.contentKey, 'contact.body');
  });

  test('error chunk: bubble falls back to approved content', () async {
    final c = await _container(_SseAdapter([
      _sse({'type': 'error', 'code': 'INTERNAL_ERROR'}),
    ]));
    await c.read(assistantProvider.notifier).send('hi');
    expect(c.read(assistantProvider).messages.last.contentKey,
        'assistant.error');
    expect(c.read(assistantProvider).outcome, AssistantOutcome.failed);
  });

  test('offline: blocked, marked offline, NOTHING queued', () async {
    final adapter = _SseAdapter([], throwOffline: true);
    final c = await _container(adapter);
    final key = await c.read(assistantProvider.notifier).send('hi');
    expect(key, isNull);
    expect(c.read(assistantProvider).outcome, AssistantOutcome.offline);
    // The empty live bubble is removed; no assistant message lingers.
    final msgs = c.read(assistantProvider).messages;
    expect(msgs.where((m) => m.role == ChatRole.assistant), isEmpty);
    // The action queue is untouched — an assistant message is never queued.
    final db = c.read(databaseProvider);
    expect(await db.select(db.pendingActions).get(), isEmpty);
  });
}
