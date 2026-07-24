import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import '../theme/typography.dart';
import 'app_card.dart';
import 'primary_button.dart';

/// Rendered when content is unapproved or missing (`CONTENT_NOT_APPROVED`).
/// Golden rule 3: fail closed — nothing else renders, no language fallback.
/// [title]/[body]/[callLabel] are patient-visible and must themselves come
/// from cached, approved content (or the enrolment-time emergency bundle).
class FailClosedPanel extends StatelessWidget {
  const FailClosedPanel({
    required this.title,
    required this.body,
    required this.callLabel,
    required this.onCallClinic,
    this.diagnosticCode,
    super.key,
  });

  final Widget title;
  final Widget body;
  final Widget callLabel;
  final VoidCallback onCallClinic;

  /// Machine code shown small for support (e.g. CONTENT_NOT_APPROVED). A
  /// diagnostic, not prose — never the API's `message` field.
  final String? diagnosticCode;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpace.s24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: AppSpace.s64,
              height: AppSpace.s64,
              decoration: const BoxDecoration(
                color: AppColors.brand50,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_outline_rounded,
                color: AppColors.brand700,
                size: 30,
              ),
            ),
          ),
          const SizedBox(height: AppSpace.s16),
          DefaultTextStyle.merge(
            style: AppText.h2.copyWith(fontSize: 19),
            textAlign: TextAlign.center,
            child: title,
          ),
          const SizedBox(height: AppSpace.s8),
          DefaultTextStyle.merge(
            style: AppText.body.copyWith(color: AppColors.muted),
            textAlign: TextAlign.center,
            child: body,
          ),
          const SizedBox(height: AppSpace.s16),
          PrimaryButton(
            height: 56,
            background: AppColors.brand50,
            foreground: AppColors.brand700,
            onPressed: onCallClinic,
            icon: const Icon(Icons.call_rounded),
            child: callLabel,
          ),
          if (diagnosticCode != null) ...[
            const SizedBox(height: AppSpace.s12),
            Center(
              child: Text(
                diagnosticCode!,
                style: AppText.caption.copyWith(
                  fontFamily: AppText.monoFamily,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
