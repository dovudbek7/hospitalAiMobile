// P9 · My progress. The percentage excludes future tasks (the API already
// does this) and ALWAYS shows its denominator. No clinical interpretation,
// no discouraging copy at any adherence level. Works offline from cache.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/content/txt.dart';
import '../../core/theme/tokens.dart';
import '../../core/theme/typography.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/misc.dart';
import '../today/today_providers.dart';

class P9ProgressScreen extends ConsumerWidget {
  const P9ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressProvider);
    final day = ref.watch(todayProvider).value?.recoveryDay ??
        progress.value?.daysCompleted ??
        0;

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: progress.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => const Center(
            child: Padding(
              padding: EdgeInsets.all(AppSpace.s24),
              child: Txt(
                'error.generic',
                style: AppText.bodyL,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          data: (p) => ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpace.s16,
              AppSpace.s24,
              AppSpace.s16,
              120,
            ),
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 56),
                child: Txt(
                  'progress.title',
                  style: AppText.display.copyWith(fontSize: 30),
                ),
              ),
              const SizedBox(height: AppSpace.s16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _StatCard(
                      label: const Txt('progress.days_label'),
                      value: Text(
                        '$day',
                        style: AppText.display
                            .copyWith(color: AppColors.brand700),
                      ),
                      caption: Txt(
                        'progress.days',
                        vars: {'N': '$day'},
                        style: AppText.caption,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpace.s12),
                  Expanded(
                    child: _StatCard(
                      label: const Txt('progress.completed_label'),
                      value: Text(
                        // No tasks counted yet → a dash, not a bare 0%.
                        p.adherence.denominator == 0
                            ? '—'
                            : '${(p.adherence.value * 100).round()}%',
                        style: AppText.display
                            .copyWith(color: AppColors.brand700),
                      ),
                      // The denominator is ALWAYS shown once there is one.
                      caption: p.adherence.denominator == 0
                          ? const Txt(
                              'progress.not_counted',
                              style: AppText.caption,
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Txt(
                                  'progress.tasks_frac',
                                  vars: {
                                    'N': '${p.adherence.numerator}',
                                    'TOTAL': '${p.adherence.denominator}',
                                  },
                                  style: AppText.caption,
                                ),
                                const Txt(
                                  'progress.not_counted',
                                  style: AppText.caption,
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpace.s12),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Txt('progress.programme', style: AppText.h2),
                    const SizedBox(height: AppSpace.s16),
                    DayGrid(
                      totalDays: p.programmeDays,
                      currentDay: day.clamp(0, p.programmeDays),
                    ),
                    const SizedBox(height: AppSpace.s16),
                    const Wrap(
                      spacing: AppSpace.s16,
                      runSpacing: AppSpace.s8,
                      children: [
                        _LegendDot(
                          color: AppColors.success,
                          label: Txt('progress.legend.completed'),
                        ),
                        _LegendDot(
                          color: AppColors.brand100,
                          border: AppColors.brand600,
                          label: Txt('progress.legend.today'),
                        ),
                        _LegendDot(
                          color: AppColors.line,
                          label: Txt('progress.legend.upcoming'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpace.s12),
              BrandGradient(
                borderRadius: BorderRadius.circular(AppRadius.card),
                padding: const EdgeInsets.all(AppSpace.s24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Rotates by day parity; both lines are neutral at
                    // every adherence level — never discouraging.
                    Txt(
                      day.isEven
                          ? 'progress.encouragement.1'
                          : 'progress.encouragement.2',
                      style: AppText.h2.copyWith(
                        color: AppColors.surface,
                        fontSize: 19,
                      ),
                    ),
                    const SizedBox(height: AppSpace.s4),
                    Txt(
                      'progress.days',
                      vars: {'N': '$day'},
                      style: AppText.caption.copyWith(
                        color: AppColors.surface.withValues(alpha: .8),
                      ),
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

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.caption,
  });

  final Widget label;
  final Widget value;
  final Widget caption;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Eyebrow(child: label),
          const SizedBox(height: AppSpace.s4),
          value,
          const SizedBox(height: AppSpace.s4),
          caption,
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label, this.border});

  final Color color;
  final Color? border;
  final Widget label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: border == null ? null : Border.all(color: border!, width: 2),
          ),
        ),
        const SizedBox(width: 6),
        DefaultTextStyle.merge(
          style: AppText.caption.copyWith(fontSize: 12),
          child: label,
        ),
      ],
    );
  }
}
