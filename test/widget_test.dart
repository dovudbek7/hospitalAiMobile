import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hospital_ai/app.dart';
import 'package:hospital_ai/core/auth/session.dart';
import 'package:hospital_ai/features/onboarding/p1_language_screen.dart';

void main() {
  testWidgets('cold start with no session lands on P1 language selection',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPrefsProvider.overrideWithValue(prefs)],
        child: const HospitalAiApp(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(P1LanguageScreen), findsOneWidget);
    // The three permitted hardcoded strings, each in its own script.
    expect(find.text('Oʻzbekcha'), findsOneWidget);
    expect(find.text('Русский'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
  });

  testWidgets('returning onboarded patient lands straight on the shell',
      (tester) async {
    SharedPreferences.setMockInitialValues({
      'session.language': 'EN',
      'session.has_session': true,
      'session.consented': true,
    });
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPrefsProvider.overrideWithValue(prefs)],
        child: const HospitalAiApp(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.byType(P1LanguageScreen), findsNothing);
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
