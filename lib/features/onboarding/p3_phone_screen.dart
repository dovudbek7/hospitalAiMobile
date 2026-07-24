// P3 · Phone number. Submits the code+phone PAIR. The error path reveals
// nothing: not whether the code exists, not what number is stored, not
// which half failed. Lockout after 3 attempts is enforced server-side.

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
import 'data/auth_repository.dart';
import 'enrolment_form.dart';

class P3PhoneScreen extends ConsumerStatefulWidget {
  const P3PhoneScreen({super.key});

  @override
  ConsumerState<P3PhoneScreen> createState() => _P3PhoneScreenState();
}

class _P3PhoneScreenState extends ConsumerState<P3PhoneScreen> {
  late final TextEditingController _controller;
  bool _submitting = false;
  bool _failed = false;
  bool _offline = false;

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

  Future<void> _submit() async {
    final form = ref.read(enrolmentFormProvider);
    setState(() {
      _submitting = true;
      _failed = false;
      _offline = false;
    });
    try {
      await ref.read(authRepositoryProvider).enrol(
            code: form.code,
            phone: '+998${form.phone}',
          );
      await ref.read(enrolmentFormProvider.notifier).clearDraft();
      if (mounted) context.go(Routes.consent);
    } on Exception catch (e) {
      // NetworkUnavailable → clear retry message, KEEP the typed values.
      // Anything else → the generic mismatch copy; nothing is revealed.
      final offline = e.toString().contains('NetworkUnavailable');
      if (mounted) {
        setState(() {
          _failed = !offline;
          _offline = offline;
        });
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
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
              if (_failed) ...[
                const SizedBox(height: AppSpace.s12),
                Txt(
                  'onboarding.phone.error',
                  style: AppText.body.copyWith(color: AppColors.emergency),
                ),
              ],
              if (_offline) ...[
                const SizedBox(height: AppSpace.s12),
                Txt(
                  'offline.indicator',
                  style: AppText.body.copyWith(color: AppColors.brand800),
                ),
              ],
              const SizedBox(height: AppSpace.s24),
              PrimaryButton(
                onPressed:
                    form.phoneComplete && !_submitting ? _submit : null,
                child: _submitting
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: AppColors.surface,
                        ),
                      )
                    : const Txt('common.continue'),
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
