import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/checkin/p10_checkin_screen.dart';
import '../../features/checkin/p11_routine_screen.dart';
import '../../features/checkin/p12_urgent_screen.dart';
import '../../features/checkin/p13_emergency_screen.dart';
import '../../features/dev/design_gallery_screen.dart';
import '../../features/learn/p14_learn_screen.dart';
import '../../features/learn/p15_article_screen.dart';
import '../../features/medication/p8_medication_screen.dart';
import '../../features/onboarding/p1_language_screen.dart';
import '../../features/onboarding/p2_code_screen.dart';
import '../../features/onboarding/p3_phone_screen.dart';
import '../../features/onboarding/p4_consent_screen.dart';
import '../../features/onboarding/p5_welcome_screen.dart';
import '../../features/progress/p9_progress_screen.dart';
import '../../features/settings/p16_settings_screen.dart';
import '../../features/shell/patient_shell.dart';
import '../../features/survey/p17_survey_screen.dart';
import '../../features/today/p6_today_screen.dart';
import '../../features/today/p7_task_detail_screen.dart';
import '../auth/session.dart';
import 'guards.dart';

/// Bridges Riverpod state changes into go_router's refreshListenable.
class _SessionListenable extends ChangeNotifier {
  _SessionListenable(Ref ref) {
    _sub = ref.listen<SessionSnapshot>(sessionProvider, (_, s) {
      notifyListeners();
    });
  }

  late final ProviderSubscription<SessionSnapshot> _sub;

  @override
  void dispose() {
    _sub.close();
    super.dispose();
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final listenable = _SessionListenable(ref);
  ref.onDispose(listenable.dispose);

  return GoRouter(
    initialLocation: Routes.today,
    refreshListenable: listenable,
    redirect: (context, state) =>
        sessionRedirect(ref.read(sessionProvider), state.matchedLocation),
    routes: [
      // ---------- onboarding ----------
      GoRoute(
        path: Routes.language,
        builder: (context, state) => const P1LanguageScreen(),
      ),
      GoRoute(path: Routes.code, builder: (context, state) => const P2CodeScreen()),
      GoRoute(path: Routes.phone, builder: (context, state) => const P3PhoneScreen()),
      GoRoute(
        path: Routes.consent,
        builder: (context, state) => const P4ConsentScreen(),
      ),
      GoRoute(
        path: Routes.welcome,
        builder: (context, state) => const P5WelcomeScreen(),
      ),

      // ---------- main shell (bottom nav) ----------
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => PatientShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.today,
                builder: (context, state) => const P6TodayScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.progress,
                builder: (context, state) => const P9ProgressScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.learn,
                builder: (context, state) => const P14LearnScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.settings,
                builder: (context, state) => const P16SettingsScreen(),
              ),
            ],
          ),
        ],
      ),

      // ---------- detail / flows ----------
      GoRoute(
        path: '${Routes.task}/:id',
        builder: (context, state) =>
            P7TaskDetailScreen(taskId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '${Routes.medication}/:id',
        builder: (context, state) =>
            P8MedicationScreen(taskId: state.pathParameters['id']!),
      ),
      GoRoute(path: Routes.checkin, builder: (context, state) => const P10CheckinScreen()),
      GoRoute(
        path: '${Routes.checkinResult}/routine',
        builder: (context, state) => const P11RoutineScreen(),
      ),
      GoRoute(
        path: '${Routes.checkinResult}/urgent',
        builder: (context, state) => const P12UrgentScreen(),
      ),
      // P13 is its own top-level route so NOTHING can sit on top of it.
      GoRoute(
        path: Routes.emergency,
        builder: (context, state) => const P13EmergencyScreen(),
      ),
      GoRoute(
        path: '${Routes.article}/:key',
        builder: (context, state) =>
            P15ArticleScreen(contentKey: state.pathParameters['key']!),
      ),
      GoRoute(path: Routes.survey, builder: (context, state) => const P17SurveyScreen()),

      // Debug-only design gallery.
      GoRoute(
        path: Routes.gallery,
        builder: (context, state) => const DesignGalleryScreen(),
      ),
    ],
  );
});
