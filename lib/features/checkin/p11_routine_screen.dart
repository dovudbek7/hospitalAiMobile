// P11 · Submitted — ROUTINE. Acknowledgement ONLY.
//
// FORBIDDEN on this screen: "that sounds normal", "nothing to worry
// about", "your answers look fine" — any interpretation whatsoever. This
// is the screen most likely to tempt a well-meaning developer into adding
// reassurance. Don't. The body below is the server's approved copy or the
// resolved content key — never composed here.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/content/emergency_bundle.dart';
import '../../core/content/txt.dart';
import '../../core/router/guards.dart';
import '../../core/theme/tokens.dart';
import '../../core/theme/typography.dart';
import '../../core/util/dial.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/tier_chip.dart';
import 'checkin_providers.dart';
import 'result_body.dart';

class P11RoutineScreen extends ConsumerWidget {
  const P11RoutineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(checkinFlowProvider).result;

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
                      const TierChip(
                        tier: Tier.routine,
                        label: Txt('tier.routine'),
                      ),
                      const SizedBox(height: AppSpace.s16),
                      Txt(
                        'checkin.received.title',
                        style: AppText.display.copyWith(fontSize: 28),
                      ),
                      const SizedBox(height: AppSpace.s16),
                      CheckinResultBody(
                        result: result,
                        fallbackKey: 'checkin.submitted.routine',
                      ),
                      const SizedBox(height: AppSpace.s16),
                      const AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Txt(
                              'checkin.worsen_line',
                              style: AppText.bodyL,
                            ),
                            SizedBox(height: AppSpace.s12),
                            _ClinicCallButton(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              PrimaryButton(
                onPressed: () => context.go(Routes.today),
                child: const Txt('checkin.back_to_today'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ClinicCallButton extends StatelessWidget {
  const _ClinicCallButton();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<EmergencyBundle?>(
      future: EmergencyBundle.load(),
      builder: (context, snapshot) {
        final bundle = snapshot.data;
        if (bundle == null) return const SizedBox.shrink();
        return PrimaryButton(
          height: 56,
          background: AppColors.brand50,
          foreground: AppColors.brand700,
          onPressed: () => dial(bundle.clinicPhone),
          icon: const Icon(Icons.call_rounded),
          child: Text(bundle.clinicPhone), // number = data
        );
      },
    );
  }
}
