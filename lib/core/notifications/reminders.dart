import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../../features/today/today_providers.dart';
import '../providers.dart';
import '../router/guards.dart';
import '../telemetry/client_events.dart';

/// One planned local notification. Pure data — the scheduling maths is
/// testable without any platform channel.
@immutable
class PlannedReminder {
  const PlannedReminder({
    required this.id,
    required this.taskId,
    required this.fireAt,
  });

  final int id;
  final String taskId;
  final DateTime fireAt;
}

/// Plan reminders for the cached window: one per pending medication task,
/// at its scheduled time, skipping anything already in the past.
///
/// NOTE (backend gap, md/steps.md): the ADR wants the full 30-day list
/// scheduled at enrolment, but no endpoint returns future days — only
/// GET /me/today. Until one exists this schedules the cached days as a
/// rolling window, refreshed on every Today load. Reminders still fire
/// with no connectivity for everything already cached.
List<PlannedReminder> planReminders(
  List<TodayTask> tasks, {
  required DateTime now,
}) {
  final planned = <PlannedReminder>[];
  for (final task in tasks) {
    if (!task.isMedication || task.completed) continue;
    if (!task.scheduledFor.isAfter(now)) continue;
    planned.add(
      PlannedReminder(
        // Stable id per task so a reschedule replaces, never duplicates.
        id: task.id.hashCode & 0x7fffffff,
        taskId: task.id,
        fireAt: task.scheduledFor,
      ),
    );
  }
  return planned;
}

/// The one-off repeat after "Not yet" — exactly once, +30 minutes.
PlannedReminder planRepeat(String taskId, {required DateTime now}) =>
    PlannedReminder(
      // Distinct id space from the primary reminder → replaces any previous
      // repeat for the same task, so it can never fire twice.
      id: (taskId.hashCode & 0x3fffffff) | 0x40000000,
      taskId: taskId,
      fireAt: now.add(const Duration(minutes: 30)),
    );

class ReminderService {
  ReminderService(this._ref);

  final Ref _ref;
  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  static const _channelId = 'medication_reminders';

  Future<void> init({
    void Function(String taskId)? onOpenMedication,
  }) async {
    if (_initialized) return;
    tzdata.initializeTimeZones();
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
        // Desktop is a dev convenience, not a shipping target — but init
        // must not take the whole app down there.
        macOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
      onDidReceiveNotificationResponse: (response) {
        final taskId = response.payload;
        if (taskId != null && taskId.isNotEmpty) {
          // Tapping the reminder opens P8 DIRECTLY for that medication.
          onOpenMedication?.call(taskId);
        }
      },
    );
    _initialized = true;
  }

  Future<String> _channelName() async {
    final lang = _ref.read(languageProvider);
    final result = await _ref
        .read(contentRepositoryProvider)
        .resolve('medication.channel_name', lang);
    return result is ContentResolved ? result.text : _channelId;
  }

  /// Reschedule the cached window. Cancels the previous plan first so a
  /// changed schedule can never leave a stale reminder behind.
  Future<void> rescheduleFromTasks(List<TodayTask> tasks) async {
    if (!_initialized) return;
    final planned = planReminders(tasks, now: DateTime.now().toUtc());
    await _plugin.cancelAll();

    // The notification body is the medication's own content key resolved
    // in the patient's language — never composed text.
    final lang = _ref.read(languageProvider);
    final content = _ref.read(contentRepositoryProvider);
    final channelName = await _channelName();

    for (final plan in planned) {
      final task = tasks.firstWhere((t) => t.id == plan.taskId);
      final resolved = await content.resolve(task.contentRef, lang);
      if (resolved is! ContentResolved) continue; // fail closed: no invented text
      await _zonedSchedule(plan, resolved.text, channelName);
      await _ref
          .read(clientEventsProvider)
          .medicationReminderSent(taskId: plan.taskId);
    }
  }

  /// "Not yet" → repeat ONCE after 30 minutes.
  Future<void> scheduleRepeat(String taskId, String body) async {
    if (!_initialized) return;
    final plan = planRepeat(taskId, now: DateTime.now().toUtc());
    await _zonedSchedule(plan, body, await _channelName());
  }

  /// Whether the OS will currently show our notifications. null = unknown
  /// (uninitialized / platform without a check).
  Future<bool?> enabled() async {
    if (!_initialized) return null;
    try {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (android != null) return android.areNotificationsEnabled();
      final ios = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      if (ios != null) {
        final opts = await ios.checkPermissions();
        return opts?.isAlertEnabled;
      }
    } on Exception {
      return null;
    }
    return null;
  }

  Future<void> cancelForTask(String taskId) async {
    if (!_initialized) return;
    await _plugin.cancel(id: taskId.hashCode & 0x7fffffff);
    await _plugin.cancel(id: (taskId.hashCode & 0x3fffffff) | 0x40000000);
  }

  Future<void> _zonedSchedule(
    PlannedReminder plan,
    String body,
    String channelName,
  ) async {
    await _plugin.zonedSchedule(
      id: plan.id,
      body: body,
      scheduledDate: tz.TZDateTime.from(plan.fireAt, tz.local),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          channelName,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: plan.taskId,
    );
  }
}

final reminderServiceProvider =
    Provider<ReminderService>(ReminderService.new);

/// Deep link target used by main() when a notification is tapped.
String medicationRouteFor(String taskId) => '${Routes.medication}/$taskId';
