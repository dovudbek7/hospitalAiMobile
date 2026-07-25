import 'package:flutter_test/flutter_test.dart';

import 'package:hospital_ai/core/auth/session.dart';
import 'package:hospital_ai/core/router/guards.dart';

void main() {
  const fresh = SessionSnapshot();
  const hasLang = SessionSnapshot(language: 'UZ');
  const enrolled = SessionSnapshot(language: 'UZ', hasSession: true);
  const onboarded = SessionSnapshot(
    language: 'UZ',
    hasSession: true,
    consented: true,
    patientId: 'p1',
    clinicId: 'c1',
  );

  test('no language → everything routes to P1', () {
    expect(sessionRedirect(fresh, Routes.today), Routes.language);
    expect(sessionRedirect(fresh, Routes.code), Routes.language);
    expect(sessionRedirect(fresh, Routes.survey), Routes.language);
    expect(sessionRedirect(fresh, Routes.language), isNull);
  });

  test('language but no session → only P1–P3 reachable', () {
    expect(sessionRedirect(hasLang, Routes.code), isNull);
    expect(sessionRedirect(hasLang, Routes.phone), isNull);
    expect(sessionRedirect(hasLang, Routes.language), isNull);
    expect(sessionRedirect(hasLang, Routes.today), Routes.code);
    expect(sessionRedirect(hasLang, Routes.consent), Routes.code);
  });

  test('session without consent → pinned to P4, Today unreachable', () {
    expect(sessionRedirect(enrolled, Routes.consent), isNull);
    expect(sessionRedirect(enrolled, Routes.today), Routes.consent);
    expect(sessionRedirect(enrolled, Routes.welcome), Routes.consent);
    expect(sessionRedirect(enrolled, Routes.checkin), Routes.consent);
  });

  test('onboarded → returning patient lands on Today; onboarding redirects',
      () {
    expect(sessionRedirect(onboarded, Routes.today), isNull);
    expect(sessionRedirect(onboarded, Routes.checkin), isNull);
    expect(sessionRedirect(onboarded, Routes.survey), isNull);
    expect(sessionRedirect(onboarded, Routes.language), Routes.today);
    expect(sessionRedirect(onboarded, Routes.code), Routes.today);
    expect(sessionRedirect(onboarded, Routes.consent), Routes.today);
    // P5 stays reachable right after consent.
    expect(sessionRedirect(onboarded, Routes.welcome), isNull);
  });

  test('the emergency screen is NEVER redirected away from', () {
    for (final snapshot in [fresh, hasLang, enrolled, onboarded]) {
      expect(
        sessionRedirect(snapshot, Routes.emergency),
        isNull,
        reason: 'P13 must be reachable in every session state',
      );
    }
  });
}
