// Shared onboarding chrome: which of the three enrolment steps the patient
// is on (code → phone → consent) plus the way back to the previous one.
//
// Consent is deliberately back-less: once a session exists the router guard
// pins the patient to P4 until they agree or decline, so a back control there
// would bounce straight back and read as a broken button.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/content/txt.dart';
import '../../core/providers.dart';
import '../../core/theme/tokens.dart';
import '../../core/theme/typography.dart';

class OnboardingHeader extends StatelessWidget {
  const OnboardingHeader({required this.step, this.onBack, super.key});

  /// 1-based: 1 = code, 2 = phone, 3 = consent.
  final int step;

  /// Null hides the control (no reachable previous step).
  final VoidCallback? onBack;

  static const totalSteps = 3;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (onBack != null)
          _BackButton(onPressed: onBack!)
        else
          const SizedBox(width: AppHit.min, height: AppHit.min),
        const SizedBox(width: AppSpace.s16),
        Expanded(
          flex: 3,
          child: Row(
            children: [
              for (var i = 1; i <= totalSteps; i++) ...[
                if (i > 1) const SizedBox(width: AppSpace.s8),
                Expanded(
                  child: AnimatedContainer(
                    duration: AppDur.screen,
                    height: 6,
                    decoration: BoxDecoration(
                      color: i <= step ? AppColors.brand600 : AppColors.line,
                      borderRadius: BorderRadius.circular(AppRadius.chip),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: AppSpace.s16),
        // Flexible + one line: the label is short by design, but content is
        // server-supplied and a long translation must not overflow the row.
        Flexible(
          flex: 2,
          child: Txt(
            'onboarding.step',
            style: AppText.caption.copyWith(
              color: AppColors.muted,
              fontWeight: FontWeight.w700,
            ),
            vars: {'N': '$step', 'TOTAL': '$totalSteps'},
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

/// Icon-only, so its accessible name comes from the content library like any
/// other patient-visible string — never a hardcoded label.
class _BackButton extends ConsumerWidget {
  const _BackButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(txtProvider('common.back'));
    final label = switch (result) {
      AsyncData(value: final ContentResolved r) => r.text,
      _ => null,
    };

    return Semantics(
      button: true,
      label: label,
      child: SizedBox(
        width: AppHit.min,
        height: AppHit.min,
        child: Material(
          color: AppColors.surface,
          shape: const CircleBorder(
            side: BorderSide(color: AppColors.line),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onPressed,
            child: const Icon(
              Icons.arrow_back_rounded,
              color: AppColors.ink,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }
}
