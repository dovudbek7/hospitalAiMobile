import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hospital_ai/core/auth/session.dart';
import 'package:hospital_ai/core/providers.dart';
import 'package:hospital_ai/core/storage/app_database.dart';
import 'package:hospital_ai/core/widgets/task_row.dart';
import 'package:hospital_ai/features/progress/p9_progress_screen.dart';
import 'package:hospital_ai/features/today/p6_today_screen.dart';
import 'package:hospital_ai/features/today/today_providers.dart';

import '../network/fake_adapter.dart';

const _todayBody = {
  'recoveryDay': 6,
  'groups': {
    'medication': [
      {
        'id': 't1',
        'taskType': 'medication',
        'contentRef': 'medication.paracetamol_500',
        'scheduledFor': '2026-07-24T08:00:00Z',
        'windowClosesAt': '2026-07-24T10:00:00Z',
        'status': 'completed',
        'onTime': true,
      },
      {
        'id': 't2',
        'taskType': 'wound_care',
        'contentRef': 'task.wound_care',
        'scheduledFor': '2026-07-24T10:00:00Z',
        'windowClosesAt': '2020-01-01T00:00:00Z', // long past → overdue
        'status': 'pending',
        'onTime': null,
      },
    ],
  },
  'checkinDue': true,
};

const _progressBody = {
  'adherence': {'value': 0.8, 'numerator': 8, 'denominator': 10},
  'daysCompleted': 5,
  'programmeDays': 30,
  'perDay': <dynamic>[],
};

Future<ProviderContainer> _container(FakeHandler handler) async {
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
  container.read(dioProvider).httpClientAdapter = FakeAdapter(handler);
  return container;
}

Widget _app(ProviderContainer c, Widget home) => UncontrolledProviderScope(
      container: c,
      child: MaterialApp(home: home),
    );

void main() {
  testWidgets('P6 renders tasks; overdue is grey, completed stays visible',
      (tester) async {
    final c = await _container((o) {
      if (o.uri.path.endsWith('/me/today')) {
        return FakeResponse(200, _todayBody);
      }
      return FakeResponse(200, {'ok': true});
    });

    await tester.pumpWidget(_app(c, const P6TodayScreen()));
    await tester.pumpAndSettle();

    final rows = tester
        .widgetList<TaskRow>(find.byType(TaskRow))
        .toList(growable: false);
    expect(rows, hasLength(2));
    expect(rows.first.state, TaskRowState.completed,
        reason: 'completed tasks stay visible');
    expect(rows.last.state, TaskRowState.overdue);
    // The check-in entry point is present when due.
    expect(find.text('txt:today.checkin_prompt'), findsOneWidget);
  });

  testWidgets('P6 offline: renders the cached day with the offline strip',
      (tester) async {
    var online = true;
    final c = await _container((o) {
      if (!online) throw const SocketException('down');
      if (o.uri.path.endsWith('/me/today')) {
        return FakeResponse(200, _todayBody);
      }
      return FakeResponse(200, {'ok': true});
    });

    // First load online — populates the cache.
    await tester.pumpWidget(_app(c, const P6TodayScreen()));
    await tester.pumpAndSettle();
    expect(find.byType(TaskRow), findsNWidgets(2));

    // Go offline and reload the provider.
    online = false;
    c.invalidate(todayProvider);
    await tester.pumpAndSettle();

    expect(find.byType(TaskRow), findsNWidgets(2),
        reason: 'cached tasks keep rendering offline');
    expect(find.text('txt:offline.indicator'), findsOneWidget);
  });

  testWidgets('P6 tick queues the completion and re-renders instantly',
      (tester) async {
    final c = await _container((o) {
      if (o.uri.path.endsWith('/me/today')) {
        return FakeResponse(200, _todayBody);
      }
      if (o.uri.path.contains('/tasks/')) {
        return FakeResponse(200, {'ok': true});
      }
      return FakeResponse(200, {'ok': true});
    });

    await tester.pumpWidget(_app(c, const P6TodayScreen()));
    await tester.pumpAndSettle();

    // Tap the overdue row's checkbox (the second TaskRow's toggle).
    final row = find.byType(TaskRow).last;
    final toggle = find.descendant(
      of: row,
      matching: find.byType(InkWell),
    );
    await tester.tap(toggle.last, warnIfMissed: false);
    await tester.pumpAndSettle();

    final view = c.read(todayProvider).value!;
    expect(view.tasks.last.completed, isTrue, reason: 'instant re-render');
  });

  testWidgets('P9 always shows the denominator next to the percentage',
      (tester) async {
    final c = await _container((o) {
      if (o.uri.path.endsWith('/me/progress')) {
        return FakeResponse(200, _progressBody);
      }
      if (o.uri.path.endsWith('/me/today')) {
        return FakeResponse(200, _todayBody);
      }
      return FakeResponse(200, {'ok': true});
    });

    await tester.pumpWidget(_app(c, const P9ProgressScreen()));
    await tester.pumpAndSettle();

    expect(find.text('80%'), findsOneWidget);
    // Denominator string rendered through the content key with N/TOTAL.
    expect(find.text('txt:progress.tasks_frac'), findsOneWidget);
    expect(find.text('txt:progress.not_counted'), findsOneWidget);
  });
}
