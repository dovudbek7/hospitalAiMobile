import 'package:flutter/foundation.dart';

/// Machine-readable API error codes — the full set the backend emits.
enum ApiErrorCode {
  validationError('VALIDATION_ERROR'),
  unauthorized('UNAUTHORIZED'),
  forbidden('FORBIDDEN'),
  notFound('NOT_FOUND'),
  wrongTokenAudience('WRONG_TOKEN_AUDIENCE'),
  duplicateRequest('DUPLICATE_REQUEST'),
  contentNotApproved('CONTENT_NOT_APPROVED'),
  clinicalContentNotApproved('CLINICAL_CONTENT_NOT_APPROVED'),
  crossClinicForbidden('CROSS_CLINIC_FORBIDDEN'),
  internalError('INTERNAL_ERROR'),
  // Anything the backend adds later — handled, never crashed on.
  unknown('UNKNOWN');

  const ApiErrorCode(this.wire);

  final String wire;

  static ApiErrorCode parse(String? raw) => ApiErrorCode.values.firstWhere(
        (c) => c.wire == raw,
        orElse: () => ApiErrorCode.unknown,
      );
}

/// Parsed error envelope: `{ "code": "…", "message": "…", "details": {} }`.
///
/// **`message` is a developer diagnostic** — English, not clinician-approved.
/// It is `@visibleForTesting` so it cannot casually reach a widget; patient
/// UI maps [code] to a content-library key instead (standing rule 9).
@immutable
class ApiError implements Exception {
  const ApiError({
    required this.code,
    required String message,
    this.details = const <String, dynamic>{},
    this.statusCode,
    // ignore: prefer_initializing_formals — the field is private on purpose
  }) : _message = message;

  final ApiErrorCode code;
  final String _message;
  final Map<String, dynamic> details;
  final int? statusCode;

  @visibleForTesting
  String get message => _message;

  static ApiError? tryParse(Object? body, {int? statusCode}) {
    if (body is! Map<String, dynamic>) return null;
    final raw = body['code'];
    if (raw is! String) return null;
    return ApiError(
      code: ApiErrorCode.parse(raw),
      message: body['message'] is String ? body['message'] as String : '',
      details: body['details'] is Map<String, dynamic>
          ? body['details'] as Map<String, dynamic>
          : const <String, dynamic>{},
      statusCode: statusCode,
    );
  }

  @override
  String toString() => 'ApiError(${code.wire}, http $statusCode)';
}

/// The device could not reach the server at all (offline, DNS, timeout).
/// Distinct from [ApiError]: the server never spoke.
@immutable
class NetworkUnavailable implements Exception {
  const NetworkUnavailable([this.cause]);

  final Object? cause;

  @override
  String toString() => 'NetworkUnavailable($cause)';
}
