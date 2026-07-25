// P1 · Language selection.
//
// THE ONLY FILE in the app permitted to hardcode patient-visible strings:
// the three language names, each written in its own script, because a
// patient who cannot read the current interface language must still be able
// to act. Allowlisted in tool/check_no_patient_literals.dart.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/session.dart';
import '../../core/providers.dart';
import '../../core/router/guards.dart';
import '../../core/telemetry/client_events.dart';
import '../../core/theme/tokens.dart';
import '../../core/theme/typography.dart';

class P1LanguageScreen extends ConsumerWidget {
  const P1LanguageScreen({super.key});

  static const _options = [
    ('UZ', 'Oʻzbekcha'),
    ('RU', 'Русский'),
    ('EN', 'English'),
  ];

  Future<void> _choose(BuildContext context, WidgetRef ref, String lang) async {
    final isChange = ref.read(sessionProvider).language != null;
    ref.read(languageProvider.notifier).set(lang);
    await ref.read(sessionProvider.notifier).setLanguage(lang);
    // language_selected fires exactly once per selection (spec P1).
    await ref.read(clientEventsProvider).languageSelected(
          language: lang,
          isChange: isChange,
        );
    if (context.mounted) context.go(Routes.code);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Device language may be READ for analytics later, but is NEVER
    // auto-selected — a wrong guess strands an elderly patient in an
    // interface they cannot read (spec P1).
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.s24),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 92,
                      height: 92,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [AppColors.brand500, AppColors.brand700],
                        ),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.brand600.withValues(alpha: .4),
                            offset: const Offset(0, 16),
                            blurRadius: 36,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.favorite_rounded,
                        color: AppColors.surface,
                        size: 44,
                      ),
                    ),
                    const SizedBox(height: AppSpace.s24),
                    // The product name is a proper noun, not prose.
                    Text(
                      'Hospital AI',
                      style: AppText.display.copyWith(fontSize: 30),
                    ),
                    // Build-mode badge: makes it unmistakable whether this
                    // build talks to the real backend or the in-app demo.
                    if (Env.demoMode) ...[
                      const SizedBox(height: AppSpace.s8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpace.s12,
                          vertical: AppSpace.s4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.urgent.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(AppRadius.chip),
                          border: Border.all(color: AppColors.urgent),
                        ),
                        child: Text(
                          'DEMO — offline, any code works', // literal-ok: dev badge, not patient prose
                          style: AppText.caption.copyWith(
                            color: AppColors.urgent,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Column(
                children: [
                  for (final (code, label) in _options) ...[
                    _LanguageButton(
                      label: label,
                      onTap: () => _choose(context, ref, code),
                    ),
                    const SizedBox(height: AppSpace.s12),
                  ],
                ],
              ),
              const SizedBox(height: AppSpace.s24),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageButton extends StatelessWidget {
  const _LanguageButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // ≥64dp tap target (spec P1: 68).
    return Semantics(
      button: true,
      label: label,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: AppRadius.cardAll,
          boxShadow: AppShadow.card,
        ),
        child: Material(
          color: AppColors.surface,
          borderRadius: AppRadius.cardAll,
          child: InkWell(
            onTap: onTap,
            borderRadius: AppRadius.cardAll,
            child: Container(
              height: 68,
              padding: const EdgeInsets.symmetric(horizontal: AppSpace.s24),
              decoration: BoxDecoration(
                borderRadius: AppRadius.cardAll,
                border: Border.all(color: AppColors.line),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: AppText.h2.copyWith(fontSize: 19),
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.muted,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
