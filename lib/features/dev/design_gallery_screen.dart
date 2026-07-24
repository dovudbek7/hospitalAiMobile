// Design-system gallery — developer-facing only, mounted on a debug route.
// Sample strings here are placeholders for review against design/index.html;
// they never ship to a patient. The file is allowlisted in
// tool/check_no_patient_literals.dart for that reason.

import 'package:flutter/material.dart';

import '../../core/theme/tokens.dart';
import '../../core/theme/typography.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/bottom_nav.dart';
import '../../core/widgets/code_field.dart';
import '../../core/widgets/content_slot.dart';
import '../../core/widgets/emergency_button.dart';
import '../../core/widgets/emergency_sheet.dart';
import '../../core/widgets/fail_closed_panel.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/misc.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/scale_selector.dart';
import '../../core/widgets/secondary_button.dart';
import '../../core/widgets/task_row.dart';
import '../../core/widgets/tier_chip.dart';

class DesignGalleryScreen extends StatefulWidget {
  const DesignGalleryScreen({super.key});

  @override
  State<DesignGalleryScreen> createState() => _DesignGalleryScreenState();
}

class _DesignGalleryScreenState extends State<DesignGalleryScreen> {
  final _code = TextEditingController(text: 'H7K9QP');
  int _scale = 5;
  int _nav = 0;

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Design gallery')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpace.s16),
        children: [
          const _Section('Type scale'),
          const Text('Display 28/800', style: AppText.display),
          const Text('H1 22/700', style: AppText.h1),
          const Text('H2 18/600', style: AppText.h2),
          const Text('Body-L 18/400 — patient floor', style: AppText.bodyL),
          const Text('Body 16/400 — secondary only', style: AppText.body),
          const Text('Caption 14/400', style: AppText.caption),

          const _Section('Buttons'),
          PrimaryButton(
            onPressed: () {},
            icon: const Icon(Icons.check_rounded),
            child: const Text('Primary key action · 64'),
          ),
          const SizedBox(height: AppSpace.s12),
          SecondaryButton(
            onPressed: () {},
            icon: const Icon(Icons.call_rounded),
            child: const Text('Secondary · 64'),
          ),
          const SizedBox(height: AppSpace.s12),
          const PrimaryButton(
            onPressed: null,
            child: Text('Disabled — visible, never ghosted'),
          ),

          const _Section('Task rows'),
          TaskRow(
            icon: const Icon(Icons.medication_outlined),
            title: const Text('Paracetamol 500 mg'),
            time: '14:00',
            state: TaskRowState.pending,
            onToggle: () {},
          ),
          const SizedBox(height: AppSpace.s12),
          TaskRow(
            icon: const Icon(Icons.medication_outlined),
            title: const Text('Paracetamol 500 mg'),
            time: '08:00',
            state: TaskRowState.completed,
            onToggle: () {},
          ),
          const SizedBox(height: AppSpace.s12),
          TaskRow(
            icon: const Icon(Icons.healing_outlined),
            title: const Text('Wound care'),
            time: '10:00',
            state: TaskRowState.overdue,
            overdueSuffix: const Text('Earlier today'),
            iconBackground: AppColors.tintAmberBg,
            iconColor: AppColors.tintAmberFg,
            onToggle: () {},
          ),

          const _Section('Tier chips — icon + label, never colour alone'),
          const Wrap(
            spacing: AppSpace.s8,
            runSpacing: AppSpace.s8,
            children: [
              TierChip(tier: Tier.routine, label: Text('Routine')),
              TierChip(tier: Tier.urgent, label: Text('Urgent')),
              TierChip(tier: Tier.emergency, label: Text('Emergency')),
            ],
          ),

          const _Section('Emergency affordance'),
          Row(
            children: [
              EmergencyButton(
                semanticLabel: 'Emergency instruction',
                onPressed: () => EmergencySheet.show(
                  context,
                  title: const Text('In an emergency'),
                  instruction: const Text(
                    'Your clinic’s instruction: in an emergency, call 103. '
                    'Do not use this app to report urgent symptoms.',
                  ),
                  callAmbulanceLabel: const Text('Call 103'),
                  callClinicLabel: const Text('Call Sehat Clinic (DEMO)'),
                  onCallAmbulance: () {},
                  onCallClinic: () {},
                  hoursLine: const Text('09:00–18:00 · Mon–Sat'),
                ),
              ),
              const SizedBox(width: AppSpace.s16),
              const Expanded(
                child: Text(
                  'Tap to open the sheet — full verbatim text + dial actions',
                  style: AppText.caption,
                ),
              ),
            ],
          ),

          const _Section('Inputs'),
          CodeField(controller: _code, label: const Text('CODE')),

          const _Section('0–10 scale — the only horizontal scroll in the app'),
          ScaleSelector(
            value: _scale,
            onChanged: (v) => setState(() => _scale = v),
            lowLabel: const Text('0 · No pain'),
            highLabel: const Text('10 · Worst pain'),
          ),

          const _Section('Hero pieces'),
          BrandGradient(
            borderRadius: BorderRadius.circular(AppRadius.card),
            padding: const EdgeInsets.all(AppSpace.s16),
            child: const GlassCard(
              child: Row(
                children: [
                  ProgressRing(
                    progress: 6 / 30,
                    child: Text(
                      '6',
                      style: TextStyle(
                        color: AppColors.surface,
                        fontWeight: FontWeight.w800,
                        fontSize: 19,
                      ),
                    ),
                  ),
                  SizedBox(width: AppSpace.s16),
                  Expanded(
                    child: Text(
                      'Day 6 of 30',
                      style: TextStyle(
                        color: AppColors.surface,
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const _Section('States'),
          const OfflineStrip(
            label: Text('Offline — your progress will be saved'),
          ),
          const SizedBox(height: AppSpace.s12),
          const ContentSlot(
            contentKey: 'clinical.laparoscopic_appendectomy.wound_care_day6',
          ),
          const SizedBox(height: AppSpace.s12),
          FailClosedPanel(
            title: const Text('This is not yet available in your language.'),
            body: const Text(
              'Please contact your clinic if you need this information.',
            ),
            callLabel: const Text('+998 71 200 00 00'),
            onCallClinic: () {},
            diagnosticCode: 'CONTENT_NOT_APPROVED',
          ),

          const _Section('Day grid'),
          const AppCard(child: DayGrid(totalDays: 30, currentDay: 6)),

          const _Section('Bottom nav'),
          AppBottomNav(
            activeIndex: _nav,
            onSelect: (i) => setState(() => _nav = i),
            items: const [
              BottomNavItem(icon: Icons.home_outlined, label: Text('Today')),
              BottomNavItem(
                icon: Icons.insert_chart_outlined_rounded,
                label: Text('Progress'),
              ),
              BottomNavItem(
                icon: Icons.menu_book_outlined,
                label: Text('Learn'),
              ),
              BottomNavItem(
                icon: Icons.settings_outlined,
                label: Text('Settings'),
              ),
            ],
          ),
          const SizedBox(height: AppSpace.s48),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpace.s24, bottom: AppSpace.s12),
      child: Eyebrow(child: Text(title.toUpperCase())),
    );
  }
}
