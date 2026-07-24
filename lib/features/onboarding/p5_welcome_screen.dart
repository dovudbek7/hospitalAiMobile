// P5 · Welcome / ready. Notification rationale is shown BEFORE the OS
// prompt, and denial NEVER blocks the programme (spec P5).

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/content/txt.dart';
import '../../core/providers.dart';
import '../../core/router/guards.dart';
import '../../core/theme/tokens.dart';
import '../../core/theme/typography.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/primary_button.dart';

class P5WelcomeScreen extends ConsumerStatefulWidget {
  const P5WelcomeScreen({super.key});

  @override
  ConsumerState<P5WelcomeScreen> createState() => _P5WelcomeScreenState();
}

class _P5WelcomeScreenState extends ConsumerState<P5WelcomeScreen> {
  bool _starting = false;

  Future<void> _start() async {
    setState(() => _starting = true);
    // The rationale (onboarding.notifications.why) is already on screen —
    // NOW ask the OS. Denial changes nothing about the programme; Today
    // shows a non-blocking banner instead (F8).
    try {
      final plugin = FlutterLocalNotificationsPlugin();
      await plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
      await plugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    } on Exception {
      // Denied or unavailable — continue regardless, by design.
    }
    // Engagement telemetry; fire-and-forget.
    try {
      await ref.read(patientApiProvider).appOpened();
    } on Exception {
      // Offline is fine.
    }
    if (mounted) context.go(Routes.today);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpace.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.success,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.success.withValues(alpha: .35),
                      offset: const Offset(0, 12),
                      blurRadius: 28,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: AppColors.surface,
                  size: 36,
                ),
              ),
              const SizedBox(height: AppSpace.s24),
              // {FIRST_NAME} interpolates from the bootstrapped profile.
              Txt(
                'onboarding.welcome.title',
                style: AppText.display.copyWith(fontSize: 30),
              ),
              const SizedBox(height: AppSpace.s24),
              for (final key in const [
                'onboarding.welcome.line1',
                'onboarding.welcome.line2',
                'onboarding.welcome.line3',
              ]) ...[
                AppCard(child: Txt(key, style: AppText.bodyL)),
                const SizedBox(height: AppSpace.s12),
              ],
              const SizedBox(height: AppSpace.s4),
              Container(
                padding: const EdgeInsets.all(AppSpace.s16),
                decoration: BoxDecoration(
                  color: AppColors.brand50,
                  borderRadius: AppRadius.cardAll,
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.notifications_none_rounded,
                      color: AppColors.brand700,
                    ),
                    SizedBox(width: AppSpace.s12),
                    Expanded(
                      child: Txt(
                        'onboarding.notifications.why',
                        style: AppText.body,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpace.s24),
              PrimaryButton(
                onPressed: _starting ? null : _start,
                child: const Txt('onboarding.welcome.start'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
