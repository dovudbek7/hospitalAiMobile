import 'package:drift/drift.dart';

import '../models/api_models.dart';
import '../storage/app_database.dart';
import 'action_queue.dart';

/// Local task store: today's list is always readable offline, completions
/// tick locally and queue for sync with their ORIGINAL timestamps.
class TaskCacheRepository {
  TaskCacheRepository(this._db, this._queue);

  final AppDatabase _db;
  final ActionQueue _queue;

  /// Replace the cached copy of a day's tasks with the server truth.
  Future<void> saveToday(TodayResponse today) async {
    await _db.batch((b) {
      for (final group in today.groups.values) {
        for (final task in group) {
          b.insert(
            _db.cachedTasks,
            CachedTasksCompanion.insert(
              id: task.id,
              recoveryDay: today.recoveryDay,
              taskType: task.taskType,
              contentRef: task.contentRef,
              scheduledFor: task.scheduledFor,
              windowClosesAt: Value(task.windowClosesAt),
              status: task.status,
              onTime: Value(task.onTime),
            ),
            mode: InsertMode.insertOrReplace,
          );
        }
      }
    });
  }

  /// All cached tasks for a recovery day, ordered by scheduled time.
  Future<List<CachedTask>> tasksForDay(int recoveryDay) =>
      (_db.select(_db.cachedTasks)
            ..where((t) => t.recoveryDay.equals(recoveryDay))
            ..orderBy([(t) => OrderingTerm.asc(t.scheduledFor)]))
          .get();

  /// Live stream of a day's tasks (P6 re-renders on every local tick).
  Stream<List<CachedTask>> watchDay(int recoveryDay) =>
      (_db.select(_db.cachedTasks)
            ..where((t) => t.recoveryDay.equals(recoveryDay))
            ..orderBy([(t) => OrderingTerm.asc(t.scheduledFor)]))
          .watch();

  Future<CachedTask?> byId(String id) => (_db.select(_db.cachedTasks)
        ..where((t) => t.id.equals(id)))
      .getSingleOrNull();

  /// Toggle locally + enqueue for sync. Works fully offline. The original
  /// action instant is captured HERE and preserved through sync.
  Future<void> toggle({
    required String taskId,
    required bool completed,
    DateTime? occurredAt,
  }) async {
    final at = occurredAt ?? DateTime.now().toUtc();
    await (_db.update(_db.cachedTasks)..where((t) => t.id.equals(taskId)))
        .write(
      CachedTasksCompanion(
        status: Value(completed ? 'completed' : 'pending'),
      ),
    );
    await _queue.enqueueTaskToggle(
      taskId: taskId,
      uncomplete: !completed,
      occurredAt: at,
    );
  }
}
