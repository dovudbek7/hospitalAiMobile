import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// The persistent emergency affordance — ratified deviation from the spec's
/// full-width banner (md/steps.md, "Ratified deviations").
///
/// A 44dp red circle, present on every patient screen except P1 (its rule:
/// nothing else on screen) and P13 (the whole screen IS the alert). It is
/// **never dismissible** — only the sheet it opens closes. The slow halo
/// pulse draws the eye without alarming; it stops under reduced motion.
class EmergencyButton extends StatefulWidget {
  const EmergencyButton({
    required this.onPressed,
    required this.semanticLabel,
    super.key,
  });

  final VoidCallback onPressed;

  /// Screen-reader label — patient-visible, so the caller resolves it from
  /// the content library.
  final String semanticLabel;

  @override
  State<EmergencyButton> createState() => _EmergencyButtonState();
}

class _EmergencyButtonState extends State<EmergencyButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _halo =
      AnimationController(vsync: this, duration: AppDur.halo);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _halo.stop();
    } else if (!_halo.isAnimating) {
      _halo.repeat();
    }
  }

  @override
  void dispose() {
    _halo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.semanticLabel,
      child: AnimatedBuilder(
        animation: _halo,
        builder: (context, child) {
          final t = Curves.easeOut.transform(_halo.value);
          return Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.emergency
                      .withValues(alpha: (1 - t) * 0.45),
                  spreadRadius: t * 14,
                ),
              ],
            ),
            child: child,
          );
        },
        child: Material(
          color: AppColors.emergency,
          shape: CircleBorder(
            side: BorderSide(
              color: AppColors.surface.withValues(alpha: 0.85),
              width: 3,
            ),
          ),
          child: InkWell(
            onTap: widget.onPressed,
            customBorder: const CircleBorder(),
            child: const SizedBox(
              width: AppHit.emergencyFab,
              height: AppHit.emergencyFab,
              child: Icon(
                Icons.warning_amber_rounded,
                color: AppColors.surface,
                size: 22,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
