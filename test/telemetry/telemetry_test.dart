import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:hospital_ai/core/storage/app_database.dart';
import 'package:hospital_ai/core/telemetry/client_events.dart';

void main() {
  late AppDatabase db;
  late ClientEvents events;

  setUp(() {
    db = AppDatabase.memory();
    events = ClientEvents(db);
  });
  tearDown(() => db.close());

  Future<List<TelemetryOutboxData>> outbox() =>
      db.select(db.telemetryOutbox).get();

  test('a simulated 30-day patient fires every client event correctly',
      () async {
    // Day 0: enrolment language choice.
    await events.languageSelected(language: 'UZ', isChange: false);

    for (var day = 1; day <= 30; day++) {
      // Three medication reminders a day (placeholder schedule).
      for (final slot in ['08', '14', '20']) {
        await events.medicationReminderSent(taskId: 'd$day-med$slot');
        await events.medicationConfirmed(
          taskId: 'd$day-med$slot',
          onTime: slot != '20', // evening dose late — still recorded
        );
      }
      if (day == 3) {
        await events.contentViewed(
          contentRef: 'clinical.laparoscopic_appendectomy.day_3',
        );
      }
      if (day == 7) {
        // One emergency check-in that day — logged, never deduplicated.
        await events.emergencyScreenShown(trigger: 'tier');
        await events.emergencyScreenShown(trigger: 'tier');
      }
      if (day == 15) {
        await events.languageSelected(language: 'RU', isChange: true);
      }
    }

    final rows = await outbox();
    int count(String name) => rows.where((r) => r.name == name).length;

    expect(count('language_selected'), 2);
    expect(count('medication_reminder_sent'), 90);
    expect(count('medication_confirmed'), 90);
    expect(count('content_viewed'), 1);
    expect(count('emergency_screen_shown'), 2,
        reason: 'every render logged, no dedupe');

    // Values: on_time false for every evening dose, true otherwise.
    final confirms = rows.where((r) => r.name == 'medication_confirmed');
    for (final row in confirms) {
      final props = jsonDecode(row.props) as Map<String, dynamic>;
      final late = (props['task_id'] as String).endsWith('med20');
      expect(props['on_time'], !late);
    }

    // The change-language event carries is_change:true.
    final langChanges = rows
        .where((r) => r.name == 'language_selected')
        .map((r) => jsonDecode(r.props) as Map<String, dynamic>)
        .toList();
    expect(langChanges.first['is_change'], false);
    expect(langChanges.last['is_change'], true);
    expect(langChanges.last['language'], 'RU');
  });

  test('no ClientEvents method accepts arbitrary prose — rule 6 at the API',
      () {
    // Source-level pin: the events API exposes no parameter that could
    // carry clinical prose, and no generic emit is public.
    final source =
        File('lib/core/telemetry/client_events.dart').readAsStringSync();
    const forbiddenParams = [
      'String message',
      'String text',
      'String note',
      'String body',
      'String comment',
      'String freeText',
    ];
    for (final p in forbiddenParams) {
      expect(source.contains(p), isFalse,
          reason: 'ClientEvents must not accept "$p"');
    }
    // The raw emitter stays private.
    expect(RegExp(r'Future<void> _emit\(').hasMatch(source), isTrue);
    expect(source.contains('Future<void> emit('), isFalse,
        reason: 'no public generic emit');
  });

  test('every emitted payload holds ids and categorical values only',
      () async {
    await events.languageSelected(language: 'EN', isChange: false);
    await events.medicationReminderSent(taskId: 't-1');
    await events.medicationConfirmed(taskId: 't-1', onTime: true);
    await events.contentViewed(contentRef: 'clinical.x.day_1');
    await events.emergencyScreenShown(trigger: 'tier');

    for (final row in await outbox()) {
      final props = jsonDecode(row.props) as Map<String, dynamic>;
      for (final value in props.values) {
        final ok = value is bool ||
            value is num ||
            (value is String && !value.contains(' '));
        expect(ok, isTrue,
            reason: '${row.name}.$value must be an id/categorical, not prose');
      }
    }
  });

  test('events survive in the outbox until an ingestion endpoint exists — '
      'nothing is dropped', () async {
    await events.emergencyScreenShown(trigger: 'tier');
    final rows = await outbox();
    expect(rows.single.sent, isFalse,
        reason: 'held locally; the backend gap list covers the endpoint');
    expect(rows.single.occurredAt, isNotEmpty);
  });
}
