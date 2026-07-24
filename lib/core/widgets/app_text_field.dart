import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/tokens.dart';
import '../theme/typography.dart';

/// Standard input: 64dp, white card, brand focus ring. Labels/hints are
/// patient-visible and therefore arrive as widgets from the content library.
class AppTextField extends StatelessWidget {
  const AppTextField({
    this.controller,
    this.label,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
    this.prefix,
    this.textStyle,
    this.textAlign = TextAlign.start,
    this.autofocus = false,
    super.key,
  });

  final TextEditingController? controller;

  /// Caption label rendered above the field (from the content library).
  final Widget? label;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final Widget? prefix;
  final TextStyle? textStyle;
  final TextAlign textAlign;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          DefaultTextStyle.merge(style: AppText.eyebrow, child: label!),
          const SizedBox(height: AppSpace.s8),
        ],
        Row(
          children: [
            if (prefix != null) ...[
              prefix!,
              const SizedBox(width: AppSpace.s12),
            ],
            Expanded(
              child: Container(
                height: AppHit.key,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: AppRadius.buttonAll,
                  border: Border.all(color: AppColors.line),
                  boxShadow: AppShadow.card,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpace.s16),
                alignment: Alignment.center,
                child: TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  inputFormatters: inputFormatters,
                  onChanged: onChanged,
                  autofocus: autofocus,
                  textAlign: textAlign,
                  style: textStyle ??
                      AppText.bodyL.copyWith(fontWeight: FontWeight.w600),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isCollapsed: true,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Non-editable prefix block (the fixed `+998` on P3).
class FieldPrefix extends StatelessWidget {
  const FieldPrefix({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 92,
      height: AppHit.key,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.line.withValues(alpha: 0.7),
        borderRadius: AppRadius.buttonAll,
      ),
      child: DefaultTextStyle.merge(
        style: AppText.bodyL.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.muted,
        ),
        child: child,
      ),
    );
  }
}
