import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Translucent card for use on the brand-gradient hero (`bg-white/15`).
class GlassCard extends StatelessWidget {
  const GlassCard({
    required this.child,
    this.padding = const EdgeInsets.all(AppSpace.s16),
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.surface.withValues(alpha: 0.2)),
      ),
      child: child,
    );
  }
}

/// The brand hero gradient shared by P6/P8/P9/P16 headers.
class BrandGradient extends StatelessWidget {
  const BrandGradient({
    required this.child,
    this.borderRadius,
    this.padding,
    super.key,
  });

  final Widget child;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.brand500, AppColors.brand700],
        ),
      ),
      child: child,
    );
  }
}
