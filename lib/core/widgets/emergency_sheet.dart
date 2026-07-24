import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import '../theme/typography.dart';
import 'app_sheet.dart';
import 'primary_button.dart';

/// The expanded emergency sheet: the full verbatim instruction plus both
/// dial actions. All patient-visible widgets ([title], [instruction],
/// [callAmbulanceLabel], [callClinicLabel], [hoursLine]) are resolved from
/// the content library by the caller — nothing here is hardcoded.
///
/// The 103 call button is [AppHit.emergencyCall] (68dp) tall, full width.
class EmergencySheet extends StatelessWidget {
  const EmergencySheet({
    required this.title,
    required this.instruction,
    required this.callAmbulanceLabel,
    required this.callClinicLabel,
    required this.onCallAmbulance,
    required this.onCallClinic,
    this.hoursLine,
    super.key,
  });

  final Widget title;
  final Widget instruction;
  final Widget callAmbulanceLabel;
  final Widget callClinicLabel;
  final VoidCallback onCallAmbulance;
  final VoidCallback onCallClinic;
  final Widget? hoursLine;

  static Future<void> show(
    BuildContext context, {
    required Widget title,
    required Widget instruction,
    required Widget callAmbulanceLabel,
    required Widget callClinicLabel,
    required VoidCallback onCallAmbulance,
    required VoidCallback onCallClinic,
    Widget? hoursLine,
  }) {
    return showAppSheet(
      context: context,
      builder: (context) => EmergencySheet(
        title: title,
        instruction: instruction,
        callAmbulanceLabel: callAmbulanceLabel,
        callClinicLabel: callClinicLabel,
        onCallAmbulance: onCallAmbulance,
        onCallClinic: onCallClinic,
        hoursLine: hoursLine,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SheetItem(
            index: 0,
            child: Row(
              children: [
                Container(
                  width: AppSpace.s48,
                  height: AppSpace.s48,
                  decoration: BoxDecoration(
                    color: AppColors.emergency,
                    borderRadius: AppRadius.tileAll,
                  ),
                  child: const Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.surface,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppSpace.s12),
                Expanded(
                  child: DefaultTextStyle.merge(
                    style: AppText.h1,
                    child: title,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                  color: AppColors.muted,
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.canvas,
                    minimumSize: const Size(40, 40),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpace.s16),
          SheetItem(
            index: 1,
            child: DefaultTextStyle.merge(
              style: AppText.bodyL,
              child: instruction,
            ),
          ),
          const SizedBox(height: AppSpace.s24),
          SheetItem(
            index: 2,
            child: PrimaryButton(
              height: AppHit.emergencyCall,
              background: AppColors.emergency,
              onPressed: onCallAmbulance,
              icon: const Icon(Icons.call_rounded),
              child: DefaultTextStyle.merge(
                style: AppText.button.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
                child: callAmbulanceLabel,
              ),
            ),
          ),
          const SizedBox(height: AppSpace.s12),
          SheetItem(
            index: 3,
            child: PrimaryButton(
              height: 60,
              background: AppColors.canvas,
              foreground: AppColors.ink,
              onPressed: onCallClinic,
              icon: const Icon(Icons.call_rounded),
              child: callClinicLabel,
            ),
          ),
          if (hoursLine != null) ...[
            const SizedBox(height: AppSpace.s16),
            SheetItem(
              index: 4,
              child: Center(
                child: DefaultTextStyle.merge(
                  style: AppText.caption,
                  child: hoursLine!,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
