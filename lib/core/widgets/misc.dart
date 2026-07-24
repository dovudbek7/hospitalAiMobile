import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import '../theme/typography.dart';

/// Discreet offline strip (never a blocking error). [label] comes from the
/// content library (`offline.indicator`).
class OfflineStrip extends StatelessWidget {
  const OfflineStrip({required this.label, super.key});

  final Widget label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.brand50,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpace.s16,
        vertical: AppSpace.s8,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.wifi_off_rounded,
            size: 16,
            color: AppColors.brand800,
          ),
          const SizedBox(width: AppSpace.s8),
          Expanded(
            child: DefaultTextStyle.merge(
              style: AppText.caption.copyWith(
                color: AppColors.brand800,
                fontWeight: FontWeight.w600,
              ),
              child: label,
            ),
          ),
        ],
      ),
    );
  }
}

/// Circular progress ring (day X of 30 in the P6 hero).
class ProgressRing extends StatelessWidget {
  const ProgressRing({
    required this.progress,
    required this.child,
    this.size = 66,
    this.stroke = 7,
    this.trackColor,
    this.color = AppColors.surface,
    super.key,
  });

  final double progress;
  final Widget child;
  final double size;
  final double stroke;
  final Color? trackColor;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size.square(size),
            painter: _RingPainter(
              progress: progress.clamp(0, 1),
              stroke: stroke,
              track: trackColor ?? color.withValues(alpha: 0.28),
              color: color,
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.progress,
    required this.stroke,
    required this.track,
    required this.color,
  });

  final double progress;
  final double stroke;
  final Color track;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final inset = rect.deflate(stroke / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(inset, 0, math.pi * 2, false, paint..color = track);
    canvas.drawArc(
      inset,
      -math.pi / 2,
      math.pi * 2 * progress,
      false,
      paint..color = color,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.color != color;
}

/// The 30-day programme grid (P9). Pure data-in, no text.
class DayGrid extends StatelessWidget {
  const DayGrid({
    required this.totalDays,
    required this.currentDay,
    super.key,
  });

  final int totalDays;
  final int currentDay;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const columns = 10;
        const gap = 6.0;
        final cell =
            (constraints.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (var d = 1; d <= totalDays; d++)
              Container(
                width: cell,
                height: cell,
                decoration: BoxDecoration(
                  color: d < currentDay
                      ? AppColors.success
                      : d == currentDay
                          ? AppColors.brand100
                          : AppColors.line.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(8),
                  border: d == currentDay
                      ? Border.all(color: AppColors.brand600, width: 2)
                      : null,
                ),
              ),
          ],
        );
      },
    );
  }
}

/// Uppercase tracking section label ("TODAY'S PLAN").
class Eyebrow extends StatelessWidget {
  const Eyebrow({required this.child, this.color, super.key});

  final Widget child;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: AppText.eyebrow.copyWith(color: color ?? AppColors.muted),
      child: child,
    );
  }
}
