import 'dart:io' show Platform;

/// Environment configuration.
///
/// The API base URL defaults to production so a plain `flutter build` ships
/// an API-connected app; override for a local backend:
///
///   flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000/v1
///
/// The region stays configurable (ADR); only the default is baked.
abstract final class Env {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.hospital-ai.uz/v1',
  );

  /// True under `flutter test` (the runner exports FLUTTER_TEST in the
  /// process environment; the dart-define variant is not reliable here).
  /// Tests supply their own fakes and never touch the network.
  static bool get isTest {
    try {
      return Platform.environment['FLUTTER_TEST'] == 'true';
    } catch (_) {
      return false;
    }
  }

  /// DEMO MODE: the in-app fake server (lib/core/demo/demo_server.dart).
  /// OFF by default everywhere — a plain `flutter run` / build talks to the
  /// live API and really validates the code + phone. Turn it on explicitly
  /// only when you want the offline walkthrough:
  ///   --dart-define=DEMO_MODE=true
  static const bool demoMode = bool.fromEnvironment('DEMO_MODE');

  static bool get isConfigured => apiBaseUrl.isNotEmpty;

  static void requireValid() {
    if (isTest) return;
    // Demo mode needs no backend at all.
    if (demoMode) return;
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
