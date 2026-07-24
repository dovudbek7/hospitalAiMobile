import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import '../theme/typography.dart';

/// Escalation tiers. Colours are the spec's fixed safety tokens.
enum Tier { routine, urgent, emergency }

extension TierX on Tier {
  Color get color => switch (this) {
        Tier.routine => AppColors.routine,
        Tier.urgent => AppColors.urgent,
        Tier.emergency => AppColors.emergency,
      };

  IconData get icon => switch (this) {
        Tier.routine => Icons.check_rounded,
        Tier.urgent => Icons.warning_amber_rounded,
        Tier.emergency => Icons.warning_amber_rounded,
      };
}

/// Tier indicator. Carries an icon AND a text label as well as colour —
/// never colour alone (accessibility rule; ~8% of men have colour vision
/// deficiency and this app carries emergency information).
class TierChip extends StatelessWidget {
  const TierChip({required this.tier, required this.label, super.key});

  final Tier tier;

  /// Patient-visible label from the content library.
  final Widget label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpace.s16,
        vertical: AppSpace.s8,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.chip),
        border: Border.all(color: tier.color, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(tier.icon, size: 16, color: tier.color),
          const SizedBox(width: AppSpace.s8),
          DefaultTextStyle.merge(
            style: AppText.caption.copyWith(
              fontWeight: FontWeight.w700,
              color: tier.color,
            ),
            child: label,
          ),
        ],
      ),
    );
  }
}
