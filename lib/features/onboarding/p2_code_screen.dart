// P2 · Enrolment code entry. Works offline up to the point of submission
// (validation happens with the phone on P3 — the pair is checked together).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/content/emergency_bundle.dart';
import '../../core/content/txt.dart';
import '../../core/router/guards.dart';
import '../../core/theme/tokens.dart';
import '../../core/theme/typography.dart';
import '../../core/util/dial.dart';
import '../../core/widgets/code_field.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/secondary_button.dart';
import 'enrolment_form.dart';
import 'onboarding_header.dart';

class P2CodeScreen extends ConsumerStatefulWidget {
  const P2CodeScreen({super.key});

  @override
  ConsumerState<P2CodeScreen> createState() => _P2CodeScreenState();
}

class _P2CodeScreenState extends ConsumerState<P2CodeScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        TextEditingController(text: ref.read(enrolmentFormProvider).code);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(enrolmentFormProvider);

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpace.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              OnboardingHeader(
                step: 1,
                onBack: () => context.go(Routes.language),
              ),
              const SizedBox(height: AppSpace.s24),
              Txt(
                'onboarding.code.title',
                style: AppText.display.copyWith(fontSize: 30),
              ),
              const SizedBox(height: AppSpace.s8),
              Txt(
                'onboarding.code.help',
                style: AppText.bodyL.copyWith(color: AppColors.muted),
              ),
              const SizedBox(height: AppSpace.s32),
              CodeField(
                controller: _controller,
                onChanged: (v) =>
                    ref.read(enrolmentFormProvider.notifier).setCode(v),
              ),
              const SizedBox(height: AppSpace.s24),
              PrimaryButton(
                onPressed:
                    form.codeComplete ? () => context.go(Routes.phone) : null,
                child: const Txt('common.continue'),
              ),
              const SizedBox(height: AppSpace.s32),
              Center(
                child: Txt(
                  'onboarding.code.no_code',
                  style: AppText.body.copyWith(color: AppColors.muted),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppSpace.s8),
              const Center(child: _ClinicPhoneLink()),
            ],
          ),
        ),
      ),
    );
  }
}

/// Pre-enrolment the app has no clinic config. A previous enrolment's
/// emergency bundle may still carry the number (re-enrol case); otherwise
/// only the help text shows — nothing is invented.
class _ClinicPhoneLink extends StatelessWidget {
  const _ClinicPhoneLink();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<EmergencyBundle?>(
      future: EmergencyBundle.load(),
      builder: (context, snapshot) {
        final phone = snapshot.data?.clinicPhone;
        if (phone == null) return const SizedBox.shrink();
        return SecondaryButton(
          height: 56,
          onPressed: () => dial(phone),
          icon: const Icon(Icons.call_rounded),
          child: Text(
            phone, // a phone number is data, not prose
            style: AppText.button.copyWith(color: AppColors.brand700),
          ),
        );
      },
    );
  }
}
