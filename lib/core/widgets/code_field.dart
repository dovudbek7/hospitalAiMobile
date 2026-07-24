import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/tokens.dart';
import '../theme/typography.dart';

/// Enrolment code input (P2): 6 chars, uppercase alphanumeric, monospace,
/// 24pt, letter-spaced, centred, autocorrect off — all per spec.
class CodeField extends StatelessWidget {
  const CodeField({
    required this.controller,
    this.label,
    this.onChanged,
    super.key,
  });

  final TextEditingController controller;

  /// Caption label above the field (from the content library).
  final Widget? label;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          DefaultTextStyle.merge(style: AppText.eyebrow, child: label!),
          const SizedBox(height: AppSpace.s8),
        ],
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.cardAll,
            border: Border.all(color: AppColors.line),
            boxShadow: AppShadow.card,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpace.s16,
            vertical: AppSpace.s16,
          ),
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            textAlign: TextAlign.center,
            maxLength: 6,
            autocorrect: false,
            enableSuggestions: false,
            textCapitalization: TextCapitalization.characters,
            keyboardType: TextInputType.visiblePassword,
            style: AppText.code,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]')),
              _UpperCaseFormatter(),
            ],
            decoration: const InputDecoration(
              border: InputBorder.none,
              counterText: '',
              isCollapsed: true,
            ),
          ),
        ),
      ],
    );
  }
}

class _UpperCaseFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}
