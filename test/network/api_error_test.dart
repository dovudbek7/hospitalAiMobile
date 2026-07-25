import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:hospital_ai/core/network/api_error.dart';
import 'package:hospital_ai/core/network/error_content_map.dart';

void main() {
  test('every wire code parses to its enum value', () {
    const codes = {
      'VALIDATION_ERROR': ApiErrorCode.validationError,
      'UNAUTHORIZED': ApiErrorCode.unauthorized,
      'FORBIDDEN': ApiErrorCode.forbidden,
      'NOT_FOUND': ApiErrorCode.notFound,
      'WRONG_TOKEN_AUDIENCE': ApiErrorCode.wrongTokenAudience,
      'DUPLICATE_REQUEST': ApiErrorCode.duplicateRequest,
      'CONTENT_NOT_APPROVED': ApiErrorCode.contentNotApproved,
      'CLINICAL_CONTENT_NOT_APPROVED': ApiErrorCode.clinicalContentNotApproved,
      'CROSS_CLINIC_FORBIDDEN': ApiErrorCode.crossClinicForbidden,
      'INTERNAL_ERROR': ApiErrorCode.internalError,
    };
    codes.forEach((wire, expected) {
      expect(ApiErrorCode.parse(wire), expected, reason: wire);
    });
    expect(ApiErrorCode.parse('SOMETHING_NEW'), ApiErrorCode.unknown);
    expect(ApiErrorCode.parse(null), ApiErrorCode.unknown);
  });

  test('every code maps to a content key — never raw text', () {
    for (final code in ApiErrorCode.values) {
      final key = ErrorContent.keyFor(code);
      expect(key, isNotEmpty);
      // A content key, not a sentence.
      expect(key.contains(' '), isFalse, reason: '$code -> $key');
    }
  });

  test('parses the live CONTENT_NOT_APPROVED envelope', () {
    final body = jsonDecode(
      File('test/fixtures/error_content_not_approved_live.json')
          .readAsStringSync(),
    ) as Map<String, dynamic>;
    final err = ApiError.tryParse(body, statusCode: 404)!;
    expect(err.code, ApiErrorCode.contentNotApproved);
    expect(err.details['contentKey'], 'today.title');
    expect(ErrorContent.keyFor(err.code), ErrorContent.notInLanguage);
  });

  test('parses the live UNAUTHORIZED envelope', () {
    final body = jsonDecode(
      File('test/fixtures/error_unauthorized_live.json').readAsStringSync(),
    ) as Map<String, dynamic>;
    final err = ApiError.tryParse(body, statusCode: 401)!;
    expect(err.code, ApiErrorCode.unauthorized);
  });

  test('non-envelope bodies do not parse', () {
    expect(ApiError.tryParse('plain string'), isNull);
    expect(ApiError.tryParse({'error': 'nope'}), isNull);
    expect(ApiError.tryParse(null), isNull);
  });
}
