import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../api/patient_api.dart';
import '../network/api_error.dart';
import '../storage/app_database.dart';
import 'content_result.dart';

/// Resolution order (documented deviation — md/steps.md "Ratified deviations"):
///
///  1. **Server** — always authoritative. Success caches; an explicit
///     CONTENT_NOT_APPROVED deletes any cached row (approval can be revoked).
///  2. **Bundled seed** — the Content Pack strings shipped in
///     assets/content/seed_content.json, every entry `isPlaceholder: true`,
///     version 0 (a real server version always wins). Serves ONLY when
///     [allowBundledPlaceholders] is true — the app-side mirror of the
///     backend's ALLOW_PLACEHOLDER_CONTENT gate. In production builds this
///     is false and behaviour is strict fail-closed.
///  3. **Cache** — offline reads.
///  4. Fail closed / unavailable.
///
/// Why the seed exists: the live demo server currently seeds only the
/// safety-critical keys (emergency.*, checkin.*, contact.*). Without the
/// seed every other screen fails closed and nothing is demonstrable. The
/// seed changes no architecture: same keys, same placeholder flags, same
/// fail-closed path for anything not in the Pack, and the server replaces
/// it the moment a key is seeded there.
class ContentRepository {
  ContentRepository(
    this._api,
    this._db, {
    this.allowBundledPlaceholders = true,
    Future<String> Function(String path)? loadAsset,
  }) : _loadAsset = loadAsset ?? rootBundle.loadString;

  final PatientApi _api;
  final AppDatabase _db;
  final bool allowBundledPlaceholders;
  final Future<String> Function(String path) _loadAsset;

  Map<String, dynamic>? _seed;

  Future<Map<String, dynamic>> _seedMap() async {
    if (_seed != null) return _seed!;
    try {
      final raw = await _loadAsset('assets/content/seed_content.json');
      _seed = jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      _seed = const {};
    }
    return _seed!;
  }

  Future<ContentResolved?> _fromSeed(String key, String lang) async {
    if (!allowBundledPlaceholders) return null;
    final entry = (await _seedMap())[key];
    if (entry is! Map<String, dynamic>) return null;
    final byLang = entry[lang];
    if (byLang is! Map<String, dynamic>) return null;
    final text = byLang['text'];
    if (text is! String) return null;
    return ContentResolved(
      text: text,
      version: (byLang['version'] as num?)?.toInt() ?? 0,
      isPlaceholder: true,
      fromBundledSeed: true,
    );
  }

  Future<ContentResolved?> _fromCache(String key, String lang) async {
    final row = await (_db.select(_db.contentCacheRows)
          ..where((r) => r.contentKey.equals(key) & r.language.equals(lang)))
        .getSingleOrNull();
    if (row == null) return null;
    return ContentResolved(
      text: row.body,
      version: row.version,
      isPlaceholder: row.isPlaceholder,
    );
  }

  Future<void> _cache(
    String key,
    String lang,
    String text,
    int version,
    bool isPlaceholder,
  ) async {
    await _db.into(_db.contentCacheRows).insertOnConflictUpdate(
          ContentCacheRowsCompanion.insert(
            contentKey: key,
            language: lang,
            version: version,
            body: text,
            isPlaceholder: Value(isPlaceholder),
            fetchedAt: DateTime.now().millisecondsSinceEpoch,
          ),
        );
  }

  Future<void> _evict(String key, String lang) async {
    await (_db.delete(_db.contentCacheRows)
          ..where((r) => r.contentKey.equals(key) & r.language.equals(lang)))
        .go();
  }

  /// Resolve [key] in [lang]. `lang` is required and there is NO language
  /// fallback anywhere in this method — a patient who expects Uzbek is never
  /// shown Russian (golden rule 3).
  Future<ContentResult> resolve(String key, String lang) async {
    try {
      final item = await _api.getContent(key: key, lang: lang);
      await _cache(key, lang, item.text, item.version, item.isPlaceholder);
      return ContentResolved(
        text: item.text,
        version: item.version,
        isPlaceholder: item.isPlaceholder,
      );
    } on DioException catch (e) {
      final err = e.error;
      if (err is ApiError &&
          (err.code == ApiErrorCode.contentNotApproved ||
              err.code == ApiErrorCode.clinicalContentNotApproved)) {
        // Explicit refusal: never keep stale text around.
        await _evict(key, lang);
        final seeded = await _fromSeed(key, lang);
        if (seeded != null) return seeded;
        return ContentNotApproved(contentKey: key, language: lang);
      }
      // Transport failure or any other error → offline path.
      final cached = await _fromCache(key, lang);
      if (cached != null) return cached;
      final seeded = await _fromSeed(key, lang);
      if (seeded != null) return seeded;
      return ContentUnavailable(contentKey: key, language: lang);
    }
  }

  /// Warm the cache for a set of keys (enrolment / language change).
  Future<void> prefetch(Iterable<String> keys, String lang) async {
    for (final key in keys) {
      await resolve(key, lang);
    }
  }
}
