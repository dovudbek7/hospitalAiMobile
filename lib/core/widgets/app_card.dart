import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Standard surface card: white, radius 20, hairline ring, soft shadow.
class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.padding = const EdgeInsets.all(AppSpace.s16),
    this.onTap,
    this.lifted = false,
    this.borderColor,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  /// Stronger elevation for hero cards (the prototype's `shadow-lift`).
  final bool lifted;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.cardAll,
        border: Border.all(color: borderColor ?? AppColors.line),
        boxShadow: lifted ? AppShadow.lift : AppShadow.card,
      ),
      child: onTap == null
          ? Padding(padding: padding, child: child)
          : Material(
              color: Colors.transparent,
              borderRadius: AppRadius.cardAll,
              child: InkWell(
                onTap: onTap,
                borderRadius: AppRadius.cardAll,
                child: Padding(padding: padding, child: child),
              ),
            ),
    );
    return card;
  }
}
