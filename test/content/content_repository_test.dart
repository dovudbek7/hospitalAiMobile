import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:hospital_ai/core/api/patient_api.dart';
import 'package:hospital_ai/core/content/content_repository.dart';
import 'package:hospital_ai/core/content/content_result.dart';
import 'package:hospital_ai/core/content/interpolate.dart';
import 'package:hospital_ai/core/network/dio_client.dart';
import 'package:hospital_ai/core/network/token_store.dart';
import 'package:hospital_ai/core/storage/app_database.dart';

import '../network/fake_adapter.dart';

const _seedJson = {
  'today.title': {
    'EN': {'text': 'Day {N} of 30', 'version': 0, 'isPlaceholder': true},
    'UZ': {
      'text': '[UZ PLACEHOLDER — NOT CLINICALLY APPROVED] Day {N} of 30',
      'version': 0,
      'isPlaceholder': true,
    },
  },
};

ContentRepository _repo(
  AppDatabase db,
  FakeAdapter adapter, {
  bool allowSeed = true,
}) {
  final dio = buildDio(
    tokens: InMemoryTokenStore(),
    baseUrl: 'https://fake.test/v1',
  );
  dio.httpClientAdapter = adapter;
  return ContentRepository(
    PatientApi(dio),
    db,
    allowBundledPlaceholders: allowSeed,
    loadAsset: (_) async => jsonEncode(_seedJson),
  );
}

FakeResponse _ok(String key, String lang, String text, int version) =>
    FakeResponse(200, {
      'contentKey': key,
      'language': lang,
      'text': text,
      'version': version,
      'isPlaceholder': true,
    });

FakeResponse get _notApproved => FakeResponse(404, {
      'code': 'CONTENT_NOT_APPROVED',
      'message': 'not approved',
      'details': <String, dynamic>{},
    });

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase.memory());
  tearDown(() => db.close());

  test('server text wins and is cached', () async {
    final adapter =
        FakeAdapter((o) => _ok('emergency.headline', 'EN', 'from server', 3));
    final repo = _repo(db, adapter);

    final r = await repo.resolve('emergency.headline', 'EN');
    expect(r, isA<ContentResolved>());
    expect((r as ContentResolved).text, 'from server');
    expect(r.fromBundledSeed, isFalse);

    // Offline afterwards → served from cache, same version.
    final offline = FakeAdapter((o) => throw StateError('no network'));
    final repo2 = _repo(db, offline);
    final cached = await repo2.resolve('emergency.headline', 'EN');
    expect((cached as ContentResolved).version, 3);
  });

  test('CONTENT_NOT_APPROVED evicts stale cache and falls to seed or closed',
      () async {
    // First a good response, cached.
    var approved = true;
    final adapter = FakeAdapter(
      (o) => approved ? _ok('checkin.q1_temp', 'EN', 'old text', 1) : _notApproved,
    );
    final repo = _repo(db, adapter);
    await repo.resolve('checkin.q1_temp', 'EN');

    // Approval revoked server-side.
    approved = false;
    final r = await repo.resolve('checkin.q1_temp', 'EN');
    // Not in the seed → hard fail closed, and the stale cache is gone.
    expect(r, isA<ContentNotApproved>());
    final offlineRepo =
        _repo(db, FakeAdapter((o) => throw StateError('down')));
    final after = await offlineRepo.resolve('checkin.q1_temp', 'EN');
    expect(after, isNot(isA<ContentResolved>()),
        reason: 'revoked content must not resurface from cache');
  });

  test('seed serves ONLY when placeholders are allowed', () async {
    final adapter = FakeAdapter((o) => _notApproved);

    final demo = _repo(db, adapter);
    final r1 = await demo.resolve('today.title', 'EN');
    expect(r1, isA<ContentResolved>());
    expect((r1 as ContentResolved).fromBundledSeed, isTrue);
    expect(r1.isPlaceholder, isTrue);

    final prod = _repo(db, adapter, allowSeed: false);
    final r2 = await prod.resolve('today.title', 'EN');
    expect(r2, isA<ContentNotApproved>(),
        reason: 'production builds fail closed with no seed');
  });

  test('NO language fallback — UZ never returns the EN string', () async {
    final adapter = FakeAdapter((o) {
      final lang = o.uri.queryParameters['lang'];
      return lang == 'EN'
          ? _ok('today.title', 'EN', 'english text', 2)
          : _notApproved;
    });
    final repo = _repo(db, adapter, allowSeed: false);

    await repo.resolve('today.title', 'EN'); // caches EN
    final uz = await repo.resolve('today.title', 'UZ');
    expect(uz, isA<ContentNotApproved>(),
        reason: 'a patient expecting Uzbek must never be shown English');
  });

  test('cache invalidates when the server version increments', () async {
    var version = 1;
    final adapter =
        FakeAdapter((o) => _ok('contact.button', 'EN', 'v$version', version));
    final repo = _repo(db, adapter);

    final first = await repo.resolve('contact.button', 'EN');
    expect((first as ContentResolved).text, 'v1');

    version = 2;
    final second = await repo.resolve('contact.button', 'EN');
    expect((second as ContentResolved).text, 'v2');
    expect(second.version, 2);
  });

  test('interpolation fills known tokens and exposes unknown ones', () {
    final vars = standardVars(
      clinicName: 'Sehat Clinic (DEMO)',
      clinicPhone: '+998 71 200 00 00',
      n: 6,
    );
    expect(
      interpolate('Day {N} of 30 — {CLINIC_NAME}', vars),
      'Day 6 of 30 — Sehat Clinic (DEMO)',
    );
    // Unknown token stays visible — a template mistake must be seen in QA.
    expect(interpolate('{NOT_A_TOKEN}', vars), '{NOT_A_TOKEN}');
  });
}
