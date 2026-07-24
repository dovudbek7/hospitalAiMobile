// P13 · EMERGENCY — this screen does not wait for anyone.
//
// Hard requirements, all implemented here:
//  - Renders and dials with NO network: every string and number comes from
//    the enrolment-time EmergencyBundle, never the network.
//  - Identical in and out of clinic hours — no staff dependency.
//  - Shown BEFORE staff are notified (the escalation was created server-side
//    at submit; this screen renders immediately on the tier).
//  - CANNOT be suppressed, deduplicated, or rate-limited.
//  - emergency_screen_shown is logged EVERY single render, including
//    offline (the outbox is local-first).
//  - Dismiss exists but is deliberately de-emphasised.
//
// Kept as its own screen — NOT merged with P11/P12. The duplication is the
// safety feature (independently reviewable, independently testable,
// impossible to show the wrong reassurance level via a template bug).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/content/emergency_bundle.dart';
import '../../core/content/txt.dart';
import '../../core/router/guards.dart';
import '../../core/telemetry/client_events.dart';
import '../../core/theme/tokens.dart';
import '../../core/theme/typography.dart';
import '../../core/util/dial.dart';

class P13EmergencyScreen extends ConsumerStatefulWidget {
  const P13EmergencyScreen({super.key});

  @override
  ConsumerState<P13EmergencyScreen> createState() =>
      _P13EmergencyScreenState();
}

class _P13EmergencyScreenState extends ConsumerState<P13EmergencyScreen> {
  EmergencyBundle? _bundle;

  @override
  void initState() {
    super.initState();
    // Logged EVERY render, no exception, no dedupe — queued when offline.
    // ignore: unawaited_futures
    ref
        .read(clientEventsProvider)
        .emergencyScreenShown(trigger: 'tier')
        .catchError((Object _) {});
    // Strings + numbers from the offline bundle, never the network.
    // ignore: unawaited_futures
    EmergencyBundle.load().then((b) {
      if (mounted) setState(() => _bundle = b);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bundle = _bundle;

    return Scaffold(
      // Full-screen, high-contrast, unmistakable. The ONLY red surface in
      // the entire app.
      backgroundColor: AppColors.emergency,
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
                      Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          color: AppColors.surface.withValues(alpha: .15),
                          borderRadius: BorderRadius.circular(26),
                        ),
                        child: const Icon(
                          Icons.warning_amber_rounded,
                          color: AppColors.surface,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: AppSpace.s24),
                      // Verbatim clinician-signed copy from the bundle;
                      // Txt-resolution is only the cold-start fallback for
                      // a never-enrolled build.
                      if (bundle != null)
                        Text(
                          bundle.headline,
                          style: AppText.display.copyWith(
                            color: AppColors.surface,
                            fontSize: 32,
                            height: 1.2,
                          ),
                        )
                      else
                        Txt(
                          'emergency.headline',
                          style: AppText.display.copyWith(
                            color: AppColors.surface,
                            fontSize: 32,
                            height: 1.2,
                          ),
                        ),
                      const SizedBox(height: AppSpace.s16),
                      if (bundle != null)
                        Text(
                          bundle.body,
                          style: AppText.bodyL.copyWith(
                            color: AppColors.surface.withValues(alpha: .92),
                          ),
                        )
                      else
                        Txt(
                          'emergency.body',
                          style: AppText.bodyL.copyWith(
                            color: AppColors.surface.withValues(alpha: .92),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              // Giant primary: Call 103 — 76dp, full width, white on red.
              Semantics(
                button: true,
                child: Material(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(22),
                  child: InkWell(
                    onTap: () => dial(bundle?.ambulanceNumber ?? '103'),
                    borderRadius: BorderRadius.circular(22),
                    child: Container(
                      height: 76,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.call_rounded,
                            color: AppColors.emergency,
                            size: 28,
                          ),
                          const SizedBox(width: AppSpace.s12),
                          Flexible(
                            child: Txt(
                              'emergency.call_103',
                              textAlign: TextAlign.center,
                              style: AppText.display.copyWith(
                                color: AppColors.emergency,
                                fontSize: 26,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpace.s12),
              // Secondary: call the clinic.
              Semantics(
                button: true,
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(22),
                  child: InkWell(
                    onTap: bundle == null
                        ? null
                        : () => dial(bundle.clinicPhone),
                    borderRadius: BorderRadius.circular(22),
                    child: Container(
                      height: AppHit.key,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: AppColors.surface.withValues(alpha: .7),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.call_rounded,
                            color: AppColors.surface,
                            size: 20,
                          ),
                          const SizedBox(width: AppSpace.s8),
                          Flexible(
                            child: Txt(
                              'emergency.call_clinic',
                              textAlign: TextAlign.center,
                              style: AppText.button
                                  .copyWith(color: AppColors.surface),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpace.s8),
              // Dismiss: available, deliberately de-emphasised — the
              // patient can leave, but never by accident.
              Center(
                child: TextButton(
                  onPressed: () => context.go(Routes.today),
                  child: Txt(
                    'emergency.close',
                    style: AppText.caption.copyWith(
                      color: AppColors.surface.withValues(alpha: .6),
                      decoration: TextDecoration.underline,
                      decorationColor:
                          AppColors.surface.withValues(alpha: .6),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
