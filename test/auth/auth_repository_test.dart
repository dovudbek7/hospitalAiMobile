import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hospital_ai/core/auth/session.dart';
import 'package:hospital_ai/core/network/api_error.dart';
import 'package:hospital_ai/core/network/token_store.dart';
import 'package:hospital_ai/core/providers.dart';
import 'package:hospital_ai/features/onboarding/data/auth_repository.dart';

import '../network/fake_adapter.dart';

Future<(ProviderContainer, FakeAdapter, InMemoryTokenStore)> _setup(
  FakeHandler handler,
) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final tokens = InMemoryTokenStore();
  final adapter = FakeAdapter(handler);

  final container = ProviderContainer(
    overrides: [
      sharedPrefsProvider.overrideWithValue(prefs),
      tokenStoreProvider.overrideWithValue(tokens),
    ],
  );
  addTearDown(container.dispose);
  container.read(dioProvider).httpClientAdapter = adapter;
  return (container, adapter, tokens);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('enrol stores tokens securely and flips session flags', () async {
    final (c, adapter, tokens) = await _setup(
      (o) => FakeResponse(200, {
        'audience': 'patient',
        'accessToken': 'access-1',
        'refreshToken': 'refresh-1',
        'patientId': 'p-1',
        'clinicId': 'c-1',
      }),
    );

    await c.read(authRepositoryProvider).enrol(
          code: ' h7k9qp ',
          phone: '+998 90 123-45-67',
        );

    // Code normalised to uppercase, phone stripped of spaces/dashes.
    final sent = adapter.requests.single.data as Map<String, dynamic>;
    expect(sent['code'], 'H7K9QP');
    expect(sent['phone'], '+998901234567');

    expect(await tokens.readAccessToken(), 'access-1');
    final s = c.read(sessionProvider);
    expect(s.hasSession, isTrue);
    expect(s.consented, isFalse, reason: 'consent is a separate step');
    expect(s.patientId, 'p-1');
  });

  test('a failed enrolment surfaces ApiError and stores NOTHING', () async {
    final (c, _, tokens) = await _setup(
      (o) => FakeResponse(401, {
        'code': 'UNAUTHORIZED',
        // The server message must never reach a patient — the caller maps
        // the code to a content key. It also never says whether the code
        // exists.
        'message': 'invalid code or phone',
        'details': <String, dynamic>{},
      }),
    );

    await expectLater(
      c.read(authRepositoryProvider).enrol(code: 'AAAAAA', phone: '+998901'),
      throwsA(
        isA<DioException>().having(
          (e) => (e.error! as ApiError).code,
          'code',
          ApiErrorCode.unauthorized,
        ),
      ),
    );
    expect(await tokens.readAccessToken(), isNull);
    expect(c.read(sessionProvider).hasSession, isFalse);
  });

  test('decline wipes tokens and every local session flag', () async {
    final (c, _, tokens) = await _setup(
      (o) => FakeResponse(200, {
        'audience': 'patient',
        'accessToken': 'a',
        'refreshToken': 'r',
        'patientId': 'p-1',
        'clinicId': 'c-1',
      }),
    );
    final repo = c.read(authRepositoryProvider);
    await repo.enrol(code: 'H7K9QP', phone: '+998901234567');
    expect(c.read(sessionProvider).hasSession, isTrue);

    await repo.decline();

    expect(await tokens.readAccessToken(), isNull);
    final s = c.read(sessionProvider);
    expect(s.hasSession, isFalse);
    expect(s.consented, isFalse);
    expect(s.patientId, isNull);
    // Language is deliberately kept — the patient can re-enrol without
    // being stranded in an unreadable interface.
    // (Decline writes zero personal data; a language is not personal data.)
  });

  test('bootstrapProfile failure NEVER logs the patient out', () async {
    var enrolled = false;
    final (c, _, tokens) = await _setup((o) {
      if (o.uri.path.endsWith('/auth/patient/session')) {
        enrolled = true;
        return FakeResponse(200, {
          'audience': 'patient',
          'accessToken': 'a',
          'refreshToken': 'r',
          'patientId': 'p-1',
          'clinicId': 'c-1',
        });
      }
      // Everything after enrolment fails server-side.
      return FakeResponse(500, {
        'code': 'INTERNAL_ERROR',
        'message': 'boom',
        'details': <String, dynamic>{},
      });
    });

    final repo = c.read(authRepositoryProvider);
    await repo.enrol(code: 'H7K9QP', phone: '+998901234567');
    expect(enrolled, isTrue);

    final profile = await repo.bootstrapProfile();
    expect(profile, isNull, reason: 'failure is absorbed, not rethrown');
    expect(await tokens.readAccessToken(), 'a',
        reason: 'a patient mid-programme is never logged out');
    expect(c.read(sessionProvider).hasSession, isTrue);
  });

  test('session snapshot survives a cold start (prefs round-trip)', () async {
    SharedPreferences.setMockInitialValues({
      'session.language': 'UZ',
      'session.has_session': true,
      'session.consented': true,
      'session.patient_id': 'p-9',
      'session.clinic_id': 'c-9',
    });
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [sharedPrefsProvider.overrideWithValue(prefs)],
    );
    addTearDown(container.dispose);

    final s = container.read(sessionProvider);
    expect(s.onboarded, isTrue);
    expect(s.language, 'UZ');
    expect(s.patientId, 'p-9');
  });
}
