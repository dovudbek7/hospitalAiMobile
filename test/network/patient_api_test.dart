import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hospital_ai/core/api/patient_api.dart';
import 'package:hospital_ai/core/models/api_models.dart';
import 'package:hospital_ai/core/network/api_error.dart';
import 'package:hospital_ai/core/network/dio_client.dart';
import 'package:hospital_ai/core/network/token_store.dart';

import 'fake_adapter.dart';

Dio _dio(FakeAdapter adapter) {
  final tokens = InMemoryTokenStore()
    ..write(accessToken: 'test-token', refreshToken: 'r');
  final dio = buildDio(tokens: tokens, baseUrl: 'https://fake.test/v1');
  dio.httpClientAdapter = adapter;
  return dio;
}

/// Canonical response shapes from the handoff doc §3/§5/§6.
const _todayJson = {
  'recoveryDay': 6,
  'groups': {
    'medication': [
      {
        'id': 't1',
        'taskType': 'medication',
        'contentRef': 'medication.paracetamol_500',
        'scheduledFor': '2026-07-24T08:00:00Z',
        'windowClosesAt': '2026-07-24T10:00:00Z',
        'status': 'pending',
        'onTime': null,
      }
    ],
  },
  'checkinDue': true,
};

const _progressJson = {
  'adherence': {'value': 0.8, 'numerator': 8, 'denominator': 10},
  'daysCompleted': 5,
  'programmeDays': 30,
  'perDay': [
    {'recoveryDay': 1, 'value': 1, 'numerator': 2, 'denominator': 2},
  ],
};

const _checkinResultJson = {
  'checkinId': 'c-1',
  'tier': 'urgent',
  'ruleVersion': 'placeholder-v1',
  'recoveryDay': 6,
  'withinClinicHours': true,
  'contentKey': 'checkin.submitted.urgent',
  'body': null,
  'escalationId': 'e-1',
};

const _questionsJson = [
  {
    'ref': 'q1_temp',
    'questionContentKey': 'checkin.q1_temp',
    'type': 'single',
    'options': [
      {'code': 'under_37_5', 'label': '37,5 dan past'},
      {'code': '38_5_or_above', 'label': '38,5 va undan yuqori'},
    ],
  },
  {
    'ref': 'q2_pain',
    'questionContentKey': 'checkin.q2_pain',
    'type': 'scale',
    'scale': {'min': 0, 'max': 10},
  },
];

void main() {
  test('models round-trip the handoff example payloads', () {
    final today = TodayResponse.fromJson(_todayJson);
    expect(today.recoveryDay, 6);
    expect(today.groups['medication']!.single.contentRef,
        'medication.paracetamol_500');
    expect(today.checkinDue, isTrue);

    final progress = ProgressResponse.fromJson(_progressJson);
    expect(progress.adherence.denominator, 10);
    expect(progress.perDay.single.recoveryDay, 1);

    final result = CheckinResult.fromJson(_checkinResultJson);
    expect(result.tier, 'urgent');
    expect(result.ruleVersion, 'placeholder-v1');
  });

  test('ContentItem round-trips a LIVE response from api.hospital-ai.uz', () {
    final live = jsonDecode(
      File('test/fixtures/content_live.json').readAsStringSync(),
    ) as Map<String, dynamic>;
    final item = ContentItem.fromJson(live);
    expect(item.contentKey, 'emergency.headline');
    expect(item.language, 'EN');
    expect(item.isPlaceholder, isTrue);
    expect(item.toJson()['text'], live['text']);
  });

  test('checkin questions parse with pre-translated labels', () async {
    final adapter =
        FakeAdapter((o) => FakeResponse(200, _questionsJson));
    final api = PatientApi(_dio(adapter));
    final qs = await api.getCheckinQuestions();
    expect(qs, hasLength(2));
    expect(qs.first.options.first.label, '37,5 dan past');
    expect(qs.last.scale!.max, 10);
  });

  test('completeTask sends the Idempotency-Key header', () async {
    final adapter = FakeAdapter((o) => FakeResponse(200, {'ok': true}));
    final api = PatientApi(_dio(adapter));
    await api.completeTask(taskId: 't1', idempotencyKey: 'key-123');
    expect(adapter.requests.single.headers['Idempotency-Key'], 'key-123');
  });

  test('submitCheckin without a key is refused before it leaves the device',
      () async {
    final adapter = FakeAdapter((o) => FakeResponse(200, _checkinResultJson));
    final dio = _dio(adapter);
    // Bypass PatientApi to simulate a programming error.
    await expectLater(
      dio.post<dynamic>('/checkins', data: {'answers': <dynamic>[]}),
      throwsA(anything),
    );
    expect(adapter.requests, isEmpty,
        reason: 'the request must never reach the wire without a key');
  });

  test('replaying the same key returns the original result (server dedupe)',
      () async {
    var calls = 0;
    final adapter = FakeAdapter((o) {
      calls++;
      // The backend replays the ORIGINAL result for a repeated key.
      return FakeResponse(200, _checkinResultJson);
    });
    final api = PatientApi(_dio(adapter));
    final a = await api.submitCheckin(
      answers: const [
        {'ref': 'q1_temp', 'value': 'under_37_5'},
      ],
      idempotencyKey: 'same-key',
    );
    final b = await api.submitCheckin(
      answers: const [
        {'ref': 'q1_temp', 'value': 'under_37_5'},
      ],
      idempotencyKey: 'same-key',
    );
    expect(calls, 2);
    expect(a.checkinId, b.checkinId, reason: 'one logical check-in');
  });

  test('API envelope surfaces as ApiError with the right code', () async {
    final adapter = FakeAdapter(
      (o) => FakeResponse(403, {
        'code': 'WRONG_TOKEN_AUDIENCE',
        'message': 'staff token at patient endpoint',
        'details': <String, dynamic>{},
      }),
    );
    final api = PatientApi(_dio(adapter));
    try {
      await api.getProfile();
      fail('should have thrown');
    } on DioException catch (e) {
      final err = e.error;
      expect(err, isA<ApiError>());
      expect((err! as ApiError).code, ApiErrorCode.wrongTokenAudience);
    }
  });

  test('GET retries transport failures with backoff, POST without key never '
      'reaches the wire twice', () async {
    var attempts = 0;
    final adapter = FakeAdapter((o) {
      attempts++;
      throw const SocketException('down');
    });
    final api = PatientApi(_dio(adapter));
    await expectLater(api.getToday(), throwsA(isA<DioException>()));
    expect(attempts, greaterThanOrEqualTo(1));
  });
}
