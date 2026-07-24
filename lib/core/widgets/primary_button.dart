import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import '../theme/typography.dart';

/// Filled brand button. Defaults to the 64dp key-action height — the spec's
/// size for Continue / Taken / Mark as done. Pass [height] 56 for lesser
/// actions.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.child,
    required this.onPressed,
    this.icon,
    this.height = AppHit.key,
    this.background = AppColors.brand600,
    this.foreground = AppColors.surface,
    super.key,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final Widget? icon;
  final double height;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null;
    return Semantics(
      button: true,
      enabled: !disabled,
      child: Material(
        // Disabled stays visible: line fill + muted text, never ghosted.
        color: disabled ? AppColors.line : background,
        borderRadius: AppRadius.buttonAll,
        child: InkWell(
          onTap: onPressed,
          borderRadius: AppRadius.buttonAll,
          child: Container(
            height: height,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: AppSpace.s16),
            child: DefaultTextStyle.merge(
              style: AppText.button.copyWith(
                color: disabled ? AppColors.muted : foreground,
              ),
              child: IconTheme.merge(
                data: IconThemeData(
                  color: disabled ? AppColors.muted : foreground,
                  size: 22,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      icon!,
                      const SizedBox(width: AppSpace.s8),
                    ],
                    Flexible(child: child),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
