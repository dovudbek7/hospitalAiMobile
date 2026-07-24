// P12 · Submitted — URGENT. The body is verbatim approved copy (the server
// picks checkin.submitted.urgent or .out_of_hours via withinClinicHours).
// Clinic name/phone are injected from config, never hardcoded.
//
// NO RESPONSE-TIME PROMISE APPEARS ANYWHERE ON THIS SCREEN. The SLA is an
// internal target; an unmet promise is worse than none.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/content/emergency_bundle.dart';
import '../../core/content/txt.dart';
import '../../core/router/guards.dart';
import '../../core/theme/tokens.dart';
import '../../core/theme/typography.dart';
import '../../core/util/dial.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/secondary_button.dart';
import '../../core/widgets/tier_chip.dart';
import 'checkin_providers.dart';
import 'result_body.dart';

class P12UrgentScreen extends ConsumerWidget {
  const P12UrgentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(checkinFlowProvider).result;
    final outOfHours = result?.withinClinicHours == false;

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpace.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const TierChip(
                            tier: Tier.urgent,
                            label: Txt('tier.urgent'),
                          ),
                          if (outOfHours) ...[
                            const SizedBox(width: AppSpace.s8),
                            const TierChip(
                              tier: Tier.urgent,
                              label: Txt('tier.clinic_closed'),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: AppSpace.s16),
                      Txt(
                        'checkin.sent.title',
                        style: AppText.display.copyWith(fontSize: 28),
                      ),
                      const SizedBox(height: AppSpace.s16),
                      CheckinResultBody(
                        result: result,
                        fallbackKey: outOfHours
                            ? 'checkin.submitted.out_of_hours'
                            : 'checkin.submitted.urgent',
                      ),
                    ],
                  ),
                ),
              ),
              FutureBuilder<EmergencyBundle?>(
                future: EmergencyBundle.load(),
                builder: (context, snapshot) {
                  final bundle = snapshot.data;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PrimaryButton(
                        onPressed: bundle == null
                            ? null
                            : () => dial(bundle.clinicPhone),
                        icon: const Icon(Icons.call_rounded),
                        child: const Txt('emergency.call_clinic'),
                      ),
                      const SizedBox(height: AppSpace.s12),
                      PrimaryButton(
                        onPressed: () =>
                            dial(bundle?.ambulanceNumber ?? '103'),
                        icon: const Icon(Icons.call_rounded),
                        child: const Txt('emergency.call_103'),
                      ),
                      const SizedBox(height: AppSpace.s12),
                      SecondaryButton(
                        height: 56,
                        onPressed: () => context.go(Routes.today),
                        child: const Txt('checkin.back_to_today'),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
