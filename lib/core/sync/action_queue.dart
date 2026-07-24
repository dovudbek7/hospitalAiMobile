import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../storage/app_database.dart';

/// Everything the offline queue is ALLOWED to carry.
///
/// **Check-in submission is deliberately unrepresentable.** The spec's
/// hardest offline rule is that a patient reporting symptoms must never be
/// silently queued — so there is no enum value for it, no payload shape for
/// it, and therefore no code path that could ever queue one.
enum PendingActionType {
  completeTask('complete_task'),
  uncompleteTask('uncomplete_task');

  const PendingActionType(this.wire);

  final String wire;

  static PendingActionType parse(String raw) =>
      PendingActionType.values.firstWhere((t) => t.wire == raw);
}

class ActionQueue {
  ActionQueue(this._db);

  final AppDatabase _db;
  static const _uuid = Uuid();

  /// Enqueue a task completion (or un-completion — logged as a NEW action,
  /// never a mutation of the original).
  ///
  /// The idempotency key is generated HERE, once per logical action, and
  /// persisted with the row — every retry replays the SAME key, so the
  /// server can deduplicate and a replay produces exactly one effect.
  /// [occurredAt] is when the patient acted; sync must never overwrite it.
  Future<String> enqueueTaskToggle({
    required String taskId,
    required bool uncomplete,
    required DateTime occurredAt,
  }) async {
    final id = _uuid.v4();
    await _db.into(_db.pendingActions).insert(
          PendingActionsCompanion.insert(
            id: id,
            type: uncomplete
                ? PendingActionType.uncompleteTask.wire
                : PendingActionType.completeTask.wire,
            payload: jsonEncode({'taskId': taskId}),
            idempotencyKey: _uuid.v4(),
            occurredAt: occurredAt.toUtc().toIso8601String(),
          ),
        );
    return id;
  }

  Future<List<PendingAction>> pending() =>
      (_db.select(_db.pendingActions)
            ..orderBy([(t) => OrderingTerm.asc(t.occurredAt)]))
          .get();

  Future<void> remove(String id) =>
      (_db.delete(_db.pendingActions)..where((t) => t.id.equals(id))).go();

  Future<void> bumpAttempts(PendingAction row, String error) =>
      (_db.update(_db.pendingActions)..where((t) => t.id.equals(row.id)))
          .write(
        PendingActionsCompanion(
          attempts: Value(row.attempts + 1),
          lastError: Value(error),
        ),
      );
}
