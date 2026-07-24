/// Environment configuration.
///
/// Nothing is hardcoded (ADR: "Configuration — nothing hardcoded").
/// The API base URL arrives at build time:
///
///   flutter run --dart-define=API_BASE_URL=https://api.hospital-ai.uz/v1
///
/// The app refuses to start without it — see [Env.requireValid] called
/// from `main()`. Failing at startup beats failing on the first request
/// a patient makes.
abstract final class Env {
  static const String apiBaseUrl = String.fromEnvironment('API_BASE_URL');

  /// Set to `true` only for `flutter test` runs, where widget tests supply
  /// their own fakes and no network is ever touched.
  static const bool isTest = bool.fromEnvironment('FLUTTER_TEST');

  static bool get isConfigured => apiBaseUrl.isNotEmpty;

  static void requireValid() {
    if (isTest) return;
    if (!isConfigured) {
      throw StateError(
        'API_BASE_URL is not set. '
        'Run with --dart-define=API_BASE_URL=https://api.hospital-ai.uz/v1',
      );
    }
    final uri = Uri.tryParse(apiBaseUrl);
    if (uri == null || !uri.isAbsolute) {
      throw StateError('API_BASE_URL is not an absolute URL: $apiBaseUrl');
    }
  }
}
