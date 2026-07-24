// P7 · Task detail. The instruction is clinician-approved content resolved
// by key — missing/unapproved fails closed with the clinic contact. An
// already-completed task offers Undo: the correction is a NEW event
// (task_uncompleted), never a mutation of the original.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/content/emergency_bundle.dart';
import '../../core/content/txt.dart';
import '../../core/theme/tokens.dart';
import '../../core/theme/typography.dart';
import '../../core/util/dial.dart';
import '../../core/widgets/fail_closed_panel.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/secondary_button.dart';
import 'today_providers.dart';

class P7TaskDetailScreen extends ConsumerWidget {
  const P7TaskDetailScreen({required this.taskId, super.key});

  final String taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = ref.watch(todayProvider).value;
    final task = today?.tasks.where((t) => t.id == taskId).firstOrNull;

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: task == null
          ? const SizedBox.shrink()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpace.s24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Title resolves from the same contentRef as the row.
                  Txt(
                    task.contentRef,
                    style: AppText.display.copyWith(fontSize: 24),
                  ),
                  const SizedBox(height: AppSpace.s4),
                  Text(task.timeLabel, style: AppText.caption),
                  const SizedBox(height: AppSpace.s24),

                  // Full instruction: `<contentRef>.instructions` by
                  // convention; fails closed if unapproved.
                  _Instructions(contentRef: task.contentRef),

                  const SizedBox(height: AppSpace.s24),
                  if (task.completed) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpace.s12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.tintGreenBg,
                        borderRadius: AppRadius.buttonAll,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.check_rounded,
                            color: AppColors.success,
                          ),
                          const SizedBox(width: AppSpace.s8),
                          Txt(
                            'task.done',
                            style: AppText.button
                                .copyWith(color: AppColors.success),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpace.s12),
                    SecondaryButton(
                      onPressed: () async {
                        // Undo = a NEW uncomplete action in the queue.
                        await ref
                            .read(todayProvider.notifier)
                            .toggleTask(task.id, completed: false);
                        if (context.mounted) context.pop();
                      },
                      child: const Txt('task.undo'),
                    ),
                  ] else
                    PrimaryButton(
                      onPressed: () async {
                        await ref
                            .read(todayProvider.notifier)
                            .toggleTask(task.id, completed: true);
                        if (context.mounted) context.pop();
                      },
                      child: const Txt('task.mark_done'),
                    ),
                ],
              ),
            ),
    );
  }
}

class _Instructions extends ConsumerWidget {
  const _Instructions({required this.contentRef});

  final String contentRef;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = '$contentRef.instructions';
    return TxtGate(
      requiredKeys: [key],
      fallback: FutureBuilder<EmergencyBundle?>(
        future: EmergencyBundle.load(),
        builder: (context, snapshot) => FailClosedPanel(
          title: const Txt('content.unavailable_in_language'),
          body: const Txt('content.contact_hint'),
          callLabel: Text(snapshot.data?.clinicPhone ?? ''),
          onCallClinic: () {
            final phone = snapshot.data?.clinicPhone;
            if (phone != null) dial(phone);
          },
          diagnosticCode: 'CONTENT_NOT_APPROVED',
        ),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpace.s16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.cardAll,
          border: Border.all(color: AppColors.line),
          boxShadow: AppShadow.card,
        ),
        child: Txt(key, style: AppText.bodyL),
      ),
    );
  }
}
