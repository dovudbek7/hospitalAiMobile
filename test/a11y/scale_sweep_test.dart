// F12 · The 200% font-scale sweep. Every patient screen is pumped at 100%
// and 200% text scale with realistic data; any RenderFlex overflow fails
// the test. This is the automated stand-in for the on-device systems
// setting (spec: "must survive 200% system font scale").

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hospital_ai/core/auth/session.dart';
import 'package:hospital_ai/core/providers.dart';
import 'package:hospital_ai/core/storage/app_database.dart';
import 'package:hospital_ai/features/checkin/p10_checkin_screen.dart';
import 'package:hospital_ai/features/checkin/p11_routine_screen.dart';
import 'package:hospital_ai/features/checkin/p12_urgent_screen.dart';
import 'package:hospital_ai/features/checkin/p13_emergency_screen.dart';
import 'package:hospital_ai/features/learn/p14_learn_screen.dart';
import 'package:hospital_ai/features/learn/p15_article_screen.dart';
import 'package:hospital_ai/features/medication/p8_medication_screen.dart';
import 'package:hospital_ai/features/onboarding/p1_language_screen.dart';
import 'package:hospital_ai/features/onboarding/p2_code_screen.dart';
import 'package:hospital_ai/features/onboarding/p3_phone_screen.dart';
import 'package:hospital_ai/features/onboarding/p4_consent_screen.dart';
import 'package:hospital_ai/features/onboarding/p5_welcome_screen.dart';
import 'package:hospital_ai/features/progress/p9_progress_screen.dart';
import 'package:hospital_ai/features/settings/p16_settings_screen.dart';
import 'package:hospital_ai/features/survey/p17_survey_screen.dart';
import 'package:hospital_ai/features/today/p6_today_screen.dart';
import 'package:hospital_ai/features/today/p7_task_detail_screen.dart';

import '../network/fake_adapter.dart';

FakeResponse _server(RequestOptions o) {
  final path = o.uri.path;
  if (path.endsWith('/me/today')) {
    return FakeResponse(200, {
      'recoveryDay': 6,
      'groups': {
        'medication': [
          {
            'id': 'm1',
            'taskType': 'medication',
            'contentRef': 'medication.paracetamol_500',
            'scheduledFor': '2026-07-24T08:00:00Z',
            'windowClosesAt': '2999-01-01T00:00:00Z',
            'status': 'pending',
            'onTime': null,
          },
          {
            'id': 'w1',
            'taskType': 'wound_care',
            'contentRef': 'task.wound_care',
            'scheduledFor': '2026-07-24T10:00:00Z',
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
      'adherence': {'value': 0.8, 'numerator': 8, 'denominator': 10},
      'daysCompleted': 5,
      'programmeDays': 30,
      'perDay': <dynamic>[],
    });
  }
  if (path.endsWith('/me/checkin/questions')) {
    return FakeResponse(200, [
      {
        'ref': 'q1_temp',
        'questionContentKey': 'checkin.q1_temp',
        'type': 'single',
        'options': [
          {'code': 'a', 'label': 'Under 37.5'},
          {'code': 'b', 'label': '38.5 or above with long label text'},
        ],
      },
    ]);
  }
  if (path.endsWith('/me/content')) {
    return FakeResponse(200, {
      'category': 'education',
      'recoveryDay': 6,
      'items': [
        {'contentKey': 'clinical.appendectomy.day_5', 'unlockDay': 5},
        {'contentKey': 'clinical.appendectomy.day_3', 'unlockDay': 3},
      ],
    });
  }
  return FakeResponse(200, {'ok': true});
}

void main() {
  final screens = <String, Widget>{
    'P1': const P1LanguageScreen(),
    'P2': const P2CodeScreen(),
    'P3': const P3PhoneScreen(),
    'P4': const P4ConsentScreen(),
    'P5': const P5WelcomeScreen(),
    'P6': const P6TodayScreen(),
    'P7': const P7TaskDetailScreen(taskId: 'w1'),
    'P8': const P8MedicationScreen(taskId: 'm1'),
    'P9': const P9ProgressScreen(),
    'P10': const P10CheckinScreen(),
    'P11': const P11RoutineScreen(),
    'P12': const P12UrgentScreen(),
    'P13': const P13EmergencyScreen(),
    'P14': const P14LearnScreen(),
    'P15': const P15ArticleScreen(contentKey: 'clinical.appendectomy.day_5'),
    'P16': const P16SettingsScreen(),
    'P17': const P17SurveyScreen(),
  };

  for (final scale in [1.0, 2.0]) {
    for (final entry in screens.entries) {
      testWidgets('${entry.key} renders without overflow at ${scale}x',
          (tester) async {
        // Mid-range 360dp-wide device.
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 3;
        addTearDown(tester.view.reset);

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
              // Realistically LONG placeholder text — short fakes hide
              // wrapping bugs.
              (ref, spec) async => ContentResolved(
                text: 'Resolved text for ${spec.$1} that is long enough '
                    'to wrap across more than one line on a phone.',
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
            child: MaterialApp(
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: TextScaler.linear(scale)),
                child: child!,
              ),
              home: entry.value,
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));

        expect(
          tester.takeException(),
          isNull,
          reason: '${entry.key} must survive ${scale}x text scale',
        );
      });
    }
  }
}
