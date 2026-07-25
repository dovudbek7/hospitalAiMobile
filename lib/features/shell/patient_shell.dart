import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/content/emergency_bundle.dart';
import '../../core/content/txt.dart';
import '../../core/providers.dart';
import '../../core/router/guards.dart';
import '../../core/theme/tokens.dart';
import '../../core/util/dial.dart';
import '../../core/widgets/bottom_nav.dart';
import '../../core/widgets/emergency_button.dart';
import '../../core/widgets/emergency_sheet.dart';

/// The main app chrome: bottom navigation + the persistent emergency
/// affordance. The emergency button is on EVERY shell screen, never
/// dismissible; its sheet carries the verbatim approved instruction and
/// both dial actions (ratified deviation from the 44dp banner).
class PatientShell extends ConsumerWidget {
  const PatientShell({required this.shell, super.key});

  final StatefulNavigationShell shell;

  Future<void> _openEmergencySheet(BuildContext context, WidgetRef ref) async {
    // Numbers come from the enrolment-time bundle so this works offline;
    // fall back to config defaults if somehow absent.
    final bundle = await EmergencyBundle.load();
    final ambulance = bundle?.ambulanceNumber ?? '103';
    final clinicPhone = bundle?.clinicPhone;
    if (!context.mounted) return;

    await EmergencySheet.show(
      context,
      title: const Txt('emergency.sheet_title'),
      instruction: const Txt('emergency.banner'),
      callAmbulanceLabel: const Txt('emergency.call_103'),
      callClinicLabel: const Txt('emergency.call_clinic'),
      onCallAmbulance: () => dial(ambulance),
      onCallClinic: () {
        if (clinicPhone != null) dial(clinicPhone);
      },
      hoursLine: const Txt('emergency.hours_line'),
    );
  }

  String? _labelOf(WidgetRef ref, String key) =>
      switch (ref.watch(txtProvider(key))) {
        AsyncData(value: final ContentResolved r) => r.text,
        _ => null,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: Stack(
        children: [
          shell,
          // Persistent emergency affordance — below the status bar, right.
          Positioned(
            top: MediaQuery.paddingOf(context).top + AppSpace.s4,
            right: AppSpace.s16,
            child: _EmergencyAffordance(
              onPressed: () => _openEmergencySheet(context, ref),
            ),
          ),
          // Persistent AI-assistant entry — above the bottom nav, on every
          // tab. The nav stays at the spec's four items.
          Positioned(
            right: AppSpace.s16,
            bottom: AppSpace.s16,
            child: _AssistantFab(
              onPressed: () => context.push(Routes.assistant),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpace.s16,
          0,
          AppSpace.s16,
          AppSpace.s16,
        ),
        child: AppBottomNav(
          activeIndex: shell.currentIndex,
          onSelect: (i) => shell.goBranch(
            i,
            initialLocation: i == shell.currentIndex,
          ),
          items: [
            BottomNavItem(
              icon: Icons.home_outlined,
              label: const Txt('nav.today'),
              semanticLabel: _labelOf(ref, 'nav.today'),
            ),
            BottomNavItem(
              icon: Icons.insert_chart_outlined_rounded,
              label: const Txt('nav.progress'),
              semanticLabel: _labelOf(ref, 'nav.progress'),
            ),
            BottomNavItem(
              icon: Icons.menu_book_outlined,
              label: const Txt('nav.learn'),
              semanticLabel: _labelOf(ref, 'nav.learn'),
            ),
            BottomNavItem(
              icon: Icons.settings_outlined,
              label: const Txt('nav.settings'),
              semanticLabel: _labelOf(ref, 'nav.settings'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmergencyAffordance extends ConsumerWidget {
  const _EmergencyAffordance({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // The a11y label is patient-facing → resolved from the library; falls
    // back to the emergency number itself (data, not prose) if unresolved.
    final label = ref.watch(txtProvider('a11y.emergency_button'));
    final resolved = switch (label) {
      AsyncData(value: final ContentResolved r) => r.text,
      _ => '103',
    };
    return EmergencyButton(semanticLabel: resolved, onPressed: onPressed);
  }
}

class _AssistantFab extends ConsumerWidget {
  const _AssistantFab({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final label = switch (ref.watch(txtProvider('assistant.title'))) {
      AsyncData(value: final ContentResolved r) => r.text,
      _ => 'Assistant',
    };
    return Semantics(
      button: true,
      label: label,
      child: Container(
        // Sits just above the floating bottom-nav pill.
        margin: const EdgeInsets.only(bottom: 12),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: AppShadow.nav,
        ),
        child: Material(
          color: AppColors.brand600,
          shape: const CircleBorder(),
          child: InkWell(
            onTap: onPressed,
            customBorder: const CircleBorder(),
            child: const SizedBox(
              width: 56,
              height: 56,
              child: Icon(
                Icons.auto_awesome_outlined,
                color: AppColors.surface,
                size: 26,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
