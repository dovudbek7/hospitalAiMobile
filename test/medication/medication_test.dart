import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hospital_ai/core/auth/session.dart';
import 'package:hospital_ai/core/notifications/reminders.dart';
import 'package:hospital_ai/core/providers.dart';
import 'package:hospital_ai/core/storage/app_database.dart';
import 'package:hospital_ai/core/widgets/primary_button.dart';
import 'package:hospital_ai/core/widgets/secondary_button.dart';
import 'package:hospital_ai/features/medication/p8_medication_screen.dart';
import 'package:hospital_ai/features/today/today_providers.dart';

import '../network/fake_adapter.dart';

TodayTask _med(String id, DateTime at, {DateTime? windowEnd, bool done = false}) =>
    TodayTask(
      id: id,
      taskType: 'medication',
      contentRef: 'medication.paracetamol_500',
      scheduledFor: at,
      windowClosesAt: windowEnd,
      completed: done,
    );

void main() {
  group('planReminders — pure scheduling maths', () {
    final now = DateTime.utc(2026, 7, 24, 12);

    test('plans pending future medications only', () {
      final plans = planReminders([
        _med('future', DateTime.utc(2026, 7, 24, 14)),
        _med('past', DateTime.utc(2026, 7, 24, 8)),
        _med('done', DateTime.utc(2026, 7, 24, 15), done: true),
        TodayTask(
          id: 'walk',
          taskType: 'activity',
          contentRef: 'task.walk',
          scheduledFor: DateTime.utc(2026, 7, 24, 16),
          completed: false,
        ),
      ], now: now);

      expect(plans, hasLength(1));
      expect(plans.single.taskId, 'future');
      expect(plans.single.fireAt, DateTime.utc(2026, 7, 24, 14));
    });

    test('ids are stable per task — reschedule replaces, never duplicates',
        () {
      final a = planReminders([_med('t1', DateTime.utc(2026, 7, 24, 14))],
          now: now);
      final b = planReminders([_med('t1', DateTime.utc(2026, 7, 24, 14))],
          now: now);
      expect(a.single.id, b.single.id);
    });

    test('repeat is +30 minutes in a DISTINCT id space (fires once)', () {
      final repeat = planRepeat('t1', now: now);
      expect(repeat.fireAt, now.add(const Duration(minutes: 30)));
      final primary = planReminders(
        [_med('t1', DateTime.utc(2026, 7, 24, 14))],
        now: now,
      ).single;
      expect(repeat.id, isNot(primary.id));
      // Same repeat id every time → a second "Not yet" REPLACES the first
      // pending repeat instead of stacking another one.
      expect(planRepeat('t1', now: now).id, repeat.id);
    });
  });

  group('P8 screen', () {
    Future<ProviderContainer> setup(WidgetTester tester,
        {DateTime? windowEnd}) async {
      SharedPreferences.setMockInitialValues({});
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
      container.read(dioProvider).httpClientAdapter = FakeAdapter(
        (o) => FakeResponse(200, {
          'recoveryDay': 6,
          'groups': {
            'medication': [
              {
                'id': 'm1',
                'taskType': 'medication',
                'contentRef': 'medication.paracetamol_500',
                'scheduledFor': '2026-07-24T08:00:00Z',
                'windowClosesAt': windowEnd?.toIso8601String() ??
                    '2999-01-01T00:00:00Z',
                'status': 'pending',
                'onTime': null,
              }
            ],
          },
          'checkinDue': false,
        }),
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: P8MedicationScreen(taskId: 'm1'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      return container;
    }

    testWidgets('shows EXACTLY two actions: Taken and Not yet',
        (tester) async {
      await setup(tester);
      expect(find.byType(PrimaryButton), findsOneWidget);
      expect(find.byType(SecondaryButton), findsOneWidget);
      expect(find.text('txt:medication.taken'), findsOneWidget);
      expect(find.text('txt:medication.not_yet'), findsOneWidget);
      // No editable field anywhere — the schedule cannot be changed.
      expect(find.byType(TextField), findsNothing);
    });

    testWidgets('Taken records medication_confirmed with on_time=true inside '
        'the window', (tester) async {
      final c = await setup(tester);
      await tester.tap(find.text('txt:medication.taken'));
      await tester.pumpAndSettle();

      final rows =
          await c.read(databaseProvider).select(
                c.read(databaseProvider).telemetryOutbox,
              ).get();
      final confirm =
          rows.where((r) => r.name == 'medication_confirmed').single;
      final props = jsonDecode(confirm.props) as Map<String, dynamic>;
      expect(props['task_id'], 'm1');
      expect(props['on_time'], isTrue);
    });

    testWidgets('late confirmation records on_time=false — data, not failure',
        (tester) async {
      final c = await setup(
        tester,
        windowEnd: DateTime.utc(2020), // window long closed
      );
      await tester.tap(find.text('txt:medication.taken'));
      await tester.pumpAndSettle();

      final rows =
          await c.read(databaseProvider).select(
                c.read(databaseProvider).telemetryOutbox,
              ).get();
      final confirm =
          rows.where((r) => r.name == 'medication_confirmed').single;
      final props = jsonDecode(confirm.props) as Map<String, dynamic>;
      expect(props['on_time'], isFalse);
    });
  });
}
