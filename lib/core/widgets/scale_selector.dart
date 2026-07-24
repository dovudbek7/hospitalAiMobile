import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import '../theme/typography.dart';

/// The 0–10 scale (P10): eleven circular 56dp targets in a horizontal row —
/// deliberately the ONLY horizontally scrollable element in the entire app.
/// End labels are patient-visible and come from the content library.
class ScaleSelector extends StatelessWidget {
  const ScaleSelector({
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 10,
    this.lowLabel,
    this.highLabel,
    super.key,
  });

  final int? value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;
  final Widget? lowLabel;
  final Widget? highLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.s4),
          child: Row(
            children: [
              for (var n = min; n <= max; n++) ...[
                if (n > min) const SizedBox(width: AppSpace.s8),
                _ScaleDot(
                  n: n,
                  selected: value == n,
                  onTap: () => onChanged(n),
                ),
              ],
            ],
          ),
        ),
        if (lowLabel != null || highLabel != null) ...[
          const SizedBox(height: AppSpace.s12),
          DefaultTextStyle.merge(
            style: AppText.caption.copyWith(fontWeight: FontWeight.w500),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                lowLabel ?? const SizedBox.shrink(),
                highLabel ?? const SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _ScaleDot extends StatelessWidget {
  const _ScaleDot({
    required this.n,
    required this.selected,
    required this.onTap,
  });

  final int n;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      value: '$n',
      child: Material(
        color: selected ? AppColors.brand600 : AppColors.surface,
        borderRadius: AppRadius.buttonAll,
        elevation: 0,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.buttonAll,
          child: Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: AppRadius.buttonAll,
              border:
                  selected ? null : Border.all(color: AppColors.line, width: 1),
              boxShadow: selected ? AppShadow.lift : AppShadow.card,
            ),
            child: Text(
              '$n',
              style: AppText.bodyL.copyWith(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: selected ? AppColors.surface : AppColors.ink,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
