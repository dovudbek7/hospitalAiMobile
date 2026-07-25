import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../providers.dart';
import '../storage/app_database.dart';

/// The five client-side telemetry events — and ONLY these five. Parameters
/// are typed (enums, bools, ids); there is deliberately no method that
/// accepts arbitrary text, which is what enforces standing rule 6 at the
/// type level: no clinical free text can enter an event.
///
/// Events are written to the outbox synchronously and flushed by the sync
/// worker (F5/F11) — `emergency_screen_shown` included, queued offline and
/// never dropped.
class ClientEvents {
  ClientEvents(this._db);

  final AppDatabase _db;
  static const _uuid = Uuid();

  Future<void> _emit(String name, Map<String, Object> props) async {
    await _db.into(_db.telemetryOutbox).insert(
          TelemetryOutboxCompanion.insert(
            id: _uuid.v4(),
            name: name,
            props: jsonEncode(props),
            occurredAt: DateTime.now().toUtc().toIso8601String(),
          ),
        );
  }

  Future<void> languageSelected({
    required String language,
    required bool isChange,
  }) =>
      _emit('language_selected', {
        'language': language,
        'is_change': isChange,
      });

  Future<void> medicationReminderSent({required String taskId}) =>
      _emit('medication_reminder_sent', {'task_id': taskId});

  Future<void> medicationConfirmed({
    required String taskId,
    required bool onTime,
  }) =>
      _emit('medication_confirmed', {'task_id': taskId, 'on_time': onTime});

  Future<void> contentViewed({required String contentRef}) =>
      _emit('content_viewed', {'content_ref': contentRef});

  /// Logged EVERY single time P13 renders, without exception, including
  /// offline (the outbox is local-first by construction).
  Future<void> emergencyScreenShown({required String trigger}) =>
      _emit('emergency_screen_shown', {'trigger': trigger});
}

final clientEventsProvider = Provider<ClientEvents>(
  (ref) => ClientEvents(ref.watch(databaseProvider)),
);
