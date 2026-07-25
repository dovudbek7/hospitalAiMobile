import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import '../theme/typography.dart';

/// White card-style button with brand text — the prototype's ghost button.
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    required this.child,
    required this.onPressed,
    this.icon,
    this.height = AppHit.key,
    this.foreground = AppColors.brand700,
    super.key,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final Widget? icon;
  final double height;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onPressed != null,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: AppRadius.buttonAll,
          boxShadow: AppShadow.card,
        ),
        child: Material(
          color: AppColors.surface,
          borderRadius: AppRadius.buttonAll,
          child: InkWell(
            onTap: onPressed,
            borderRadius: AppRadius.buttonAll,
            child: Container(
              height: height,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: AppSpace.s16),
              decoration: BoxDecoration(
                borderRadius: AppRadius.buttonAll,
                border: Border.all(color: AppColors.line),
              ),
              child: DefaultTextStyle.merge(
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: AppText.button.copyWith(color: foreground),
                child: IconTheme.merge(
                  data: IconThemeData(color: foreground, size: 20),
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
      ),
    );
  }
}
