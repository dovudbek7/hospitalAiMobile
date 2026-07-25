// P3 · Phone number. Captures the 9-digit national number; the code+phone
// PAIR is validated together at P4 Agree (there is a single session
// endpoint, so validating = enrolling — deferred to the consent step so
// Back stays lossless and no session exists before consent).

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/content/txt.dart';
import '../../core/router/guards.dart';
import '../../core/theme/tokens.dart';
import '../../core/theme/typography.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/primary_button.dart';
import 'enrolment_form.dart';
import 'onboarding_header.dart';

class P3PhoneScreen extends ConsumerStatefulWidget {
  const P3PhoneScreen({super.key});

  @override
  ConsumerState<P3PhoneScreen> createState() => _P3PhoneScreenState();
}

class _P3PhoneScreenState extends ConsumerState<P3PhoneScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: _pretty(ref.read(enrolmentFormProvider).phone),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  static String _pretty(String digits) {
    final d = digits.replaceAll(RegExp(r'\D'), '');
    final parts = [
      d.substring(0, d.length.clamp(0, 2)),
      if (d.length > 2) d.substring(2, d.length.clamp(2, 5)),
      if (d.length > 5) d.substring(5, d.length.clamp(5, 7)),
      if (d.length > 7) d.substring(7, d.length.clamp(7, 9)),
    ];
    return parts.where((p) => p.isNotEmpty).join(' ');
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
                step: 2,
                // The draft keeps the typed code, so going back is lossless.
                onBack: () => context.go(Routes.code),
              ),
              const SizedBox(height: AppSpace.s24),
              Txt(
                'onboarding.phone.title',
                style: AppText.display.copyWith(fontSize: 30),
              ),
              const SizedBox(height: AppSpace.s8),
              Txt(
                'onboarding.phone.help',
                style: AppText.bodyL.copyWith(color: AppColors.muted),
              ),
              const SizedBox(height: AppSpace.s32),
              AppTextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(12),
                ],
                // +998 visible but NOT editable (spec P3).
                prefix: const FieldPrefix(child: Text('+998')), // literal-ok: country code is data
                onChanged: (v) {
                  ref.read(enrolmentFormProvider.notifier).setPhone(v);
                  final pretty = _pretty(v);
                  if (pretty != v) {
                    _controller.value = TextEditingValue(
                      text: pretty,
                      selection:
                          TextSelection.collapsed(offset: pretty.length),
                    );
                  }
                },
              ),
              const SizedBox(height: AppSpace.s24),
              PrimaryButton(
                onPressed: form.phoneComplete
                    ? () => context.go(Routes.consent)
                    : null,
                child: const Txt('common.continue'),
              ),
              const SizedBox(height: AppSpace.s24),
              Container(
                padding: const EdgeInsets.all(AppSpace.s16),
                decoration: BoxDecoration(
                  color: AppColors.brand50,
                  borderRadius: AppRadius.cardAll,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.lock_outline_rounded,
                      color: AppColors.brand700,
                    ),
                    const SizedBox(width: AppSpace.s12),
                    Expanded(
                      child: Txt(
                        'onboarding.phone.help',
                        style:
                            AppText.caption.copyWith(color: AppColors.muted),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
