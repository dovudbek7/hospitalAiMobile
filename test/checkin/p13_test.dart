import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hospital_ai/core/auth/session.dart';
import 'package:hospital_ai/core/content/emergency_bundle.dart';
import 'package:hospital_ai/core/providers.dart';
import 'package:hospital_ai/core/storage/app_database.dart';
import 'package:hospital_ai/core/theme/tokens.dart';
import 'package:hospital_ai/features/checkin/p13_emergency_screen.dart';

import '../network/fake_adapter.dart';

Future<ProviderContainer> _pump(WidgetTester tester) async {
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
  // The screen must not need the network: the adapter refuses everything.
  container.read(dioProvider).httpClientAdapter =
      FakeAdapter((o) => throw StateError('NO NETWORK on P13'));

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(home: P13EmergencyScreen()),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
  return container;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('renders the bundle text with NO network at all',
      (tester) async {
    // Enrolment-time bundle is present (as F4 guarantees).
    const bundle = EmergencyBundle(
      headline: "Your clinic's instruction: call 103 now.",
      body: 'Sehat Clinic (DEMO) advises calling emergency services '
          'immediately. Do not wait for a reply from this app.',
      banner: 'banner',
      ambulanceNumber: '103',
      clinicName: 'Sehat Clinic (DEMO)',
      clinicPhone: '+998712000000',
      language: 'EN',
    );
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'emergency_bundle_v1',
      jsonEncode(bundle.toJson()),
    );

    await _pump(tester);

    expect(
      find.text("Your clinic's instruction: call 103 now."),
      findsOneWidget,
      reason: 'verbatim clinician-signed copy, from local storage only',
    );

    // Full-screen emergency red.
    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    expect(scaffold.backgroundColor, AppColors.emergency);
  });

  testWidgets('emergency_screen_shown is logged on EVERY render, no dedupe',
      (tester) async {
    final c = await _pump(tester);
    final db = c.read(databaseProvider);

    Future<int> count() async => (await db.select(db.telemetryOutbox).get())
        .where((r) => r.name == 'emergency_screen_shown')
        .length;
    expect(await count(), 1);

    // Re-mount the screen — a second event, never deduplicated.
    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: c,
        child: const MaterialApp(home: P13EmergencyScreen()),
      ),
    );
    await tester.pump();
    expect(await count(), 2);
  });
}
