import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Shared animated bottom sheet: slide-up with the prototype's spring-ish
/// curve, rounded 30 top, drag handle. Children can opt into a staggered
/// entrance with [SheetItem].
Future<T?> showAppSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isDismissible = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    isDismissible: isDismissible,
    backgroundColor: Colors.transparent,
    barrierColor: AppColors.ink.withValues(alpha: 0.45),
    transitionAnimationController: AnimationController(
      vsync: Navigator.of(context),
      duration: AppDur.sheet,
    ),
    builder: (context) => _SheetShell(child: builder(context)),
  );
}

class _SheetShell extends StatelessWidget {
  const _SheetShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(
          left: AppSpace.s24,
          right: AppSpace.s24,
          top: AppSpace.s12,
          bottom: AppSpace.s24 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.sheet),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.line,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: AppSpace.s16),
            Flexible(child: child),
          ],
        ),
      ),
    );
  }
}

/// Staggered entrance for sheet content (the prototype's `sheet-item`).
/// Honours reduced motion: with animations disabled the child just appears.
class SheetItem extends StatelessWidget {
  const SheetItem({required this.index, required this.child, super.key});

  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return child;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 380 + index * 50),
      curve: Interval(
        (index * 0.08).clamp(0.0, 0.6),
        1,
        curve: Curves.easeOutCubic,
      ),
      builder: (context, t, child) => Opacity(
        opacity: t,
        child: Transform.translate(
          offset: Offset(0, (1 - t) * 10),
          child: child,
        ),
      ),
      child: child,
    );
  }
}
