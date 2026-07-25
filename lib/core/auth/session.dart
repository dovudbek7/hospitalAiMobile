import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Non-sensitive session flags. Tokens are NOT here — they live in the
/// secure store. These flags only shape routing.
@immutable
class SessionSnapshot {
  const SessionSnapshot({
    this.language,
    this.hasSession = false,
    this.consented = false,
    this.patientId,
    this.clinicId,
  });

  /// Chosen on P1 before any session exists; server-authoritative later.
  final String? language;
  final bool hasSession;
  final bool consented;
  final String? patientId;
  final String? clinicId;

  bool get onboarded => hasSession && consented;

  SessionSnapshot copyWith({
    String? language,
    bool? hasSession,
    bool? consented,
    String? patientId,
    String? clinicId,
  }) {
    return SessionSnapshot(
      language: language ?? this.language,
      hasSession: hasSession ?? this.hasSession,
      consented: consented ?? this.consented,
      patientId: patientId ?? this.patientId,
      clinicId: clinicId ?? this.clinicId,
    );
  }
}

/// Loaded before runApp so the router can decide the first frame
/// synchronously (returning patients land straight on Today, handoff §5).
final sharedPrefsProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('override in main()'),
);

class SessionController extends Notifier<SessionSnapshot> {
  static const _kLanguage = 'session.language';
  static const _kHasSession = 'session.has_session';
  static const _kConsented = 'session.consented';
  static const _kPatientId = 'session.patient_id';
  static const _kClinicId = 'session.clinic_id';

  SharedPreferences get _prefs => ref.read(sharedPrefsProvider);

  @override
  SessionSnapshot build() {
    final p = _prefs;
    return SessionSnapshot(
      language: p.getString(_kLanguage),
      hasSession: p.getBool(_kHasSession) ?? false,
      consented: p.getBool(_kConsented) ?? false,
      patientId: p.getString(_kPatientId),
      clinicId: p.getString(_kClinicId),
    );
  }

  Future<void> setLanguage(String lang) async {
    await _prefs.setString(_kLanguage, lang);
    state = state.copyWith(language: lang);
  }

  Future<void> sessionCreated({
    required String patientId,
    required String clinicId,
  }) async {
    await _prefs.setBool(_kHasSession, true);
    await _prefs.setString(_kPatientId, patientId);
    await _prefs.setString(_kClinicId, clinicId);
    state = state.copyWith(
      hasSession: true,
      patientId: patientId,
      clinicId: clinicId,
    );
  }

  Future<void> markConsented() async {
    await _prefs.setBool(_kConsented, true);
    state = state.copyWith(consented: true);
  }

  /// P4 Decline / withdrawal: drop everything local. Decline must leave
  /// zero personal data on the device.
  Future<void> clear({bool keepLanguage = true}) async {
    final lang = keepLanguage ? state.language : null;
    await _prefs.remove(_kHasSession);
    await _prefs.remove(_kConsented);
    await _prefs.remove(_kPatientId);
    await _prefs.remove(_kClinicId);
    if (!keepLanguage) await _prefs.remove(_kLanguage);
    state = SessionSnapshot(language: lang);
  }
}

final sessionProvider = NotifierProvider<SessionController, SessionSnapshot>(
  SessionController.new,
);
