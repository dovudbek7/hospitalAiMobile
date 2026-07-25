import 'package:dio/dio.dart';

import '../models/api_models.dart';
import '../network/api_error.dart';

/// The complete patient API surface — 14 calls, nothing else.
///
/// Every method either returns a typed model or throws [ApiError] /
/// [NetworkUnavailable] (mapped by the interceptors). No screen talks to
/// Dio directly.
class PatientApi {
  PatientApi(this._dio);

  final Dio _dio;

  /// 1 · POST /auth/patient/session — no auth.
  Future<PatientSession> createSession({
    required String code,
    required String phone,
  }) async {
    final r = await _dio.post<Map<String, dynamic>>(
      '/auth/patient/session',
      data: {'code': code, 'phone': phone},
      options: Options(extra: {'skipAuth': true}),
    );
    return PatientSession.fromJson(r.data!);
  }

  /// 2 · POST /me/consent — idempotent; fires patient_enrolled server-side.
  Future<void> submitConsent({required String version}) async {
    await _dio.post<dynamic>('/me/consent', data: {'version': version});
  }

  /// 3 · GET /me/profile
  Future<Profile> getProfile() async {
    final r = await _dio.get<Map<String, dynamic>>('/me/profile');
    return Profile.fromJson(r.data!);
  }

  /// 4 · GET /me/today
  Future<TodayResponse> getToday() async {
    final r = await _dio.get<Map<String, dynamic>>('/me/today');
    return TodayResponse.fromJson(r.data!);
  }

  /// 5 · POST /tasks/{id}/complete — Idempotency-Key REQUIRED. The same key
  /// must be replayed on retry (persisted with the queued action, F5).
  /// [uncomplete] logs a correction as a NEW event, never a mutation.
  Future<void> completeTask({
    required String taskId,
    required String idempotencyKey,
    String? occurredAt,
    bool uncomplete = false,
  }) async {
    await _dio.post<dynamic>(
      '/tasks/$taskId/complete',
      data: <String, dynamic>{
        'occurredAt': ?occurredAt,
        if (uncomplete) 'uncomplete': true,
      },
      options: Options(headers: {'Idempotency-Key': idempotencyKey}),
    );
  }

  /// 6 · GET /me/progress
  Future<ProgressResponse> getProgress() async {
    final r = await _dio.get<Map<String, dynamic>>('/me/progress');
    return ProgressResponse.fromJson(r.data!);
  }

  /// 7 · GET /me/checkin/questions — labels arrive pre-translated.
  Future<List<CheckinQuestion>> getCheckinQuestions() async {
    final r = await _dio.get<List<dynamic>>('/me/checkin/questions');
    return [
      for (final q in r.data!)
        CheckinQuestion.fromJson(q as Map<String, dynamic>),
    ];
  }

  /// 8 · POST /checkins — Idempotency-Key REQUIRED. Returns the server's
  /// tier; the client routes on it verbatim (standing rule 7).
  Future<CheckinResult> submitCheckin({
    required List<Map<String, dynamic>> answers,
    required String idempotencyKey,
    String questionSetVersion = 'placeholder-v1',
  }) async {
    final r = await _dio.post<Map<String, dynamic>>(
      '/checkins',
      data: {'questionSetVersion': questionSetVersion, 'answers': answers},
      options: Options(headers: {'Idempotency-Key': idempotencyKey}),
    );
    return CheckinResult.fromJson(r.data!);
  }

  /// 9 · GET /content/{key}?lang= — lang REQUIRED, resolver never falls back.
  Future<ContentItem> getContent({
    required String key,
    required String lang,
  }) async {
    final r = await _dio.get<Map<String, dynamic>>(
      '/content/$key',
      queryParameters: {'lang': lang},
    );
    return ContentItem.fromJson(r.data!);
  }

  /// 10 · GET /me/content?category=education
  Future<EducationIndex> getEducationIndex() async {
    final r = await _dio.get<Map<String, dynamic>>(
      '/me/content',
      queryParameters: {'category': 'education'},
    );
    return EducationIndex.fromJson(r.data!);
  }

  /// 11 · POST /me/survey — idempotent, day-30 gated server-side.
  Future<void> submitSurvey(SurveyPayload payload) async {
    await _dio.post<dynamic>(
      '/me/survey',
      data: payload.toJson()..removeWhere((_, v) => v == null),
    );
  }

  /// 12 · PATCH /me/language
  Future<void> setLanguage(String language) async {
    await _dio.patch<dynamic>('/me/language', data: {'language': language});
  }

  /// 13 · POST /me/leave — self-withdraw; stops tasks, retains data.
  Future<LeaveResponse> leaveProgramme() async {
    final r = await _dio.post<Map<String, dynamic>>('/me/leave');
    return LeaveResponse.fromJson(r.data ?? const {});
  }

  /// 14 · POST /me/app-opened — engagement telemetry.
  Future<void> appOpened() async {
    await _dio.post<dynamic>('/me/app-opened');
  }
}
