import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hospital_ai/core/api/patient_api.dart';
import 'package:hospital_ai/core/content/content_repository.dart';
import 'package:hospital_ai/core/content/emergency_bundle.dart';
import 'package:hospital_ai/core/network/dio_client.dart';
import 'package:hospital_ai/core/network/token_store.dart';
import 'package:hospital_ai/core/storage/app_database.dart';

import '../network/fake_adapter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('bundle is refreshed from the library and survives with no network',
      () async {
    SharedPreferences.setMockInitialValues({});
    final db = AppDatabase.memory();
    addTearDown(db.close);

    final adapter = FakeAdapter((o) {
      final key = o.uri.path.split('/').last;
      return FakeResponse(200, {
        'contentKey': key,
        'language': 'EN',
        'text': 'text for $key',
        'version': 1,
        'isPlaceholder': true,
      });
    });
    final dio = buildDio(
      tokens: InMemoryTokenStore(),
      baseUrl: 'https://fake.test/v1',
    );
    dio.httpClientAdapter = adapter;
    final repo = ContentRepository(
      PatientApi(dio),
      db,
      loadAsset: (_) async => '{}',
    );

    final bundle = await EmergencyBundle.refresh(
      content: repo,
      language: 'EN',
      clinicName: 'Sehat Clinic (DEMO)',
      clinicPhone: '+998 71 200 00 00',
    );
    expect(bundle, isNotNull);
    expect(bundle!.headline, 'text for emergency.headline');
    expect(bundle.ambulanceNumber, '103');

    // Simulate a later cold start with NO network: load() alone must work.
    final loaded = await EmergencyBundle.load();
    expect(loaded, isNotNull);
    expect(loaded!.banner, 'text for emergency.banner');
    expect(loaded.clinicPhone, '+998 71 200 00 00');
  });

  test('a partial refresh keeps the previous complete bundle', () async {
    SharedPreferences.setMockInitialValues({});
    final db = AppDatabase.memory();
    addTearDown(db.close);

    // Seed a good bundle first.
    const good = EmergencyBundle(
      headline: 'h',
      body: 'b',
      banner: 'ba',
      ambulanceNumber: '103',
      clinicName: 'c',
      clinicPhone: 'p',
      language: 'EN',
    );
    await good.save();

    // Refresh where one key fails → must return null and keep the old one.
    final adapter = FakeAdapter((o) {
      if (o.uri.path.endsWith('emergency.body')) {
        return FakeResponse(404, {
          'code': 'CONTENT_NOT_APPROVED',
          'message': 'x',
          'details': <String, dynamic>{},
        });
      }
      return FakeResponse(200, {
        'contentKey': 'k',
        'language': 'EN',
        'text': 't',
        'version': 1,
        'isPlaceholder': true,
      });
    });
    final dio = buildDio(
      tokens: InMemoryTokenStore(),
      baseUrl: 'https://fake.test/v1',
    );
    dio.httpClientAdapter = adapter;
    final repo = ContentRepository(
      PatientApi(dio),
      db,
      allowBundledPlaceholders: false,
      loadAsset: (_) async => '{}',
    );

    final result = await EmergencyBundle.refresh(
      content: repo,
      language: 'EN',
      clinicName: 'c2',
      clinicPhone: 'p2',
    );
    expect(result, isNull);

    final kept = await EmergencyBundle.load();
    expect(kept!.headline, 'h', reason: 'previous bundle must survive');
  });

  test('server {CLINIC_NAME} tokens are interpolated into the bundle',
      () async {
    SharedPreferences.setMockInitialValues({});
    final db = AppDatabase.memory();
    addTearDown(db.close);

    final adapter = FakeAdapter((o) {
      final key = o.uri.path.split('/').last;
      final text = key == 'emergency.body'
          ? '{CLINIC_NAME} advises calling {CLINIC_PHONE} now.'
          : 'text for $key';
      return FakeResponse(200, {
        'contentKey': key,
        'language': 'EN',
        'text': text,
        'version': 1,
        'isPlaceholder': true,
      });
    });
    final dio = buildDio(
      tokens: InMemoryTokenStore(),
      baseUrl: 'https://fake.test/v1',
    );
    dio.httpClientAdapter = adapter;
    final repo = ContentRepository(PatientApi(dio), db,
        loadAsset: (_) async => '{}');

    final bundle = await EmergencyBundle.refresh(
      content: repo,
      language: 'EN',
      clinicName: 'Sehat Clinic (DEMO)',
      clinicPhone: '+998712000000',
    );
    expect(bundle!.body, 'Sehat Clinic (DEMO) advises calling '
        '+998712000000 now.');
    expect(bundle.body.contains('{CLINIC_NAME}'), isFalse);
  });
}
