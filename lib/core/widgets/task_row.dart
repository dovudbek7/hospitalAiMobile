import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import '../theme/typography.dart';

enum TaskRowState {
  pending,
  completed,

  /// Overdue is grey, never red, never scolding. Red is reserved exclusively
  /// for medical emergency (standing rule 8).
  overdue,
}

/// Task row from the prototype: icon tile · wrapping title + time · checkbox.
///
/// - Completed tasks stay visible (success tick, muted, strikethrough) —
///   seeing what you finished is the motivation.
/// - The checkbox is 34dp inside a [AppHit.key] (64dp) tap target.
/// - [title] and [overdueSuffix] are patient-visible and must be resolved
///   from the content library by the caller. [time] is data, not prose.
class TaskRow extends StatelessWidget {
  const TaskRow({
    required this.icon,
    required this.title,
    required this.time,
    required this.state,
    required this.onToggle,
    this.onTap,
    this.overdueSuffix,
    this.iconBackground = AppColors.brand50,
    this.iconColor = AppColors.brand700,
    this.toggleSemanticLabel,
    super.key,
  });

  final Widget icon;
  final Widget title;
  final String time;
  final TaskRowState state;
  final VoidCallback onToggle;
  final VoidCallback? onTap;

  /// e.g. Txt('today.overdue') — rendered after the time, in overdue grey.
  final Widget? overdueSuffix;
  final Color iconBackground;
  final Color iconColor;
  final String? toggleSemanticLabel;

  @override
  Widget build(BuildContext context) {
    final completed = state == TaskRowState.completed;
    final overdue = state == TaskRowState.overdue;

    return Container(
      constraints: const BoxConstraints(minHeight: 72),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.cardAll,
        border: Border.all(color: AppColors.line),
        boxShadow: AppShadow.card,
      ),
      padding: const EdgeInsets.all(AppSpace.s12),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onTap,
              borderRadius: AppRadius.tileAll,
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: completed ? AppColors.tintGreenBg : iconBackground,
                      borderRadius: AppRadius.tileAll,
                    ),
                    child: IconTheme.merge(
                      data: IconThemeData(
                        color: completed
                            ? AppColors.success
                            : (overdue ? AppColors.overdue : iconColor),
                        size: 22,
                      ),
                      child: Center(child: icon),
                    ),
                  ),
                  const SizedBox(width: AppSpace.s12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DefaultTextStyle.merge(
                          style: AppText.bodyL.copyWith(
                            fontWeight: FontWeight.w600,
                            color: completed ? AppColors.muted : AppColors.ink,
                            decoration:
                                completed ? TextDecoration.lineThrough : null,
                            decorationColor:
                                AppColors.muted.withValues(alpha: 0.5),
                          ),
                          child: title,
                        ),
                        const SizedBox(height: AppSpace.s4),
                        Row(
                          children: [
                            if (overdue) ...[
                              Container(
                                width: 5,
                                height: 5,
                                decoration: const BoxDecoration(
                                  color: AppColors.overdue,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                            ],
                            DefaultTextStyle.merge(
                              style: AppText.caption.copyWith(
                                color: overdue
                                    ? AppColors.overdue
                                    : AppColors.muted,
                                fontWeight:
                                    overdue ? FontWeight.w500 : FontWeight.w400,
                              ),
                              child: Text(time), // literal-ok: data, not prose
                            ),
                            if (overdue && overdueSuffix != null) ...[
                              DefaultTextStyle.merge(
                                style: AppText.caption
                                    .copyWith(color: AppColors.overdue),
                                child: const Text(' · '), // literal-ok: punctuation
                              ),
                              Flexible(
                                child: DefaultTextStyle.merge(
                                  style: AppText.caption.copyWith(
                                    color: AppColors.overdue,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  child: overdueSuffix!,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Semantics(
            button: true,
            label: toggleSemanticLabel,
            child: InkWell(
              onTap: onToggle,
              customBorder: const CircleBorder(),
              child: SizedBox(
                width: AppHit.key,
                height: AppHit.key,
                child: Center(
                  child: AnimatedContainer(
                    duration: AppDur.fast,
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: completed ? AppColors.success : AppColors.surface,
                      borderRadius: BorderRadius.circular(11),
                      border: completed
                          ? null
                          : Border.all(color: AppColors.line, width: 2),
                    ),
                    child: completed
                        ? const Icon(
                            Icons.check_rounded,
                            size: 20,
                            color: AppColors.surface,
                          )
                        : null,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
