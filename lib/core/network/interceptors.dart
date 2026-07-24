import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'api_error.dart';
import 'token_store.dart';

/// Attaches the patient bearer token.
///
/// Session rule (handoff §3): the session persists for the whole 30-day
/// programme — **never force re-login**. On 401 the interceptor surfaces the
/// error; it does not clear tokens or route to login. (The backend exposes
/// no patient refresh endpoint — the 60-day refresh token is unusable until
/// one exists. Flagged to the backend owner in md/steps.md.)
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokens);

  final TokenStore _tokens;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra['skipAuth'] != true) {
      final token = await _tokens.readAccessToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }
}

/// The two endpoints where a replayed request MUST be deduplicated
/// server-side. A missing key here means offline sync could double-post a
/// symptom report — so in debug builds it is a hard crash, not a warning.
class IdempotencyInterceptor extends Interceptor {
  static final _required = [
    RegExp(r'/tasks/[^/]+/complete$'),
    RegExp(r'/checkins$'),
  ];

  static bool requiresKey(String method, String path) =>
      method.toUpperCase() == 'POST' &&
      _required.any((r) => r.hasMatch(path));

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (requiresKey(options.method, options.uri.path)) {
      final key = options.headers['Idempotency-Key'];
      if (key == null || (key is String && key.isEmpty)) {
        assert(
          false,
          'Idempotency-Key is REQUIRED on ${options.uri.path} — generate a '
          'uuid per logical action and persist it for retries.',
        );
        // In release, refuse to send rather than risk a duplicate checkin.
        handler.reject(
          DioException(
            requestOptions: options,
            error: StateError('missing Idempotency-Key'),
            type: DioExceptionType.unknown,
          ),
        );
        return;
      }
    }
    handler.next(options);
  }
}

/// Turns transport failures into [NetworkUnavailable] and API envelopes into
/// [ApiError], so callers deal with exactly two failure types.
class ErrorMappingInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        handler.reject(err.copyWith(error: NetworkUnavailable(err.error)));
        return;
      case DioExceptionType.badResponse:
        final parsed = ApiError.tryParse(
          err.response?.data,
          statusCode: err.response?.statusCode,
        );
        if (parsed != null) {
          handler.reject(err.copyWith(error: parsed));
          return;
        }
        handler.reject(
          err.copyWith(
            error: ApiError(
              code: ApiErrorCode.unknown,
              message: 'HTTP ${err.response?.statusCode}',
              statusCode: err.response?.statusCode,
            ),
          ),
        );
        return;
      case DioExceptionType.badCertificate:
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
      default:
        handler.next(err);
    }
  }
}

/// Backoff retry on transport failures only, and only where a retry is safe:
/// idempotent verbs, plus the two POSTs that carry an Idempotency-Key (their
/// replay is deduplicated server-side by design).
class RetryInterceptor extends Interceptor {
  RetryInterceptor(this._dio, {this.maxRetries = 2});

  final Dio _dio;
  final int maxRetries;

  static bool _retriable(RequestOptions o) =>
      o.method == 'GET' ||
      IdempotencyInterceptor.requiresKey(o.method, o.uri.path);

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final transportFailure = switch (err.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.connectionError =>
        true,
      _ => false,
    };
    final attempt = (err.requestOptions.extra['retryAttempt'] as int?) ?? 0;

    if (!transportFailure ||
        !_retriable(err.requestOptions) ||
        attempt >= maxRetries) {
      handler.next(err);
      return;
    }

    await Future<void>.delayed(
      Duration(milliseconds: 500 * (1 << attempt)),
    );
    try {
      final options = err.requestOptions
        ..extra['retryAttempt'] = attempt + 1;
      final response = await _dio.fetch<dynamic>(options);
      handler.resolve(response);
    } on DioException catch (retryErr) {
      handler.next(retryErr);
    } catch (e) {
      if (kDebugMode) debugPrint('retry failed: $e');
      handler.next(err);
    }
  }
}
