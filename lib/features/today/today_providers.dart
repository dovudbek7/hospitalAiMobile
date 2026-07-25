import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth/session.dart';
import '../../core/notifications/reminders.dart';
import '../../core/models/api_models.dart';
import '../../core/network/api_error.dart';
import '../../core/providers.dart';
import '../../core/storage/app_database.dart';
import '../../core/sync/connectivity.dart';
import '../../core/sync/task_cache.dart';
import '../onboarding/data/auth_repository.dart';

/// One task as the Today screen renders it — merged from server truth and
/// local (possibly still-queued) completions.
@immutable
class TodayTask {
  const TodayTask({
    required this.id,
    required this.taskType,
    required this.contentRef,
    required this.scheduledFor,
    required this.completed,
    this.windowClosesAt,
  });

  final String id;
  final String taskType;
  final String contentRef;
  final DateTime scheduledFor;
  final DateTime? windowClosesAt;
  final bool completed;

  bool get isMedication => taskType == 'medication';

  /// Overdue = window passed and still pending. Rendered GREY, never red,
  /// never scolding (standing rule 8).
  bool overdueAt(DateTime now) =>
      !completed &&
      windowClosesAt != null &&
      now.isAfter(windowClosesAt!);

  /// Time label (HH:mm, local device clock) — data, not prose.
  String get timeLabel {
    final local = scheduledFor.toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(local.hour)}:${two(local.minute)}';
  }
}

@immutable
class TodayView {
  const TodayView({
    required this.recoveryDay,
    required this.tasks,
    required this.checkinDue,
    required this.fromCache,
  });

  final int recoveryDay;
  final List<TodayTask> tasks;
  final bool checkinDue;

  /// True when the server was unreachable and this is the offline copy.
  final bool fromCache;

  int get doneCount => tasks.where((t) => t.completed).length;
  bool get programmeComplete => recoveryDay > 30;
}

final taskCacheProvider = Provider<TaskCacheRepository>(
  (ref) => TaskCacheRepository(
    ref.watch(databaseProvider),
    ref.watch(actionQueueProvider),
  ),
);

TodayTask _fromCached(CachedTask row) => TodayTask(
      id: row.id,
      taskType: row.taskType,
      contentRef: row.contentRef,
      scheduledFor:
          DateTime.tryParse(row.scheduledFor)?.toUtc() ?? DateTime.now(),
      windowClosesAt: row.windowClosesAt == null
          ? null
          : DateTime.tryParse(row.windowClosesAt!)?.toUtc(),
      completed: row.status == 'completed',
    );

/// Loads Today: server first (then caches), cache when offline. Fires the
/// app_opened engagement ping opportunistically.
final todayProvider =
    AsyncNotifierProvider<TodayNotifier, TodayView>(TodayNotifier.new);

class TodayNotifier extends AsyncNotifier<TodayView> {
  int _lastKnownDay = 0;

  @override
  Future<TodayView> build() async {
    final api = ref.watch(patientApiProvider);
    final cache = ref.watch(taskCacheProvider);

    try {
      final today = await api.getToday();
      await cache.saveToday(today);
      _lastKnownDay = today.recoveryDay;
      // Engagement telemetry — fire and forget, never blocks the screen.
      // ignore: unawaited_futures
      api.appOpened().catchError((Object _) {});
      final rows = await cache.tasksForDay(today.recoveryDay);
      final tasks = rows.map(_fromCached).toList();
      // Rolling-window reminder schedule (no-op until the service is
      // initialised — i.e. in tests).
      unawaited(
        ref
            .read(reminderServiceProvider)
            .rescheduleFromTasks(tasks)
            .catchError((Object _) {}),
      );
      return TodayView(
        recoveryDay: today.recoveryDay,
        tasks: tasks,
        checkinDue: today.checkinDue,
        fromCache: false,
      );
    } on DioException catch (e) {
      final err = e.error;
      // Invalid/absent token → clear the dead session; the router sends the
      // patient to enrolment (also self-heals a stale token from an earlier
      // build). Rethrow so this provider surfaces as error, not a blank day.
      if (err is ApiError &&
          (err.code == ApiErrorCode.unauthorized ||
              err.code == ApiErrorCode.wrongTokenAudience)) {
        await ref.read(authRepositoryProvider).invalidateSession();
        rethrow;
      }
      // Offline (or server trouble): the cached day keeps working.
      final day = _lastKnownDay;
      final rows = await cache.tasksForDay(day);
      return TodayView(
        recoveryDay: day,
        tasks: rows.map(_fromCached).toList(),
        checkinDue: false,
        fromCache: true,
      );
    }
  }

  /// Complete (or un-complete) locally + queue for sync, then re-render.
  /// Works fully offline; the original tap instant is preserved.
  Future<void> toggleTask(String taskId, {required bool completed}) async {
    final cache = ref.read(taskCacheProvider);
    await cache.toggle(taskId: taskId, completed: completed);

    final current = state.value;
    if (current != null) {
      state = AsyncData(
        TodayView(
          recoveryDay: current.recoveryDay,
          tasks: [
            for (final t in current.tasks)
              t.id == taskId
                  ? TodayTask(
                      id: t.id,
                      taskType: t.taskType,
                      contentRef: t.contentRef,
                      scheduledFor: t.scheduledFor,
                      windowClosesAt: t.windowClosesAt,
                      completed: completed,
                    )
                  : t,
          ],
          checkinDue: current.checkinDue,
          fromCache: current.fromCache,
        ),
      );
    }
    // Try to sync immediately if we're online.
    // ignore: unawaited_futures
    ref.read(syncWorkerProvider).drainOnce().catchError((Object _) => 0);
  }
}

/// P9 data: server first, cached JSON for offline, and — as a last resort —
/// a minimal view synthesised from Today so the screen never hard-errors on
/// an unexpected server shape. Progress is motivational, not safety-critical.
final progressProvider = FutureProvider<ProgressResponse>((ref) async {
  final api = ref.watch(patientApiProvider);
  final prefs = ref.watch(sharedPrefsProviderSafe);
  const cacheKey = 'cache.progress_v1';

  ProgressResponse fallback() {
    final day = ref.read(todayProvider).value?.recoveryDay ?? 0;
    return ProgressResponse(
      adherence: const Adherence(value: 0, numerator: 0, denominator: 0),
      daysCompleted: day,
      programmeDays: 30,
    );
  }

  try {
    final progress = await api.getProgress();
    await prefs?.setString(cacheKey, jsonEncode(progress.toJson()));
    return progress;
  } catch (_) {
    // Offline / parse mismatch / server trouble — prefer cache, else a
    // synthesised minimal view. Never a full error screen.
    final raw = prefs?.getString(cacheKey);
    if (raw != null) {
      try {
        return ProgressResponse.fromJson(
          jsonDecode(raw) as Map<String, dynamic>,
        );
      } catch (_) {/* fall through */}
    }
    return fallback();
  }
});

// Small indirection so tests without prefs don't crash the provider.
final sharedPrefsProviderSafe = Provider((ref) {
  try {
    return ref.watch(sharedPrefsProvider);
  } catch (_) {
    return null;
  }
});
