import '../auth/session.dart';

/// Route names — one place, so guards and screens agree.
abstract final class Routes {
  static const language = '/language';
  static const code = '/code';
  static const phone = '/phone';
  static const consent = '/consent';
  static const welcome = '/welcome';

  static const today = '/today';
  static const progress = '/progress';
  static const learn = '/learn';
  static const settings = '/settings';

  static const task = '/task';
  static const medication = '/medication';
  static const checkin = '/checkin';
  static const checkinResult = '/checkin/result';
  static const emergency = '/emergency';
  static const article = '/article';
  static const survey = '/survey';
  static const gallery = '/dev/gallery';
}

const _onboardingLocations = {
  Routes.language,
  Routes.code,
  Routes.phone,
  Routes.consent,
  Routes.welcome,
};

/// Pure redirect logic (unit-tested in test/auth/guards_test.dart).
///
/// Rules, in order:
///  1. No language chosen → P1, whatever was asked for.
///  2. Language but no session → only P1–P3 reachable.
///  3. Session but no consent → pinned to P4 (informed consent before ANY
///     data collection; P5/Today unreachable).
///  4. Fully onboarded → onboarding screens redirect to Today. Returning
///     patients open straight on Today (handoff §5).
///
/// The emergency screen is NEVER redirected away from — if something is on
/// /emergency it stays there regardless of session state.
String? sessionRedirect(SessionSnapshot s, String location) {
  if (location == Routes.emergency) return null;
  if (location == Routes.gallery) return null;

  final wantsOnboarding =
      _onboardingLocations.any((l) => location == l) ||
          location.startsWith(Routes.language);

  if (s.language == null) {
    return location == Routes.language ? null : Routes.language;
  }

  if (!s.hasSession) {
    const allowed = {Routes.language, Routes.code, Routes.phone};
    return allowed.contains(location) ? null : Routes.code;
  }

  if (!s.consented) {
    return location == Routes.consent ? null : Routes.consent;
  }

  // Fully onboarded.
  if (wantsOnboarding && location != Routes.welcome) {
    return Routes.today;
  }
  return null;
}
