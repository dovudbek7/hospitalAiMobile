// P6 · Today — the core loop. 90% of app time lives here.
//
//  - Completed tasks stay visible (motivation).
//  - Overdue is grey with a grey dot. Never red, never "you missed".
//  - Day 0 / no tasks → explicit welcoming empty state, never a blank list.
//  - After day 30 → programme-complete state routing to P17.
//  - Renders from cache when offline, with the discreet offline strip.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/content/emergency_bundle.dart';
import '../../core/content/txt.dart';
import '../../core/providers.dart';
import '../../core/router/guards.dart';
import '../../core/sync/connectivity.dart';
import '../../core/theme/tokens.dart';
import '../../core/theme/typography.dart';
import '../../core/util/dial.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_sheet.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/misc.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/secondary_button.dart';
import '../../core/widgets/task_row.dart';
import 'today_providers.dart';

class P6TodayScreen extends ConsumerWidget {
  const P6TodayScreen({super.key});

  IconData _iconFor(String taskType) => switch (taskType) {
        'medication' => Icons.medication_outlined,
        'activity' => Icons.directions_walk_rounded,
        'wound_care' => Icons.healing_outlined,
        'education' => Icons.menu_book_outlined,
        'checkin' => Icons.assignment_turned_in_outlined,
        _ => Icons.event_note_outlined,
      };

  (Color, Color) _tintFor(String taskType) => switch (taskType) {
        'activity' => (AppColors.tintGreenBg, AppColors.success),
        'wound_care' => (AppColors.tintAmberBg, AppColors.tintAmberFg),
        'education' => (AppColors.tintVioletBg, AppColors.tintVioletFg),
        _ => (AppColors.brand50, AppColors.brand700),
      };

  Future<void> _contactClinic(BuildContext context) async {
    final bundle = await EmergencyBundle.load();
    if (!context.mounted) return;
    await showAppSheet<void>(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Txt('contact.body', style: AppText.bodyL),
          const SizedBox(height: AppSpace.s24),
          if (bundle != null)
            PrimaryButton(
              height: 56,
              onPressed: () => dial(bundle.clinicPhone),
              icon: const Icon(Icons.call_rounded),
              child: Text(bundle.clinicPhone), // number = data
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = ref.watch(todayProvider);
    final online = ref.watch(onlineProvider).value ?? true;

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: today.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorState(onRetry: () => ref.invalidate(todayProvider)),
        data: (view) => RefreshIndicator(
          onRefresh: () => ref.refresh(todayProvider.future),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _Hero(view: view)),
              if (!online || view.fromCache)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppSpace.s16,
                      AppSpace.s12,
                      AppSpace.s16,
                      0,
                    ),
                    child: OfflineStrip(label: Txt('offline.indicator')),
                  ),
                ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpace.s16,
                  AppSpace.s12,
                  AppSpace.s16,
                  120,
                ),
                sliver: SliverList.list(
                  children: [
                    if (view.programmeComplete)
                      _ProgrammeComplete(
                        onSurvey: () => context.push(Routes.survey),
                      )
                    else if (view.tasks.isEmpty)
                      const _EmptyDay()
                    else ...[
                      if (view.checkinDue) ...[
                        _CheckinCta(
                          onTap: () => context.push(Routes.checkin),
                        ),
                        const SizedBox(height: AppSpace.s24),
                      ],
                      const Eyebrow(child: Txt('today.plan_header')),
                      const SizedBox(height: AppSpace.s12),
                      for (final task in view.tasks) ...[
                        _TaskCard(
                          task: task,
                          icon: _iconFor(task.taskType),
                          tint: _tintFor(task.taskType),
                        ),
                        const SizedBox(height: AppSpace.s12),
                      ],
                    ],
                    const SizedBox(height: AppSpace.s4),
                    SecondaryButton(
                      height: 58,
                      onPressed: () => _contactClinic(context),
                      icon: const Icon(Icons.call_rounded),
                      child: const Txt('contact.button'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Hero extends ConsumerWidget {
  const _Hero({required this.view});

  final TodayView view;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vars = ref.watch(interpolationVarsProvider);
    final firstName = vars['FIRST_NAME'];
    final progress = (view.recoveryDay / 30).clamp(0.0, 1.0);

    return BrandGradient(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
      padding: EdgeInsets.fromLTRB(
        AppSpace.s16,
        MediaQuery.paddingOf(context).top + AppSpace.s8,
        AppSpace.s16,
        AppSpace.s24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            // Clears the emergency affordance on the right.
            padding: const EdgeInsets.only(right: 56),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(alpha: .2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.surface.withValues(alpha: .25),
                    ),
                  ),
                  child: Text(
                    firstName?.isNotEmpty == true
                        ? firstName!.substring(0, 1)
                        : '•',
                    style: AppText.h2.copyWith(color: AppColors.surface),
                  ),
                ),
                const SizedBox(width: AppSpace.s12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Txt(
                        'today.greeting',
                        style: AppText.caption.copyWith(
                          color: AppColors.surface.withValues(alpha: .75),
                        ),
                      ),
                      Text(
                        firstName ?? '',
                        style: AppText.h1.copyWith(
                          color: AppColors.surface,
                          fontSize: 19,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpace.s16),
          GlassCard(
            child: Row(
              children: [
                ProgressRing(
                  progress: progress,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${view.recoveryDay}',
                        style: AppText.h1.copyWith(
                          color: AppColors.surface,
                          fontSize: 19,
                          height: 1,
                        ),
                      ),
                      Text(
                        '30',
                        style: AppText.caption.copyWith(
                          color: AppColors.surface.withValues(alpha: .75),
                          fontSize: 10,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpace.s16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Txt(
                        'today.title',
                        vars: {'N': '${view.recoveryDay}'},
                        style: AppText.h1.copyWith(
                          color: AppColors.surface,
                          fontSize: 19,
                        ),
                      ),
                      const SizedBox(height: AppSpace.s4),
                      Txt(
                        'today.done_count',
                        vars: {
                          'N': '${view.doneCount}',
                          'TOTAL': '${view.tasks.length}',
                        },
                        style: AppText.caption.copyWith(
                          color: AppColors.surface.withValues(alpha: .8),
                        ),
                      ),
                      const SizedBox(height: AppSpace.s8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          value: view.tasks.isEmpty
                              ? 0
                              : view.doneCount / view.tasks.length,
                          minHeight: 6,
                          backgroundColor:
                              AppColors.surface.withValues(alpha: .25),
                          valueColor: const AlwaysStoppedAnimation(
                            AppColors.surface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskCard extends ConsumerWidget {
  const _TaskCard({
    required this.task,
    required this.icon,
    required this.tint,
  });

  final TodayTask task;
  final IconData icon;
  final (Color, Color) tint;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overdue = task.overdueAt(DateTime.now().toUtc());
    final state = task.completed
        ? TaskRowState.completed
        : overdue
            ? TaskRowState.overdue
            : TaskRowState.pending;

    return TaskRow(
      icon: Icon(icon),
      // Task title = clinician-approved content, resolved by key.
      title: Txt(task.contentRef),
      time: task.timeLabel,
      state: state,
      overdueSuffix: const Txt('today.overdue'),
      iconBackground: tint.$1,
      iconColor: tint.$2,
      onTap: () => context.push(
        task.isMedication
            ? '${Routes.medication}/${task.id}'
            : '${Routes.task}/${task.id}',
      ),
      onToggle: () {
        if (task.completed) {
          // Mis-tap correction lives on P7 (spec): opening the detail
          // screen offers Undo, which logs a NEW event.
          context.push(
            task.isMedication
                ? '${Routes.medication}/${task.id}'
                : '${Routes.task}/${task.id}',
          );
        } else {
          ref
              .read(todayProvider.notifier)
              .toggleTask(task.id, completed: true);
        }
      },
    );
  }
}

class _CheckinCta extends StatelessWidget {
  const _CheckinCta({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      lifted: true,
      borderColor: AppColors.brand200,
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.brand500, AppColors.brand700],
              ),
              borderRadius: BorderRadius.circular(17),
            ),
            child: const Icon(
              Icons.assignment_turned_in_outlined,
              color: AppColors.surface,
              size: 25,
            ),
          ),
          const SizedBox(width: AppSpace.s12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Txt('today.checkin_prompt', style: AppText.h2),
                SizedBox(height: 2),
                Txt('today.checkin_meta', style: AppText.caption),
              ],
            ),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: AppColors.brand600,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_forward_rounded,
              color: AppColors.surface,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyDay extends StatelessWidget {
  const _EmptyDay();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpace.s32),
      child: Column(
        children: [
          Container(
            width: AppSpace.s64,
            height: AppSpace.s64,
            decoration: const BoxDecoration(
              color: AppColors.brand50,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: AppColors.brand700,
              size: 32,
            ),
          ),
          const SizedBox(height: AppSpace.s16),
          Txt(
            'today.empty',
            style: AppText.h2.copyWith(fontSize: 19),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ProgrammeComplete extends StatelessWidget {
  const _ProgrammeComplete({required this.onSurvey});

  final VoidCallback onSurvey;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpace.s24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Txt(
            'today.programme_complete',
            style: AppText.h1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpace.s16),
          PrimaryButton(
            onPressed: onSurvey,
            child: const Txt('today.go_survey'),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpace.s24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Txt(
              'error.generic',
              style: AppText.bodyL,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpace.s24),
            PrimaryButton(
              height: 56,
              onPressed: onRetry,
              child: const Txt('common.continue'),
            ),
          ],
        ),
      ),
    );
  }
}
