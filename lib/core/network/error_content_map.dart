import 'api_error.dart';

/// Standing rule 9: never render the API's `message` to a patient. Every
/// error code maps to a content-library key; the Txt widget resolves it and,
/// if the key itself is missing/unapproved, fails closed to the panel with
/// the clinic contact — so the worst case is still safe.
///
/// NOTE for the backend owner: the `error.*` keys below need seeding in the
/// content library (EN/UZ/RU). Until then they fail closed by design.
abstract final class ErrorContent {
  static const generic = 'error.generic';
  static const session = 'error.session';
  static const offlineCheckin = 'offline.checkin_blocked';
  static const notInLanguage = 'content.unavailable_in_language';

  static String keyFor(ApiErrorCode code) => switch (code) {
        ApiErrorCode.contentNotApproved => notInLanguage,
        ApiErrorCode.clinicalContentNotApproved => notInLanguage,
        ApiErrorCode.unauthorized => session,
        ApiErrorCode.wrongTokenAudience => session,
        ApiErrorCode.validationError => generic,
        ApiErrorCode.forbidden => generic,
        ApiErrorCode.notFound => generic,
        ApiErrorCode.crossClinicForbidden => generic,
        ApiErrorCode.internalError => generic,
        // Duplicate replay returns the ORIGINAL result server-side; if one
        // still surfaces as an error it is a programming bug — show generic.
        ApiErrorCode.duplicateRequest => generic,
        ApiErrorCode.unknown => generic,
      };
}
