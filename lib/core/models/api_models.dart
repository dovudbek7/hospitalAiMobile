// Typed models for the 14-call patient API surface.
//
// Shapes come from md/HOSPITAL_AI_FLUTTER_HANDOFF.md §3/§5/§6 and the live
// OpenAPI at /v1/docs-json. Parsing is deliberately lenient on fields the
// backend may add — unknown keys are ignored — but strict on the ones the
// app's safety behaviour depends on (tier, status, language, versions).

import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_models.freezed.dart';
part 'api_models.g.dart';

/// POST /auth/patient/session
@freezed
abstract class PatientSession with _$PatientSession {
  const factory PatientSession({
    required String audience,
    required String accessToken,
    required String refreshToken,
    required String patientId,
    required String clinicId,
  }) = _PatientSession;

  factory PatientSession.fromJson(Map<String, dynamic> json) =>
      _$PatientSessionFromJson(json);
}

/// Clinic block inside GET /me/profile — per-clinic config. Patient-visible
/// values (name, phone, emergency number, hours) are injected into content
/// strings; never hardcoded.
@freezed
abstract class Clinic with _$Clinic {
  const factory Clinic({
    required String name,
    required String phone,
    String? emergencyNumber,
    String? workingHours,
    String? workingDays,
    String? timezone,
  }) = _Clinic;

  factory Clinic.fromJson(Map<String, dynamic> json) => _$ClinicFromJson(json);
}

/// GET /me/profile
@freezed
abstract class Profile with _$Profile {
  const factory Profile({
    String? name,
    required int recoveryDay,
    int? programmeDays,
    required String language,
    String? procedureType,
    String? consentVersion,
    Clinic? clinic,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}

/// One task instance inside GET /me/today.
@freezed
abstract class PatientTask with _$PatientTask {
  const factory PatientTask({
    required String id,
    required String taskType,
    required String contentRef,
    required String scheduledFor,
    String? windowClosesAt,
    required String status,
    bool? onTime,
  }) = _PatientTask;

  factory PatientTask.fromJson(Map<String, dynamic> json) =>
      _$PatientTaskFromJson(json);
}

/// GET /me/today — tasks grouped by type + whether a check-in is due.
@freezed
abstract class TodayResponse with _$TodayResponse {
  const factory TodayResponse({
    required int recoveryDay,
    required Map<String, List<PatientTask>> groups,
    required bool checkinDue,
  }) = _TodayResponse;

  factory TodayResponse.fromJson(Map<String, dynamic> json) =>
      _$TodayResponseFromJson(json);
}

/// Adherence fraction — the denominator is always shown in UI (P9 rule).
@freezed
abstract class Adherence with _$Adherence {
  const factory Adherence({
    required double value,
    required int numerator,
    required int denominator,
  }) = _Adherence;

  factory Adherence.fromJson(Map<String, dynamic> json) =>
      _$AdherenceFromJson(json);
}

@freezed
abstract class PerDayAdherence with _$PerDayAdherence {
  const factory PerDayAdherence({
    required int recoveryDay,
    required double value,
    required int numerator,
    required int denominator,
  }) = _PerDayAdherence;

  factory PerDayAdherence.fromJson(Map<String, dynamic> json) =>
      _$PerDayAdherenceFromJson(json);
}

/// GET /me/progress
@freezed
abstract class ProgressResponse with _$ProgressResponse {
  const factory ProgressResponse({
    required Adherence adherence,
    required int daysCompleted,
    required int programmeDays,
    @Default(<PerDayAdherence>[]) List<PerDayAdherence> perDay,
  }) = _ProgressResponse;

  factory ProgressResponse.fromJson(Map<String, dynamic> json) =>
      _$ProgressResponseFromJson(json);
}

/// An answer option — the label arrives ALREADY translated into the
/// patient's language and is rendered directly (never re-translated).
@freezed
abstract class CheckinOption with _$CheckinOption {
  const factory CheckinOption({
    required String code,
    required String label,
  }) = _CheckinOption;

  factory CheckinOption.fromJson(Map<String, dynamic> json) =>
      _$CheckinOptionFromJson(json);
}

@freezed
abstract class CheckinScale with _$CheckinScale {
  const factory CheckinScale({required int min, required int max}) =
      _CheckinScale;

  factory CheckinScale.fromJson(Map<String, dynamic> json) =>
      _$CheckinScaleFromJson(json);
}

/// GET /me/checkin/questions — question text is a content key (resolved via
/// the content library); allowed types: single / multi / scale / yesno.
@freezed
abstract class CheckinQuestion with _$CheckinQuestion {
  const factory CheckinQuestion({
    required String ref,
    required String questionContentKey,
    required String type,
    @Default(<CheckinOption>[]) List<CheckinOption> options,
    CheckinScale? scale,
  }) = _CheckinQuestion;

  factory CheckinQuestion.fromJson(Map<String, dynamic> json) =>
      _$CheckinQuestionFromJson(json);
}

/// POST /checkins response. `tier` is decided SERVER-SIDE and the client
/// routes on it verbatim — no client-side triage, ever (standing rule 7).
@freezed
abstract class CheckinResult with _$CheckinResult {
  const factory CheckinResult({
    required String checkinId,
    required String tier,
    required String ruleVersion,
    required int recoveryDay,
    required bool withinClinicHours,
    String? contentKey,
    String? body,
    String? escalationId,
  }) = _CheckinResult;

  factory CheckinResult.fromJson(Map<String, dynamic> json) =>
      _$CheckinResultFromJson(json);
}

/// GET /content/{key}?lang= — the content library. `isPlaceholder` is
/// surfaced so demo builds can watermark unapproved copy.
@freezed
abstract class ContentItem with _$ContentItem {
  const factory ContentItem({
    required String contentKey,
    required String language,
    required String text,
    required int version,
    @Default(false) bool isPlaceholder,
  }) = _ContentItem;

  factory ContentItem.fromJson(Map<String, dynamic> json) =>
      _$ContentItemFromJson(json);
}

@freezed
abstract class EducationItem with _$EducationItem {
  const factory EducationItem({
    required String contentKey,
    required int unlockDay,
    String? category,
  }) = _EducationItem;

  factory EducationItem.fromJson(Map<String, dynamic> json) =>
      _$EducationItemFromJson(json);
}

/// GET /me/content?category=education — unlocked content keys only. Items
/// not yet unlocked never reach the client (hidden, not greyed — P14 rule).
@freezed
abstract class EducationIndex with _$EducationIndex {
  const factory EducationIndex({
    String? category,
    String? procedureType,
    required int recoveryDay,
    @Default(<EducationItem>[]) List<EducationItem> items,
  }) = _EducationIndex;

  factory EducationIndex.fromJson(Map<String, dynamic> json) =>
      _$EducationIndexFromJson(json);
}

/// POST /me/survey payload. Scores and categorical values only travel to
/// analytics; `freeText` is write-only on the server and must NEVER be
/// placed into a telemetry event (standing rule 6).
@freezed
abstract class SurveyPayload with _$SurveyPayload {
  const factory SurveyPayload({
    int? q1Helpful,
    int? q2Easy,
    int? q3AdherenceSupport,
    int? q4Recommend,
    String? freeText,
  }) = _SurveyPayload;

  factory SurveyPayload.fromJson(Map<String, dynamic> json) =>
      _$SurveyPayloadFromJson(json);
}

/// POST /me/leave response.
@freezed
abstract class LeaveResponse with _$LeaveResponse {
  const factory LeaveResponse({int? tasksStopped}) = _LeaveResponse;

  factory LeaveResponse.fromJson(Map<String, dynamic> json) =>
      _$LeaveResponseFromJson(json);
}
