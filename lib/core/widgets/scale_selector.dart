import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/tokens.dart';
import '../theme/typography.dart';

/// The 0–10 scale (P10), as a horizontal spinner in the shape of the iOS
/// timer picker: the number under the centre capsule is the answer.
///
/// Why a wheel and not eleven buttons: eleven 56dp targets do not fit a
/// 360dp phone, so the old row scrolled sideways and cut "10" off screen
/// with no hint that more existed. A wheel has one target — the whole
/// strip — and each detent gives a selection tick (haptic + system click),
/// so the patient feels the value change without reading it.
///
/// It NEVER answers on the patient's behalf: until the wheel is actually
/// moved (or a number tapped) [onChanged] has not fired and the question
/// stays unanswered, however centred a number looks.
class ScaleSelector extends StatefulWidget {
  const ScaleSelector({
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 10,
    this.lowLabel,
    this.highLabel,
    this.hint,
    super.key,
  });

  final int? value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;
  final Widget? lowLabel;
  final Widget? highLabel;

  /// Shown while nothing is selected yet ("turn to choose").
  final Widget? hint;

  @override
  State<ScaleSelector> createState() => _ScaleSelectorState();
}

class _ScaleSelectorState extends State<ScaleSelector> {
  static const _itemExtent = 68.0;
  static const _height = 96.0;

  late final FixedExtentScrollController _controller;
  late int _centred;

  @override
  void initState() {
    super.initState();
    _centred = widget.value ?? widget.min;
    _controller = FixedExtentScrollController(
      initialItem: _centred - widget.min,
    );
  }

  @override
  void didUpdateWidget(ScaleSelector old) {
    super.didUpdateWidget(old);
    final v = widget.value;
    if (v != null && v != _centred) {
      _centred = v;
      if (_controller.hasClients) {
        _controller.animateToItem(
          v - widget.min,
          duration: AppDur.fast,
          curve: Curves.easeOut,
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSettled(int index) {
    final value = widget.min + index;
    if (value == _centred && widget.value != null) return;
    setState(() => _centred = value);
    // One tick per detent — the iOS picker's feel, on both platforms.
    HapticFeedback.selectionClick();
    SystemSound.play(SystemSoundType.click);
    widget.onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    final count = widget.max - widget.min + 1;
    final selected = widget.value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          slider: true,
          value: '$_centred',
          child: SizedBox(
            height: _height,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // The centre capsule the numbers pass under.
                IgnorePointer(
                  child: Container(
                    width: _itemExtent,
                    height: _height - AppSpace.s16,
                    decoration: BoxDecoration(
                      color: selected == null
                          ? AppColors.line.withValues(alpha: .45)
                          : AppColors.brand600,
                      borderRadius: AppRadius.buttonAll,
                      boxShadow: selected == null ? null : AppShadow.lift,
                    ),
                  ),
                ),
                RotatedBox(
                  quarterTurns: 3,
                  child: ListWheelScrollView.useDelegate(
                    controller: _controller,
                    itemExtent: _itemExtent,
                    diameterRatio: 2.2,
                    perspective: 0.003,
                    physics: const FixedExtentScrollPhysics(),
                    onSelectedItemChanged: _onSettled,
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: count,
                      builder: (context, index) {
                        final n = widget.min + index;
                        final isCentre = n == _centred;
                        return RotatedBox(
                          quarterTurns: 1,
                          child: Center(
                            child: Text(
                              '$n', // a number is data, not prose
                              style: AppText.display.copyWith(
                                fontSize: isCentre ? 30 : 24,
                                color: isCentre && selected != null
                                    ? AppColors.surface
                                    : AppColors.ink,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (widget.lowLabel != null || widget.highLabel != null) ...[
          const SizedBox(height: AppSpace.s8),
          DefaultTextStyle.merge(
            style: AppText.caption.copyWith(fontWeight: FontWeight.w500),
            child: Row(
              children: [
                Expanded(child: widget.lowLabel ?? const SizedBox.shrink()),
                const SizedBox(width: AppSpace.s12),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: DefaultTextStyle.merge(
                      textAlign: TextAlign.end,
                      child: widget.highLabel ?? const SizedBox.shrink(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        if (selected == null && widget.hint != null) ...[
          const SizedBox(height: AppSpace.s12),
          DefaultTextStyle.merge(
            style: AppText.caption,
            textAlign: TextAlign.center,
            child: Center(child: widget.hint!),
          ),
        ],
      ],
    );
  }
}
