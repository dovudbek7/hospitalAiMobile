// P10 · Symptom check-in. One question per screen. ZERO free-text inputs.
// Question text is a content key; option labels arrive pre-translated and
// render directly. Submit routes on the SERVER's tier, verbatim.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/content/emergency_bundle.dart';
import '../../core/content/txt.dart';
import '../../core/providers.dart';
import '../../core/models/api_models.dart';
import '../../core/router/guards.dart';
import '../../core/theme/tokens.dart';
import '../../core/theme/typography.dart';
import '../../core/util/dial.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/scale_selector.dart';
import '../../core/widgets/secondary_button.dart';
import 'checkin_providers.dart';

class P10CheckinScreen extends ConsumerWidget {
  const P10CheckinScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questions = ref.watch(checkinQuestionsProvider);
    final flow = ref.watch(checkinFlowProvider);

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: switch (flow.phase) {
          CheckinPhase.blockedOffline => const _BlockedOffline(),
          CheckinPhase.failed => const _Failed(),
          _ => questions.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => const _Failed(),
              data: (qs) => _QuestionPager(questions: qs, flow: flow),
            ),
        },
      ),
    );
  }
}

class _QuestionPager extends ConsumerWidget {
  const _QuestionPager({required this.questions, required this.flow});

  final List<CheckinQuestion> questions;
  final CheckinState flow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (questions.isEmpty) return const _Failed();
    final index = flow.index.clamp(0, questions.length - 1);
    final q = questions[index];
    final answer = flow.answers[q.ref];
    final answered = switch (q.type) {
      'multi' => answer is List && answer.isNotEmpty,
      _ => answer != null,
    };
    final last = index == questions.length - 1;
    final notifier = ref.read(checkinFlowProvider.notifier);
    final backLabel = switch (ref.watch(txtProvider('common.back'))) {
      AsyncData(value: final ContentResolved r) => r.text,
      _ => null,
    };

    return Padding(
      padding: const EdgeInsets.all(AppSpace.s24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              if (index > 0)
                IconButton(
                  onPressed: () => notifier.goTo(index - 1),
                  icon: const Icon(Icons.chevron_left_rounded),
                )
              else
                IconButton(
                  onPressed: () => context.go(Routes.today),
                  icon: const Icon(Icons.close_rounded),
                ),
              Expanded(
                child: Center(
                  child: Txt(
                    'checkin.progress',
                    vars: {
                      'N': '${index + 1}',
                      'TOTAL': '${questions.length}',
                    },
                    style:
                        AppText.caption.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              // Right slot stays clear for the emergency affordance.
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: AppSpace.s8),
          Row(
            children: [
              for (var i = 0; i < questions.length; i++) ...[
                if (i > 0) const SizedBox(width: AppSpace.s4),
                Expanded(
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: i <= index ? AppColors.brand600 : AppColors.line,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpace.s24),
          Expanded(
            // Clip.none so the option cards' soft shadow isn't cut into a
            // hard line at the scroll viewport's left/right edge. A little
            // horizontal padding keeps that shadow off the screen edge.
            child: SingleChildScrollView(
              clipBehavior: Clip.none,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpace.s4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Question text = content key, resolved.
                    Txt(
                      q.questionContentKey,
                      style: AppText.display.copyWith(fontSize: 25),
                    ),
                    const SizedBox(height: AppSpace.s16),
                    _AnswerArea(question: q, answer: answer),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpace.s16),
          Row(
            children: [
              if (index > 0) ...[
                // Compact icon-only Back so the labelled Next always fits,
                // at any font scale / language. The label lives in
                // semantics for screen readers.
                Semantics(
                  button: true,
                  label: backLabel,
                  child: SizedBox(
                    width: AppHit.key,
                    height: AppHit.key,
                    child: Material(
                      color: AppColors.surface,
                      borderRadius: AppRadius.buttonAll,
                      child: InkWell(
                        onTap: () => notifier.goTo(index - 1),
                        borderRadius: AppRadius.buttonAll,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: AppRadius.buttonAll,
                            border: Border.all(color: AppColors.line),
                          ),
                          child: const Icon(
                            Icons.chevron_left_rounded,
                            color: AppColors.brand700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpace.s12),
              ],
              Expanded(
                child: PrimaryButton(
                  onPressed: !answered || flow.submitting
                      ? null
                      : () async {
                          if (!last) {
                            notifier.goTo(index + 1);
                            return;
                          }
                          final route = await notifier.submit();
                          if (route != null && context.mounted) {
                            context.go(route);
                          }
                        },
                  child: flow.submitting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: AppColors.surface,
                          ),
                        )
                      : Txt(last ? 'checkin.submit' : 'checkin.next'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Renders the allowed answer types — single / multi / scale (and yes-no,
/// which arrives as `single` with two options). NOTHING ELSE. There is no
/// free-text input on this screen, by construction.
class _AnswerArea extends ConsumerWidget {
  const _AnswerArea({required this.question, required this.answer});

  final CheckinQuestion question;
  final Object? answer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(checkinFlowProvider.notifier);

    switch (question.type) {
      case 'scale':
        final min = question.scale?.min ?? 0;
        final max = question.scale?.max ?? 10;
        return ScaleSelector(
          value: answer is int ? answer! as int : null,
          min: min,
          max: max,
          onChanged: (v) => notifier.answer(question.ref, v),
          lowLabel: Txt('${question.questionContentKey}.low'),
          highLabel: Txt('${question.questionContentKey}.high'),
          hint: const Txt('checkin.scale_hint'),
        );
      case 'multi':
        final selected =
            answer is List ? (answer! as List).cast<String>() : const <String>[];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Txt('checkin.multi_hint', style: AppText.caption),
            const SizedBox(height: AppSpace.s12),
            for (final option in question.options) ...[
              _OptionTile(
                // Labels arrive PRE-TRANSLATED from the API — rendered
                // directly, never re-translated (spec P10).
                label: option.label,
                selected: selected.contains(option.code),
                square: true,
                onTap: () => notifier.toggleMulti(question.ref, option.code),
              ),
              const SizedBox(height: AppSpace.s8),
            ],
          ],
        );
      default: // 'single' and yes/no
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final option in question.options) ...[
              _OptionTile(
                label: option.label,
                selected: answer == option.code,
                onTap: () => notifier.answer(question.ref, option.code),
              ),
              const SizedBox(height: AppSpace.s12),
            ],
          ],
        );
    }
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.label,
    required this.selected,
    required this.onTap,
    this.square = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool square;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected ? AppColors.brand50 : AppColors.surface,
        borderRadius: AppRadius.cardAll,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.cardAll,
          child: Container(
            constraints: const BoxConstraints(minHeight: AppHit.key),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpace.s16,
              vertical: AppSpace.s12,
            ),
            decoration: BoxDecoration(
              // The fill belongs on the SAME box as the shadow: without it
              // the card shadow was painting through the transparent tile
              // and washing the row grey.
              color: selected ? AppColors.brand50 : AppColors.surface,
              borderRadius: AppRadius.cardAll,
              border: Border.all(
                color: selected ? AppColors.brand600 : AppColors.line,
                width: selected ? 2 : 1,
              ),
              boxShadow: selected ? null : AppShadow.card,
            ),
            child: Row(
              children: [
                Container(
                  // NOT AnimatedContainer: reusing one element across a
                  // single→multi question would lerp a circle into a
                  // rounded rect and crash ("a circle cannot have a border
                  // radius"). A plain box, keyed by shape, is safe.
                  key: ValueKey(square),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color:
                        selected ? AppColors.brand600 : AppColors.surface,
                    shape: square ? BoxShape.rectangle : BoxShape.circle,
                    borderRadius:
                        square ? BorderRadius.circular(8) : null,
                    border: selected
                        ? null
                        : Border.all(color: AppColors.line, width: 2),
                  ),
                  child: selected
                      ? const Icon(
                          Icons.check_rounded,
                          size: 18,
                          color: AppColors.surface,
                        )
                      : null,
                ),
                const SizedBox(width: AppSpace.s12),
                Expanded(
                  child: Text(
                    label, // pre-translated API data
                    style: AppText.bodyL.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Offline: submission is BLOCKED and nothing is queued. The patient gets
/// the clinic phone and the emergency instruction, plainly.
class _BlockedOffline extends ConsumerWidget {
  const _BlockedOffline();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _StateScreen(
      icon: Icons.wifi_off_rounded,
      titleKey: 'offline.blocked_title',
      bodyKey: 'offline.checkin_blocked',
      noteKey: 'offline.not_queued',
      onRetry: () => ref.read(checkinFlowProvider.notifier).backToAnswering(),
    );
  }
}

/// Explicit failure — NEVER rendered as success (spec P10).
class _Failed extends ConsumerWidget {
  const _Failed();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _StateScreen(
      icon: Icons.error_outline_rounded,
      titleKey: 'offline.blocked_title',
      bodyKey: 'checkin.failed',
      onRetry: () => ref.read(checkinFlowProvider.notifier).backToAnswering(),
    );
  }
}

class _StateScreen extends StatelessWidget {
  const _StateScreen({
    required this.icon,
    required this.titleKey,
    required this.bodyKey,
    required this.onRetry,
    this.noteKey,
  });

  final IconData icon;
  final String titleKey;
  final String bodyKey;
  final String? noteKey;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpace.s24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    color: AppColors.brand50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: AppColors.brand700, size: 36),
                ),
                const SizedBox(height: AppSpace.s24),
                Txt(titleKey, style: AppText.display.copyWith(fontSize: 28)),
                const SizedBox(height: AppSpace.s12),
                Txt(bodyKey, style: AppText.bodyL),
                if (noteKey != null) ...[
                  const SizedBox(height: AppSpace.s16),
                  Container(
                    padding: const EdgeInsets.all(AppSpace.s16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: AppRadius.cardAll,
                      border: Border.all(color: AppColors.line),
                    ),
                    child: Txt(noteKey!, style: AppText.body),
                  ),
                ],
              ],
            ),
          ),
          FutureBuilder<EmergencyBundle?>(
            future: EmergencyBundle.load(),
            builder: (context, snapshot) {
              final bundle = snapshot.data;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (bundle != null) ...[
                    PrimaryButton(
                      onPressed: () => dial(bundle.clinicPhone),
                      icon: const Icon(Icons.call_rounded),
                      child: const Txt('emergency.call_clinic'),
                    ),
                    const SizedBox(height: AppSpace.s12),
                    PrimaryButton(
                      onPressed: () => dial(bundle.ambulanceNumber),
                      icon: const Icon(Icons.call_rounded),
                      child: const Txt('emergency.call_103'),
                    ),
                    const SizedBox(height: AppSpace.s12),
                  ],
                  SecondaryButton(
                    onPressed: onRetry,
                    child: const Txt('checkin.back'),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
