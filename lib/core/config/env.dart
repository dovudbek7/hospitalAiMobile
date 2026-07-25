import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kDebugMode;

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
  /// Defaults ON in debug builds so the product is walkable before a real
  /// enrolment code exists; OFF in release/profile. Override explicitly:
  ///   --dart-define=DEMO_MODE=false   (debug run against the live API)
  ///   --dart-define=DEMO_MODE=true    (a demo release build)
  static bool get demoMode =>
      !isTest &&
      (const bool.hasEnvironment('DEMO_MODE')
          ? const bool.fromEnvironment('DEMO_MODE')
          : kDebugMode);

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
