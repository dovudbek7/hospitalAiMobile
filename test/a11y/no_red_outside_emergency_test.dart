// Standing rule 8, screen-level: outside P13 (and the emergency affordance
// in the shell) not a single emergency-red pixel may render — including on
// a Today full of overdue tasks.

import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hospital_ai/core/auth/session.dart';
import 'package:hospital_ai/core/providers.dart';
import 'package:hospital_ai/core/storage/app_database.dart';
import 'package:hospital_ai/features/progress/p9_progress_screen.dart';
import 'package:hospital_ai/features/today/p6_today_screen.dart';

import '../network/fake_adapter.dart';

FakeResponse _server(RequestOptions o) {
  final path = o.uri.path;
  if (path.endsWith('/me/today')) {
    return FakeResponse(200, {
      'recoveryDay': 6,
      'groups': {
        'medication': [
          for (var i = 0; i < 4; i++)
            {
              'id': 't$i',
              'taskType': 'medication',
              'contentRef': 'medication.paracetamol_500',
              'scheduledFor': '2026-07-24T0$i:00:00Z',
              // EVERY task overdue — the hardest case for the rule.
              'windowClosesAt': '2020-01-01T00:00:00Z',
              'status': 'pending',
              'onTime': null,
            },
        ],
      },
      'checkinDue': true,
    });
  }
  if (path.endsWith('/me/progress')) {
    return FakeResponse(200, {
      // 0% adherence — low-adherence styling must stay neutral too.
      'adherence': {'value': 0.0, 'numerator': 0, 'denominator': 12},
      'daysCompleted': 0,
      'programmeDays': 30,
      'perDay': <dynamic>[],
    });
  }
  return FakeResponse(200, {'ok': true});
}

Future<int> _redPixels(WidgetTester tester, Finder finder) async {
  return (await tester.runAsync<int>(() async {
    final element = finder.evaluate().single;
    RenderObject? node = element.renderObject;
    while (node != null && node is! RenderRepaintBoundary) {
      node = node.parent;
    }
    final ui.Image image = await (node! as RenderRepaintBoundary).toImage();
    final data = (await image.toByteData())!;
    var count = 0;
    for (var i = 0; i < data.lengthInBytes; i += 4) {
      final r = data.getUint8(i);
      final g = data.getUint8(i + 1);
      final b = data.getUint8(i + 2);
      if ((r - 0xB3).abs() < 24 &&
          (g - 0x26).abs() < 24 &&
          (b - 0x1E).abs() < 24) {
        count++;
      }
    }
    return count;
  }))!;
}

void main() {
  for (final entry in {
    'P6 with every task overdue': () => const P6TodayScreen(),
    'P9 at zero adherence': () => const P9ProgressScreen(),
  }.entries) {
    testWidgets('${entry.key} renders ZERO emergency-red pixels',
        (tester) async {
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
              text: 'resolved ${spec.$1}',
              version: 1,
              isPlaceholder: true,
            ),
          ),
        ],
      );
      addTearDown(container.dispose);
      container.read(dioProvider).httpClientAdapter = FakeAdapter(_server);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(home: entry.value()),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(await _redPixels(tester, find.byType(Scaffold)), 0);

      // Let any fire-and-forget timers (sync kicks, retry backoff) expire
      // before teardown asserts no timers are pending.
      await tester.pump(const Duration(seconds: 3));
    });
  }
}
