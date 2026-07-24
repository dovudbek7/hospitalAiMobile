// P4 · Consent — legally load-bearing.
//
//  - Checkbox unticked by default; no pre-ticking, ever.
//  - Agree stays disabled until the text is scrolled to the END and the
//    box is ticked. Neither alone is enough.
//  - Decline records nothing and wipes local traces.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/content/txt.dart';
import '../../core/router/guards.dart';
import '../../core/theme/tokens.dart';
import '../../core/theme/typography.dart';
import '../../core/widgets/app_sheet.dart';
import '../../core/widgets/primary_button.dart';
import 'data/auth_repository.dart';

/// The consent document version the patient accepts (server example: "v1").
/// Stored server-side with the acceptance timestamp.
const consentVersion = 'v1';

class P4ConsentScreen extends ConsumerStatefulWidget {
  const P4ConsentScreen({super.key});

  @override
  ConsumerState<P4ConsentScreen> createState() => _P4ConsentScreenState();
}

class _P4ConsentScreenState extends ConsumerState<P4ConsentScreen> {
  final _scroll = ScrollController();
  bool _scrolledToEnd = false;
  bool _checked = false;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
    // A short consent text may not be scrollable at all — that counts as
    // "read to the end".
    WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
  }

  void _onScroll() {
    if (!_scroll.hasClients) return;
    final atEnd =
        _scroll.position.pixels >= _scroll.position.maxScrollExtent - 8;
    if (atEnd && !_scrolledToEnd) setState(() => _scrolledToEnd = true);
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  bool get _canAgree => _scrolledToEnd && _checked && !_submitting;

  Future<void> _agree() async {
    setState(() => _submitting = true);
    try {
      await ref
          .read(authRepositoryProvider)
          .consentAndBootstrap(version: consentVersion);
      if (mounted) context.go(Routes.welcome);
    } on Exception {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _decline() async {
    // Exit with the clinic-contact message, then wipe. Zero personal data
    // is written by this path.
    await showAppSheet<void>(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Txt('contact.body', style: AppText.bodyL),
          const SizedBox(height: AppSpace.s24),
          PrimaryButton(
            height: 56,
            onPressed: () => Navigator.of(context).pop(),
            child: const Txt('onboarding.consent.decline'),
          ),
        ],
      ),
    );
    await ref.read(authRepositoryProvider).decline();
    // The router guard takes over: session is gone → back to enrolment.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpace.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Txt(
                'onboarding.consent.title',
                style: AppText.display.copyWith(fontSize: 30),
              ),
              const SizedBox(height: AppSpace.s16),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: AppRadius.cardAll,
                    border: Border.all(color: AppColors.line),
                    boxShadow: AppShadow.card,
                  ),
                  child: ListView(
                    controller: _scroll,
                    padding: const EdgeInsets.all(AppSpace.s16),
                    children: const [
                      Txt('onboarding.consent.body', style: AppText.body),
                      SizedBox(height: AppSpace.s16),
                      Txt('onboarding.consent.collect', style: AppText.body),
                      SizedBox(height: AppSpace.s12),
                      Txt('onboarding.consent.who', style: AppText.body),
                      SizedBox(height: AppSpace.s12),
                      Txt('onboarding.consent.howlong', style: AppText.body),
                      SizedBox(height: AppSpace.s12),
                      Txt('onboarding.consent.choice', style: AppText.body),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpace.s8),
              if (!_scrolledToEnd)
                const Center(
                  child: Txt(
                    'onboarding.consent.scroll_hint',
                    style: AppText.caption,
                  ),
                ),
              const SizedBox(height: AppSpace.s8),
              _ConsentCheckbox(
                checked: _checked,
                onChanged: (v) => setState(() => _checked = v),
              ),
              const SizedBox(height: AppSpace.s16),
              PrimaryButton(
                onPressed: _canAgree ? _agree : null,
                child: const Txt('onboarding.consent.agree'),
              ),
              const SizedBox(height: AppSpace.s8),
              TextButton(
                onPressed: _submitting ? null : _decline,
                child: Txt(
                  'onboarding.consent.decline',
                  style: AppText.button.copyWith(color: AppColors.muted),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConsentCheckbox extends StatelessWidget {
  const _ConsentCheckbox({required this.checked, required this.onChanged});

  final bool checked;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      checked: checked,
      child: Material(
        color: AppColors.surface,
        borderRadius: AppRadius.cardAll,
        child: InkWell(
          onTap: () => onChanged(!checked),
          borderRadius: AppRadius.cardAll,
          child: Container(
            padding: const EdgeInsets.all(AppSpace.s16),
            decoration: BoxDecoration(
              borderRadius: AppRadius.cardAll,
              border: Border.all(color: AppColors.line),
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: AppDur.fast,
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: checked ? AppColors.brand600 : AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: checked
                        ? null
                        : Border.all(color: AppColors.line, width: 2),
                  ),
                  child: checked
                      ? const Icon(
                          Icons.check_rounded,
                          size: 20,
                          color: AppColors.surface,
                        )
                      : null,
                ),
                const SizedBox(width: AppSpace.s12),
                const Expanded(
                  child: Txt(
                    'onboarding.consent.checkbox',
                    style: AppText.bodyL,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
