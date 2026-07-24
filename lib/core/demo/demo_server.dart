// DEMO MODE — an in-app stand-in for api.hospital-ai.uz.
//
// Purpose: make the whole product walkable end-to-end before a real
// enrolment code exists (MVP Scope Decisions, "Demo mode"). It accepts any
// code+phone, serves the Content Pack's demo seed (patient at recovery
// day 6), and evaluates check-ins with the same placeholder-v1 rules the
// real backend runs.
//
// Boundaries, deliberately kept:
//  - This file is a fake SERVER. The tier rules living here mirror the
//    backend and are NEVER imported by feature code — the client still
//    routes on the response tier verbatim (standing rule 7). A test scans
//    lib/features/checkin/ to keep it that way.
//  - Enabled by the DEMO_MODE dart-define; it defaults ON in debug builds
//    and OFF in release/profile. A release build can only get it by an
//    explicit --dart-define=DEMO_MODE=true.
//  - Every string served is Content Pack text, placeholder-flagged.

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

class DemoServer implements HttpClientAdapter {
  final Set<String> _completedTaskIds = {};
  final Set<String> _uncompletedTaskIds = {};
  bool _consented = false;

  static const _latency = Duration(milliseconds: 250);

  // ---------------------------------------------------------------- clinic
  static const _clinic = {
    'name': 'Sehat Clinic (DEMO)',
    'phone': '+998712000000',
    'emergencyNumber': '103',
    'workingHours': '09:00-18:00',
    'workingDays': 'Mon-Sat',
    'timezone': 'Asia/Tashkent',
  };

  // ------------------------------------------------------------- content
  /// Keys the demo serves directly (the live server owns these; text is
  /// verbatim Content Pack). Everything else returns CONTENT_NOT_APPROVED
  /// so the bundled seed — the normal fallback path — takes over.
  static const Map<String, String> _content = {
    'emergency.headline': "Your clinic's instruction: call 103 now.",
    'emergency.body':
        'Sehat Clinic (DEMO) advises that anyone with these symptoms after '
            'surgery should call emergency services immediately. Do not wait '
            'for a reply from this app.',
    'emergency.banner':
        "Your clinic's instruction: in an emergency, call 103. Do not use "
            'this app to report urgent symptoms.',
    'checkin.submitted.urgent':
        'Thank you. Your answers have been sent to the Sehat Clinic (DEMO) '
            'care team. This app cannot assess your symptoms — a staff member '
            "will review them. Sehat Clinic (DEMO)'s instruction: if your "
            'symptoms get worse while you are waiting, call 103 or '
            '+998712000000 straight away.',
    'checkin.submitted.out_of_hours':
        'Sehat Clinic (DEMO) is closed. Your answers will be reviewed at '
            "09:00. Sehat Clinic (DEMO)'s instruction: if you are worried "
            'now, call 103 or +998712000000.',
    'checkin.submitted.routine':
        'Thank you. Your answers have been sent to the Sehat Clinic (DEMO) '
            'care team, who review check-ins on the next working day.',
    'content.disclaimer':
        'This information was approved by your clinic. It is general '
            'guidance, not advice about your specific case. For questions '
            'about your own recovery, contact Sehat Clinic (DEMO).',
    // Task titles (recovery-plan content refs).
    'medication.paracetamol_500': 'Paracetamol 500 mg',
    'medication.antibiotic': 'Antibiotic — 1 tablet',
    'task.wound_care': 'Wound care',
    'task.walking': 'Gentle walking, 20 minutes',
    // Demo article titles (Pack education plan). Bodies are visibly
    // placeholder filler — NOT clinical prose.
    'clinical.laparoscopic_appendectomy.what_to_expect_day1.title':
        'What to expect',
    'clinical.laparoscopic_appendectomy.wound_care_day3.title':
        'Caring for your wound',
    'clinical.laparoscopic_appendectomy.warning_signs_day5.title':
        'Warning signs to watch for',
    'clinical.laparoscopic_appendectomy.what_to_expect_day1':
        '[PLACEHOLDER — demo body] The clinician-approved article text '
            'renders here once the content library is seeded.',
    'clinical.laparoscopic_appendectomy.wound_care_day3':
        '[PLACEHOLDER — demo body] The clinician-approved article text '
            'renders here once the content library is seeded.',
    'clinical.laparoscopic_appendectomy.warning_signs_day5':
        '[PLACEHOLDER — demo body] The clinician-approved article text '
            'renders here once the content library is seeded.',
    'task.wound_care.instructions':
        '[PLACEHOLDER — demo body] The clinic-approved instruction for this '
            'task renders here once the content library is seeded.',
  };

  // ------------------------------------------------------------ questions
  static const _questions = [
    {
      'ref': 'q1_temp',
      'questionContentKey': 'checkin.q1_temp',
      'type': 'single',
      'options': [
        {'code': 'under_37_5', 'label': 'Under 37.5'},
        {'code': '37_5_to_38_4', 'label': '37.5–38.4'},
        {'code': '38_5_or_above', 'label': '38.5 or above'},
        {'code': 'not_measured', 'label': 'Haven’t measured'},
      ],
    },
    {
      'ref': 'q2_pain',
      'questionContentKey': 'checkin.q2_pain',
      'type': 'scale',
      'scale': {'min': 0, 'max': 10},
    },
    {
      'ref': 'q3_pain_change',
      'questionContentKey': 'checkin.q3_pain_change',
      'type': 'single',
      'options': [
        {'code': 'better', 'label': 'Better'},
        {'code': 'same', 'label': 'Same'},
        {'code': 'worse', 'label': 'Worse'},
      ],
    },
    {
      'ref': 'q4_wound',
      'questionContentKey': 'checkin.q4_wound',
      'type': 'single',
      'options': [
        {'code': 'normal', 'label': 'Normal'},
        {'code': 'a_little_red', 'label': 'A little red'},
        {'code': 'very_red_spreading', 'label': 'Very red or spreading'},
        {'code': 'leaking', 'label': 'Leaking fluid or pus'},
        {'code': 'opening', 'label': 'Opening'},
      ],
    },
    {
      'ref': 'q5_redflags',
      'questionContentKey': 'checkin.q5_redflags',
      'type': 'multi',
      'options': [
        {'code': 'chills', 'label': 'Chills or shivering'},
        {'code': 'difficulty_breathing', 'label': 'Difficulty breathing'},
        {'code': 'chest_pain', 'label': 'Chest pain'},
        {'code': 'confusion', 'label': 'Confusion'},
        {'code': 'very_hard_awake', 'label': 'Very hard to stay awake'},
        {'code': 'heavy_bleeding', 'label': 'Heavy bleeding'},
        {'code': 'new_calf_pain', 'label': 'New calf pain or swelling'},
        {'code': 'none', 'label': 'None of these'},
      ],
    },
    {
      'ref': 'q6_intake',
      'questionContentKey': 'checkin.q6_intake',
      'type': 'single',
      'options': [
        {'code': 'yes', 'label': 'Yes'},
        {'code': 'some_difficulty', 'label': 'Some difficulty'},
        {'code': 'no', 'label': 'No'},
      ],
    },
    {
      'ref': 'q7_urine',
      'questionContentKey': 'checkin.q7_urine',
      'type': 'single',
      'options': [
        {'code': 'yes', 'label': 'Yes'},
        {'code': 'no', 'label': 'No'},
      ],
    },
  ];

  // ----------------------------------------------------------- tier rules
  /// placeholder-v1, verbatim from the Content Pack — the same rules the
  /// real backend evaluates. SERVER-side logic; features never import this.
  static String evaluateTier(Map<String, Object?> answers) {
    final rf = (answers['q5_redflags'] as List?)?.cast<String>() ?? const [];
    const emergencyFlags = [
      'difficulty_breathing',
      'chest_pain',
      'confusion',
      'very_hard_awake',
      'heavy_bleeding',
    ];
    final pain = (answers['q2_pain'] as num?)?.toInt() ?? 0;

    if (rf.any(emergencyFlags.contains) || answers['q4_wound'] == 'opening') {
      return 'emergency';
    }
    final urgent = answers['q1_temp'] == '38_5_or_above' ||
        rf.contains('chills') ||
        rf.contains('new_calf_pain') ||
        answers['q4_wound'] == 'very_red_spreading' ||
        answers['q4_wound'] == 'leaking' ||
        pain >= 8 ||
        (answers['q3_pain_change'] == 'worse' && pain >= 6) ||
        answers['q6_intake'] == 'no' ||
        answers['q7_urine'] == 'no';
    return urgent ? 'urgent' : 'routine';
  }

  bool get _withinClinicHours {
    // Asia/Tashkent = UTC+5, clinic 09:00–18:00 Mon–Sat.
    final local = DateTime.now().toUtc().add(const Duration(hours: 5));
    return local.weekday != DateTime.sunday &&
        local.hour >= 9 &&
        local.hour < 18;
  }

  // -------------------------------------------------------------- today
  Map<String, dynamic> _today() {
    final now = DateTime.now().toUtc();
    final day = DateTime(now.year, now.month, now.day);
    String at(int hour) =>
        day.add(Duration(hours: hour)).toIso8601String();

    Map<String, dynamic> task(
      String id,
      String type,
      String ref,
      int hour,
      int windowEndHour, {
      bool doneByDefault = false,
    }) {
      final completed = _uncompletedTaskIds.contains(id)
          ? false
          : (doneByDefault || _completedTaskIds.contains(id));
      return {
        'id': id,
        'taskType': type,
        'contentRef': ref,
        'scheduledFor': at(hour),
        'windowClosesAt': at(windowEndHour),
        'status': completed ? 'completed' : 'pending',
        'onTime': completed ? true : null,
      };
    }

    return {
      'recoveryDay': 6,
      'groups': {
        'medication': [
          task('demo-t1', 'medication', 'medication.paracetamol_500', 3, 5,
              doneByDefault: true),
          task('demo-t2', 'medication', 'medication.antibiotic', 4, 6,
              doneByDefault: true),
          task('demo-t5', 'medication', 'medication.paracetamol_500', 9, 11),
          task('demo-t6', 'medication', 'medication.paracetamol_500', 15, 17),
        ],
        'wound_care': [
          task('demo-t3', 'wound_care', 'task.wound_care', 5, 6),
        ],
        'activity': [
          task('demo-t4', 'activity', 'task.walking', 6, 23),
        ],
      },
      'checkinDue': true,
    };
  }

  // ------------------------------------------------------------ transport
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    await Future<void>.delayed(_latency);
    final (status, body) = _route(options);
    return ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  (int, Object) _route(RequestOptions o) {
    final path = o.uri.path;

    if (path.endsWith('/auth/patient/session')) {
      // Demo accepts ANY code+phone pair.
      return (
        200,
        {
          'audience': 'patient',
          'accessToken': 'demo-access-token',
          'refreshToken': 'demo-refresh-token',
          'patientId': 'DEMO-01',
          'clinicId': 'demo-clinic',
        }
      );
    }
    if (path.endsWith('/me/consent')) {
      _consented = true;
      return (200, {'ok': true});
    }
    if (path.endsWith('/me/profile')) {
      return (
        200,
        {
          'name': 'Aziz Demo',
          'recoveryDay': 6,
          'programmeDays': 30,
          'language': o.headers['x-demo-lang'] as String? ?? 'EN',
          'procedureType': 'laparoscopic_appendectomy',
          'consentVersion': _consented ? 'v1' : null,
          'clinic': _clinic,
        }
      );
    }
    if (path.endsWith('/me/today')) return (200, _today());
    if (RegExp(r'/tasks/[^/]+/complete$').hasMatch(path)) {
      final id = path.split('/')[path.split('/').length - 2];
      final data = o.data;
      final uncomplete =
          data is Map<String, dynamic> && data['uncomplete'] == true;
      if (uncomplete) {
        _uncompletedTaskIds.add(id);
        _completedTaskIds.remove(id);
      } else {
        _completedTaskIds.add(id);
        _uncompletedTaskIds.remove(id);
      }
      return (200, {'ok': true});
    }
    if (path.endsWith('/me/progress')) {
      final done = 8 + _completedTaskIds.length;
      return (
        200,
        {
          'adherence': {
            'value': (done / 12).clamp(0.0, 1.0),
            'numerator': done.clamp(0, 12),
            'denominator': 12,
          },
          'daysCompleted': 5,
          'programmeDays': 30,
          'perDay': <dynamic>[],
        }
      );
    }
    if (path.endsWith('/me/checkin/questions')) return (200, _questions);
    if (path.endsWith('/checkins')) {
      final data = o.data as Map<String, dynamic>;
      final answers = <String, Object?>{
        for (final a in (data['answers'] as List).cast<Map<String, dynamic>>())
          a['ref'] as String: a['value'],
      };
      final tier = evaluateTier(answers);
      return (
        200,
        {
          'checkinId': 'demo-checkin-${DateTime.now().millisecondsSinceEpoch}',
          'tier': tier,
          'ruleVersion': 'placeholder-v1',
          'recoveryDay': 6,
          'withinClinicHours': _withinClinicHours,
          'contentKey': 'checkin.submitted.$tier',
          'body': null, // let the content layer resolve the key
          'escalationId': tier == 'routine' ? null : 'demo-esc-1',
        }
      );
    }
    if (path.endsWith('/me/content')) {
      return (
        200,
        {
          'category': 'education',
          'procedureType': 'laparoscopic_appendectomy',
          'recoveryDay': 6,
          'items': [
            {
              'contentKey':
                  'clinical.laparoscopic_appendectomy.warning_signs_day5',
              'unlockDay': 5,
              'category': 'clinical',
            },
            {
              'contentKey':
                  'clinical.laparoscopic_appendectomy.wound_care_day3',
              'unlockDay': 3,
              'category': 'clinical',
            },
            {
              'contentKey':
                  'clinical.laparoscopic_appendectomy.what_to_expect_day1',
              'unlockDay': 1,
              'category': 'clinical',
            },
          ],
        }
      );
    }
    if (path.contains('/content/')) {
      final key = Uri.decodeComponent(path.split('/content/').last);
      final lang = o.uri.queryParameters['lang'] ?? 'EN';
      final text = _content[key];
      if (text == null) {
        // Not owned by the demo server → the bundled seed takes over.
        return (
          404,
          {
            'code': 'CONTENT_NOT_APPROVED',
            'message': 'demo: not seeded',
            'details': {'contentKey': key, 'language': lang},
          }
        );
      }
      final localized = lang == 'EN'
          ? text
          : '[$lang PLACEHOLDER — NOT CLINICALLY APPROVED] $text';
      return (
        200,
        {
          'contentKey': key,
          'language': lang,
          'text': localized,
          'version': 1,
          'isPlaceholder': true,
        }
      );
    }
    // /me/language, /me/leave, /me/survey, /me/app-opened, everything else.
    if (path.endsWith('/me/leave')) return (200, {'tasksStopped': 12});
    return (200, {'ok': true});
  }

  @override
  void close({bool force = false}) {}
}
