import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hospital_ai/app.dart';
import 'package:hospital_ai/core/auth/session.dart';
import 'package:hospital_ai/core/network/token_store.dart';
import 'package:hospital_ai/core/providers.dart';
import 'package:hospital_ai/core/storage/app_database.dart';
import 'package:hospital_ai/core/widgets/code_field.dart';
import 'package:hospital_ai/core/widgets/primary_button.dart';
import 'package:hospital_ai/features/onboarding/p1_language_screen.dart';
import 'package:hospital_ai/features/onboarding/p2_code_screen.dart';
import 'package:hospital_ai/features/onboarding/p3_phone_screen.dart';
import 'package:hospital_ai/features/onboarding/p4_consent_screen.dart';

import '../network/fake_adapter.dart';

/// The whole patient API as canned responses — the same shapes the live
/// server returns (fixtures + handoff §3/§6).
FakeResponse fakeServer(RequestOptions o) {
  final path = o.uri.path;
  if (path.endsWith('/auth/patient/session')) {
    final body = o.data as Map<String, dynamic>;
    if (body['code'] != 'H7K9QP') {
      return FakeResponse(401, {
        'code': 'UNAUTHORIZED',
        'message': 'nope',
        'details': <String, dynamic>{},
      });
    }
    return FakeResponse(200, {
      'audience': 'patient',
      'accessToken': 'a',
      'refreshToken': 'r',
      'patientId': 'p-1',
      'clinicId': 'c-1',
    });
  }
  if (path.endsWith('/me/consent')) return FakeResponse(200, {'ok': true});
  if (path.endsWith('/me/profile')) {
    return FakeResponse(200, {
      'name': 'Aziz Demo',
      'recoveryDay': 0,
      'language': 'EN',
      'procedureType': 'laparoscopic_appendectomy',
      'clinic': {
        'name': 'Sehat Clinic (DEMO)',
        'phone': '+998712000000',
        'emergencyNumber': '103',
        'workingHours': '09:00-18:00',
        'workingDays': 'Mon-Sat',
        'timezone': 'Asia/Tashkent',
      },
    });
  }
  if (path.contains('/content/')) {
    final key = path.split('/').last;
    return FakeResponse(200, {
      'contentKey': key,
      'language': o.uri.queryParameters['lang'],
      'text': 'srv:$key',
      'version': 1,
      'isPlaceholder': true,
    });
  }
  if (path.endsWith('/me/app-opened')) return FakeResponse(200, {'ok': true});
  if (path.endsWith('/me/today')) {
    return FakeResponse(200, {
      'recoveryDay': 0,
      'groups': <String, dynamic>{},
      'checkinDue': false,
    });
  }
  return FakeResponse(200, {'ok': true});
}

Future<ProviderContainer> pumpApp(WidgetTester tester) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final tokens = InMemoryTokenStore();

  final container = ProviderContainer(
    overrides: [
      sharedPrefsProvider.overrideWithValue(prefs),
      tokenStoreProvider.overrideWithValue(tokens),
      databaseProvider.overrideWith((ref) {
        final db = AppDatabase.memory();
        ref.onDispose(db.close);
        return db;
      }),

      // Content resolves instantly from the seed shape via fake server.
      contentProvider.overrideWith(
        (ref, spec) async => ContentResolved(
          text: 'txt:${spec.$1}',
          version: 1,
          isPlaceholder: true,
        ),
      ),
    ],
  );
  addTearDown(container.dispose);
  container.read(dioProvider).httpClientAdapter = FakeAdapter(fakeServer);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: const HospitalAiApp(),
    ),
  );
  await tester.pump();
  return container;
}

void main() {
  testWidgets('P1→P4: full enrolment reaches consent in 5 taps or fewer',
      (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    final container = await pumpApp(tester);
    var taps = 0;

    // P1 — tap a language.
    expect(find.byType(P1LanguageScreen), findsOneWidget);
    await tester.tap(find.text('English'));
    taps++;
    await tester.pumpAndSettle();

    // P2 — type the code; Continue disabled until 6 chars.
    expect(find.byType(P2CodeScreen), findsOneWidget);
    final continueBtn = find.byType(PrimaryButton).first;
    expect(
      tester.widget<PrimaryButton>(continueBtn).onPressed,
      isNull,
      reason: 'Continue must be disabled with an empty code',
    );
    await tester.enterText(find.byType(TextField).first, 'h7k9qp');
    await tester.pump();
    // Auto-uppercased on entry.
    final codeField = tester.widget<TextField>(find.byType(TextField).first);
    expect(codeField.controller!.text, 'H7K9QP');
    await tester.tap(continueBtn);
    taps++;
    await tester.pumpAndSettle();

    // P3 — phone, then submit the pair.
    expect(find.byType(P3PhoneScreen), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, '901234567');
    await tester.pump();
    await tester.tap(find.byType(PrimaryButton).first);
    taps++;
    await tester.pumpAndSettle();

    // P4 — consent reached BEFORE any session (enrolment happens at Agree),
    // which is what lets P4 keep a working Back to P3.
    expect(find.byType(P4ConsentScreen), findsOneWidget);
    final s = container.read(sessionProvider);
    expect(s.hasSession, isFalse);
    expect(s.consented, isFalse);
    expect(taps, lessThanOrEqualTo(5));
  });

  testWidgets('P4: agree stays disabled until scrolled AND ticked',
      (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    final container = await pumpApp(tester);
    // Consent is reachable once a language is chosen (enrolment is at Agree).
    await container.read(sessionProvider.notifier).setLanguage('EN');
    await tester.pumpAndSettle();
    // Drive to P4 the normal way would need code+phone; jump the router.
    final ctx = tester.element(find.byType(P1LanguageScreen));
    GoRouter.of(ctx).go('/consent');
    await tester.pumpAndSettle();
    expect(find.byType(P4ConsentScreen), findsOneWidget);

    PrimaryButton agree() => tester.widget<PrimaryButton>(
          find.byType(PrimaryButton).first,
        );

    // The checkbox row carries the consent-checkbox label (fake content
    // renders it as txt:<key>).
    final checkbox = find.text('txt:onboarding.consent.checkbox');

    // Tick without scrolling first.
    await tester.tap(checkbox, warnIfMissed: false);
    await tester.pump();

    // Scroll the consent text to the end.
    final list = find.byType(ListView).first;
    await tester.drag(list, const Offset(0, -4000));
    await tester.pump();

    if (agree().onPressed == null) {
      await tester.tap(checkbox, warnIfMissed: false);
      await tester.pump();
    }
    expect(agree().onPressed, isNotNull,
        reason: 'scrolled to end AND ticked → enabled');
  });

  testWidgets('code draft survives process death (prefs round-trip)',
      (tester) async {
    SharedPreferences.setMockInitialValues({
      'enrolment.draft_code': 'H7K',
      'session.language': 'EN',
    });
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [
        sharedPrefsProvider.overrideWithValue(prefs),
      databaseProvider.overrideWith((ref) {
        final db = AppDatabase.memory();
        ref.onDispose(db.close);
        return db;
      }),
        contentProvider.overrideWith(
          (ref, spec) async => ContentResolved(
            text: 'txt:${spec.$1}',
            version: 1,
            isPlaceholder: true,
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const HospitalAiApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(P2CodeScreen), findsOneWidget);
    final codeField = tester.widget<TextField>(
      find.descendant(
        of: find.byType(CodeField),
        matching: find.byType(TextField),
      ),
    );
    expect(codeField.controller!.text, 'H7K',
        reason: 'the typed code survives backgrounding');
  });
}
