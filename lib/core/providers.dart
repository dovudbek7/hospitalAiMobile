import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api/patient_api.dart';
import 'content/content_repository.dart';
import 'content/content_result.dart';
import 'network/dio_client.dart';
import 'network/token_store.dart';
import 'storage/app_database.dart';

// Re-export for callers that only import providers.dart.
export 'config/env.dart' show Env;
export 'content/content_result.dart';

/// Overridden with the secure implementation in F4; in-memory by default so
/// tests and the gallery run without a platform channel.
final tokenStoreProvider = Provider<TokenStore>((ref) => InMemoryTokenStore());

final dioProvider = Provider<Dio>(
  (ref) => buildDio(tokens: ref.watch(tokenStoreProvider)),
);

final patientApiProvider =
    Provider<PatientApi>((ref) => PatientApi(ref.watch(dioProvider)));

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase.open();
  ref.onDispose(db.close);
  return db;
});

/// The interface language (UZ / RU / EN). P1 sets it locally before any
/// session exists; GET /me/profile is authoritative after enrolment.
/// Changing it re-renders every Txt instantly — no restart (P16 rule).
class LanguageNotifier extends Notifier<String> {
  @override
  String build() => 'EN';

  void set(String lang) => state = lang;
}

final languageProvider =
    NotifierProvider<LanguageNotifier, String>(LanguageNotifier.new);

/// {TOKEN} values for content interpolation — clinic config + patient data.
/// Filled by auth/profile loading (F4/F6); screens may add N/TOTAL locally.
class InterpolationVarsNotifier extends Notifier<Map<String, String>> {
  @override
  Map<String, String> build() => const {};

  void set(Map<String, String> vars) => state = Map.unmodifiable(vars);

  void merge(Map<String, String> vars) =>
      state = Map.unmodifiable({...state, ...vars});
}

final interpolationVarsProvider =
    NotifierProvider<InterpolationVarsNotifier, Map<String, String>>(
  InterpolationVarsNotifier.new,
);

/// Mirrors the backend's ALLOW_PLACEHOLDER_CONTENT gate on the app side.
/// True in dev/demo builds; MUST be false for production releases
/// (--dart-define=ALLOW_BUNDLED_PLACEHOLDERS=false).
const allowBundledPlaceholders =
    bool.fromEnvironment('ALLOW_BUNDLED_PLACEHOLDERS', defaultValue: true);

final contentRepositoryProvider = Provider<ContentRepository>(
  (ref) => ContentRepository(
    ref.watch(patientApiProvider),
    ref.watch(databaseProvider),
    allowBundledPlaceholders: allowBundledPlaceholders,
  ),
);

/// Resolve one content key in the current language. Family key includes the
/// language so a language switch can never show the previous language's
/// text — a different provider instance resolves from scratch.
final contentProvider =
    FutureProvider.family<ContentResult, (String, String)>((ref, spec) {
  final (key, lang) = spec;
  return ref.watch(contentRepositoryProvider).resolve(key, lang);
});

/// Convenience: resolve in the CURRENT language.
final txtProvider = FutureProvider.family<ContentResult, String>((ref, key) {
  final lang = ref.watch(languageProvider);
  return ref.watch(contentProvider((key, lang)).future);
});
