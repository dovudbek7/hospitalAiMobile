// P8 · Medication reminder & confirm.
//
//  - Exactly TWO actions: Taken · Not yet. No third option, no snooze menu,
//    no free text.
//  - "Not yet" closes and repeats the reminder ONCE after 30 minutes.
//  - Confirmed late is still recorded, with on_time: false — valuable data,
//    not a failure.
//  - The patient can never edit a dose or schedule anywhere in the app;
//    everything shown resolves from the clinic-approved content key.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/content/txt.dart';
import '../../core/notifications/reminders.dart';
import '../../core/providers.dart';
import '../../core/router/guards.dart';
import '../../core/telemetry/client_events.dart';
import '../../core/theme/tokens.dart';
import '../../core/theme/typography.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/secondary_button.dart';
import '../today/today_providers.dart';

class P8MedicationScreen extends ConsumerWidget {
  const P8MedicationScreen({required this.taskId, super.key});

  final String taskId;

  static void _close(BuildContext context) {
    // GoRouter in the app; plain Navigator in widget tests.
    final router = GoRouter.maybeOf(context);
    if (router == null) {
      Navigator.of(context).maybePop();
    } else if (router.canPop()) {
      router.pop();
    } else {
      router.go(Routes.today);
    }
  }

  Future<void> _taken(
    BuildContext context,
    WidgetRef ref,
    TodayTask task,
  ) async {
    // on_time = confirmed inside the clinic's window.
    final now = DateTime.now().toUtc();
    final onTime =
        task.windowClosesAt == null || now.isBefore(task.windowClosesAt!);

    await ref.read(todayProvider.notifier).toggleTask(task.id, completed: true);
    await ref
        .read(clientEventsProvider)
        .medicationConfirmed(taskId: task.id, onTime: onTime);
    await ref.read(reminderServiceProvider).cancelForTask(task.id);
    if (context.mounted) _close(context);
  }

  Future<void> _notYet(
    BuildContext context,
    WidgetRef ref,
    TodayTask task,
  ) async {
    // Repeat once after 30 minutes, with the approved content text.
    final lang = ref.read(languageProvider);
    final resolved = await ref
        .read(contentRepositoryProvider)
        .resolve(task.contentRef, lang);
    if (resolved is ContentResolved) {
      await ref
          .read(reminderServiceProvider)
          .scheduleRepeat(task.id, resolved.text);
    }
    if (context.mounted) _close(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = ref.watch(todayProvider).value;
    final task = today?.tasks.where((t) => t.id == taskId).firstOrNull;

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        leading: BackButton(onPressed: () => _close(context)),
      ),
      body: task == null
          ? const SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.all(AppSpace.s24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          BrandGradient(
                            borderRadius: BorderRadius.circular(28),
                            padding: const EdgeInsets.all(AppSpace.s24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Icon beside the name, not stacked above
                                // it — the stacked version pushed the dose
                                // and the time chip off a small screen.
                                Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 52,
                                      height: 52,
                                      decoration: BoxDecoration(
                                        color: AppColors.surface
                                            .withValues(alpha: .2),
                                        borderRadius:
                                            BorderRadius.circular(16),
                                      ),
                                      child: const Icon(
                                        Icons.medication_outlined,
                                        color: AppColors.surface,
                                        size: 26,
                                      ),
                                    ),
                                    const SizedBox(width: AppSpace.s16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Txt(
                                            'medication.scheduled_by_clinic',
                                            style: AppText.eyebrow.copyWith(
                                              color: AppColors.surface
                                                  .withValues(alpha: .75),
                                              letterSpacing: 1,
                                            ),
                                          ),
                                          const SizedBox(height: AppSpace.s4),
                                          // Name + dose = the clinic-approved
                                          // content string, verbatim.
                                          Txt(
                                            task.contentRef,
                                            style: AppText.display.copyWith(
                                              color: AppColors.surface,
                                              fontSize: 26,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppSpace.s16),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpace.s16,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.surface
                                        .withValues(alpha: .2),
                                    borderRadius:
                                        BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    task.timeLabel,
                                    style: AppText.button
                                        .copyWith(color: AppColors.surface),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSpace.s16),
                          Container(
                            padding: const EdgeInsets.all(AppSpace.s16),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: AppRadius.cardAll,
                              border: Border.all(color: AppColors.line),
                              boxShadow: AppShadow.card,
                            ),
                            child: const Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.info_outline_rounded,
                                  color: AppColors.brand700,
                                ),
                                SizedBox(width: AppSpace.s12),
                                Expanded(
                                  child: Txt(
                                    'medication.cannot_change',
                                    style: AppText.body,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // EXACTLY two actions.
                  PrimaryButton(
                    onPressed: () => _taken(context, ref, task),
                    child: const Txt('medication.taken'),
                  ),
                  const SizedBox(height: AppSpace.s12),
                  SecondaryButton(
                    onPressed: () => _notYet(context, ref, task),
                    child: const Txt('medication.not_yet'),
                  ),
                ],
              ),
            ),
    );
  }
}
