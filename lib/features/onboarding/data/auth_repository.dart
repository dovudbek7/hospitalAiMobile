import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/patient_api.dart';
import '../../../core/auth/session.dart';
import '../../../core/content/content_repository.dart';
import '../../../core/content/emergency_bundle.dart';
import '../../../core/content/interpolate.dart';
import '../../../core/models/api_models.dart';
import '../../../core/network/api_error.dart';
import '../../../core/network/token_store.dart';
import '../../../core/providers.dart';

/// Enrolment + session lifecycle. Session persists indefinitely for the
/// 30-day programme — nothing in this class ever force-logs-out a patient.
class AuthRepository {
  AuthRepository(this._ref);

  final Ref _ref;

  PatientApi get _api => _ref.read(patientApiProvider);
  TokenStore get _tokens => _ref.read(tokenStoreProvider);
  SessionController get _session => _ref.read(sessionProvider.notifier);
  ContentRepository get _content => _ref.read(contentRepositoryProvider);

  /// P2+P3: validate the code + phone pair. On success the tokens land in
  /// secure storage and the session flags flip — but consent has NOT been
  /// given yet; the router keeps the patient on P4.
  ///
  /// Error rules (handoff §3): the caller maps [ApiError.code] to a content
  /// key. Nothing here reveals whether a code exists or what number is
  /// stored.
  Future<void> enrol({required String code, required String phone}) async {
    final normalizedPhone = phone.replaceAll(RegExp(r'[\s-]'), '');
    final session = await _api.createSession(
      code: code.trim().toUpperCase(),
      phone: normalizedPhone,
    );
    await _tokens.write(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
    );
    await _session.sessionCreated(
      patientId: session.patientId,
      clinicId: session.clinicId,
    );
  }

  /// P4 Agree: record consent, then load the profile and warm everything
  /// the app needs to work offline — interpolation vars, the emergency
  /// bundle, and the server-authoritative language.
  Future<Profile?> consentAndBootstrap({required String version}) async {
    await _api.submitConsent(version: version);
    await _session.markConsented();
    // Handoff §4: persist the P1 language choice server-side after
    // enrolment, BEFORE reading the (authoritative) profile back.
    final localLang = _ref.read(sessionProvider).language;
    if (localLang != null) {
      try {
        await _api.setLanguage(localLang);
      } on Exception {
        // Non-fatal; the local choice keeps working offline.
      }
    }
    return bootstrapProfile();
  }

  /// Load /me/profile and propagate clinic config + language into the
  /// content layer. Safe to call on every app start; failures are
  /// non-fatal (cached values keep working).
  Future<Profile?> bootstrapProfile() async {
    try {
      final profile = await _api.getProfile();
      final clinic = profile.clinic;

      if (profile.language.isNotEmpty) {
        _ref.read(languageProvider.notifier).set(profile.language);
        await _session.setLanguage(profile.language);
      }
      _ref.read(interpolationVarsProvider.notifier).set(
            standardVars(
              clinicName: clinic?.name,
              clinicPhone: clinic?.phone,
              emergencyNumber: clinic?.emergencyNumber ?? '103',
              workingHours: clinic?.workingHours,
              workingDays: clinic?.workingDays,
              openingTime: clinic?.workingHours?.split('-').first.trim(),
              firstName: profile.name?.split(' ').first,
              n: profile.recoveryDay,
            ),
          );

      // P13 hard requirement: cache emergency strings + numbers NOW so the
      // emergency screen renders and dials with no network, forever after.
      if (clinic != null) {
        await EmergencyBundle.refresh(
          content: _content,
          language: _ref.read(languageProvider),
          clinicName: clinic.name,
          clinicPhone: clinic.phone,
          ambulanceNumber: clinic.emergencyNumber ?? '103',
        );
      }
      return profile;
    } on DioException catch (e) {
      // Offline or transient server trouble: keep going with cached state.
      // A patient mid-programme is NEVER logged out over this (§3).
      final err = e.error;
      if (err is ApiError || err is NetworkUnavailable) return null;
      rethrow;
    }
  }

  /// P4 Decline: no consent recorded, all local traces removed.
  Future<void> decline() async {
    await _tokens.clear();
    await _ref.read(sessionProvider.notifier).clear();
  }

  /// P16 Leave programme: server first (the clinic must know), then local.
  Future<LeaveResponse> leave() async {
    final result = await _api.leaveProgramme();
    await _tokens.clear();
    await _ref.read(sessionProvider.notifier).clear();
    return result;
  }
}

final authRepositoryProvider = Provider<AuthRepository>(AuthRepository.new);
