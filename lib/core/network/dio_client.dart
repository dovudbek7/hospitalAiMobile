import 'package:dio/dio.dart';

import '../config/env.dart';
import 'interceptors.dart';
import 'token_store.dart';

/// Builds the app's Dio instance. Timeouts are tuned for the pilot region's
/// poor connectivity: fail fast enough to fall back to cache, slow enough
/// not to give up on a working 2G link.
Dio buildDio({
  required TokenStore tokens,
  String? baseUrl,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl ?? Env.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      headers: {'Accept': 'application/json'},
    ),
  );
  dio.interceptors.addAll([
    AuthInterceptor(tokens),
    IdempotencyInterceptor(),
    RetryInterceptor(dio),
    ErrorMappingInterceptor(),
  ]);
  return dio;
}
