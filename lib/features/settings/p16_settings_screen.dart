// P16 · Settings. Language applies INSTANTLY across the app, no restart.
// Leaving requires explicit confirmation and notifies the clinic;
// withdrawal stops the programme but never deletes data.

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/auth/session.dart';
import '../../core/content/emergency_bundle.dart';
import '../../core/content/txt.dart';
import '../../core/providers.dart';
import '../../core/telemetry/client_events.dart';
import '../../core/theme/text_size.dart';
import '../../core/theme/tokens.dart';
import '../../core/theme/typography.dart';
import '../../core/util/dial.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_sheet.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/misc.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/secondary_button.dart';
import '../onboarding/data/auth_repository.dart';

class P16SettingsScreen extends ConsumerWidget {
  const P16SettingsScreen({super.key});

  static const _languages = [
    // The names themselves are the P1-permitted hardcoded set; reusing the
    // identical three strings here keeps the switcher usable by a patient
    // stranded in the wrong language.
    ('UZ', 'Oʻzbekcha'),
    ('RU', 'Русский'),
    ('EN', 'English'),
  ];

  Future<void> _setLanguage(WidgetRef ref, String lang) async {
    final wasLang = ref.read(languageProvider);
    if (wasLang == lang) return;
    // Instant re-render: every Txt watches languageProvider.
    ref.read(languageProvider.notifier).set(lang);
    await ref.read(sessionProvider.notifier).setLanguage(lang);
    await ref.read(clientEventsProvider).languageSelected(
          language: lang,
          isChange: true,
        );
    // Server-side persistence + emergency bundle in the new language.
    try {
      await ref.read(patientApiProvider).setLanguage(lang);
      final bundle = await EmergencyBundle.load();
      if (bundle != null) {
        await EmergencyBundle.refresh(
          content: ref.read(contentRepositoryProvider),
          language: lang,
          clinicName: bundle.clinicName,
          clinicPhone: bundle.clinicPhone,
          ambulanceNumber: bundle.ambulanceNumber,
        );
      }
    } on Exception {
      // Offline: the local switch already applied; server syncs later
      // via bootstrapProfile on next launch.
    }
  }

  Future<void> _leave(BuildContext context, WidgetRef ref) async {
    final confirmed = await showAppSheet<bool>(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Txt('settings.leave_confirm', style: AppText.bodyL),
          const SizedBox(height: AppSpace.s24),
          PrimaryButton(
            background: AppColors.canvas,
            foreground: AppColors.ink,
            onPressed: () => Navigator.of(context).pop(true),
            child: const Txt('settings.leave'),
          ),
          const SizedBox(height: AppSpace.s12),
          SecondaryButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Txt('checkin.back'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      // Server first — the clinic must be told; data is retained.
      await ref.read(authRepositoryProvider).leave();
      // The router guard now sends the patient back to enrolment.
    } on Exception {
      // Leaving REQUIRES the server (the clinic must know). Do nothing
      // silently; the patient can retry online.
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLang = ref.watch(languageProvider);
    final vars = ref.watch(interpolationVarsProvider);

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpace.s16,
            AppSpace.s24,
            AppSpace.s16,
            120,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 56),
              child: Txt(
                'nav.settings',
                style: AppText.display.copyWith(fontSize: 30),
              ),
            ),
            const SizedBox(height: AppSpace.s16),

            // Cover statement — prominent, gradient card (spec P16).
            BrandGradient(
              borderRadius: BorderRadius.circular(AppRadius.card),
              padding: const EdgeInsets.all(AppSpace.s16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.surface,
                  ),
                  const SizedBox(width: AppSpace.s12),
                  Expanded(
                    child: Txt(
                      'settings.cover_hours',
                      style: AppText.body.copyWith(color: AppColors.surface),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpace.s24),
            const Eyebrow(child: Txt('settings.language')),
            const SizedBox(height: AppSpace.s12),
            for (final (code, label) in _languages) ...[
              _LanguageRow(
                label: label,
                selected: code == currentLang,
                onTap: () => _setLanguage(ref, code),
              ),
              const SizedBox(height: AppSpace.s8),
            ],

            const SizedBox(height: AppSpace.s24),
            const Eyebrow(child: Txt('settings.text_size')),
            const SizedBox(height: AppSpace.s12),
            const _TextSizeRow(),

            const SizedBox(height: AppSpace.s24),
            const Eyebrow(child: Txt('settings.your_clinic')),
            const SizedBox(height: AppSpace.s12),
            const _ClinicCard(),

            const SizedBox(height: AppSpace.s24),
            const Eyebrow(child: Txt('settings.notifications')),
            const SizedBox(height: AppSpace.s12),
            AppCard(
              onTap: () => AppSettings.openAppSettings(
                type: AppSettingsType.notification,
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.notifications_none_rounded,
                    color: AppColors.brand700,
                  ),
                  SizedBox(width: AppSpace.s12),
                  Expanded(
                    child: Txt('settings.reminder_settings',
                        style: AppText.bodyL),
                  ),
                  Icon(Icons.chevron_right_rounded, color: AppColors.muted),
                ],
              ),
            ),

            const SizedBox(height: AppSpace.s24),
            const Eyebrow(child: Txt('settings.programme')),
            const SizedBox(height: AppSpace.s12),
            AppCard(
              child: Column(
                children: [
                  _ProgrammeRow(
                    label: const Txt('settings.today_row'),
                    value: Txt(
                      'today.title',
                      vars: {'N': vars['N'] ?? ''},
                      style:
                          AppText.body.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpace.s32),
            SecondaryButton(
              height: 58,
              foreground: AppColors.muted,
              onPressed: () => _leave(context, ref),
              icon: const Icon(Icons.logout_rounded),
              child: const Txt('settings.leave'),
            ),
            const SizedBox(height: AppSpace.s16),
            const Center(child: _VersionLine()),
          ],
        ),
      ),
    );
  }
}

/// Three sizes, Medium default, Large for older eyes. The preview letter in
/// each tile is drawn at that tile's own factor, so the choice is visible
/// before it is made.
class _TextSizeRow extends ConsumerWidget {
  const _TextSizeRow();

  static const _labelKeys = {
    TextSizeChoice.small: 'settings.text_size.small',
    TextSizeChoice.medium: 'settings.text_size.medium',
    TextSizeChoice.large: 'settings.text_size.large',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(textSizeProvider);

    return Row(
      children: [
        for (final choice in TextSizeChoice.values) ...[
          if (choice != TextSizeChoice.values.first)
            const SizedBox(width: AppSpace.s8),
          Expanded(
            child: Semantics(
              button: true,
              selected: choice == current,
              child: Material(
                color: choice == current
                    ? AppColors.brand50
                    : AppColors.surface,
                borderRadius: AppRadius.cardAll,
                child: InkWell(
                  onTap: () => ref.read(textSizeProvider.notifier).set(choice),
                  borderRadius: AppRadius.cardAll,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpace.s12,
                      horizontal: AppSpace.s8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: AppRadius.cardAll,
                      border: Border.all(
                        color: choice == current
                            ? AppColors.brand600
                            : AppColors.line,
                        width: choice == current ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'A', // literal-ok: a type specimen, not prose
                          style: AppText.display.copyWith(
                            fontSize: 20 * choice.factor,
                            color: choice == current
                                ? AppColors.brand700
                                : AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: AppSpace.s4),
                        Txt(
                          _labelKeys[choice]!,
                          style: AppText.caption.copyWith(
                            fontWeight: FontWeight.w600,
                            color: choice == current
                                ? AppColors.brand700
                                : AppColors.muted,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _LanguageRow extends StatelessWidget {
  const _LanguageRow({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected ? AppColors.brand50 : AppColors.surface,
        borderRadius: AppRadius.cardAll,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.cardAll,
          child: Container(
            constraints: const BoxConstraints(minHeight: 60),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpace.s16,
              vertical: AppSpace.s12,
            ),
            decoration: BoxDecoration(
              borderRadius: AppRadius.cardAll,
              border: Border.all(
                color: selected ? AppColors.brand600 : AppColors.line,
                width: selected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.language_rounded,
                  color: selected ? AppColors.brand700 : AppColors.muted,
                ),
                const SizedBox(width: AppSpace.s12),
                Expanded(
                  child: Text(
                    label,
                    style:
                        AppText.bodyL.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                if (selected)
                  const Icon(
                    Icons.check_rounded,
                    color: AppColors.brand700,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ClinicCard extends StatelessWidget {
  const _ClinicCard();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<EmergencyBundle?>(
      future: EmergencyBundle.load(),
      builder: (context, snapshot) {
        final bundle = snapshot.data;
        return AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                bundle?.clinicName ?? '',
                style: AppText.h2.copyWith(fontSize: 19),
              ),
              const SizedBox(height: AppSpace.s4),
              const Txt('emergency.hours_line', style: AppText.caption),
              const SizedBox(height: AppSpace.s12),
              PrimaryButton(
                height: 56,
                onPressed: bundle == null
                    ? null
                    : () => dial(bundle.clinicPhone),
                icon: const Icon(Icons.call_rounded),
                child: Text(bundle?.clinicPhone ?? ''),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProgrammeRow extends StatelessWidget {
  const _ProgrammeRow({required this.label, required this.value});

  final Widget label;
  final Widget value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpace.s4),
      child: Row(
        children: [
          Expanded(
            child: DefaultTextStyle.merge(
              style: AppText.body.copyWith(color: AppColors.muted),
              child: label,
            ),
          ),
          const SizedBox(width: AppSpace.s12),
          Flexible(
            child: DefaultTextStyle.merge(
              textAlign: TextAlign.end,
              style: AppText.body,
              child: value,
            ),
          ),
        ],
      ),
    );
  }
}

class _VersionLine extends StatelessWidget {
  const _VersionLine();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        final info = snapshot.data;
        if (info == null) return const SizedBox.shrink();
        return Text(
          '${info.appName} ${info.version}+${info.buildNumber}',
          style: AppText.caption.copyWith(fontSize: 12),
        );
      },
    );
  }
}
