import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';

import 'app.dart';
import 'core/auth/session.dart';
import 'core/notifications/reminders.dart';
import 'features/onboarding/data/auth_repository.dart';
import 'core/router/app_router.dart';
import 'core/network/token_store.dart';
import 'core/providers.dart';
import 'core/storage/secure_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Env.requireValid();

  // Session flags load BEFORE the first frame so a returning patient's
  // first frame is already Today — no login flash, no re-login, ever.
  final prefs = await SharedPreferences.getInstance();

  final container = ProviderContainer(
    overrides: appOverrides(prefs, SecureTokenStore()),
  );

  // Notification taps open P8 directly for the tapped medication.
  // Reminders failing to initialise (e.g. desktop dev runs) must never
  // block the programme — the P5 rule, applied to boot.
  try {
    await container.read(reminderServiceProvider).init(
          onOpenMedication: (taskId) =>
              container.read(routerProvider).push(medicationRouteFor(taskId)),
        );
  } on Exception {
    // Continue without local notifications.
  }

  // Returning patient: refresh profile-derived state (clinic vars for
  // {TOKEN} interpolation, authoritative language, emergency bundle) in the
  // background. Failures are absorbed — cached values keep working.
  if (container.read(sessionProvider).onboarded) {
    unawaited(
      container
          .read(authRepositoryProvider)
          .bootstrapProfile()
          .catchError((Object _) => null),
    );
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const HospitalAiApp(),
    ),
  );
}

// One override set shared by main() and the integration tests.
List<Override> appOverrides(SharedPreferences prefs, TokenStore tokens) => [
      sharedPrefsProvider.overrideWithValue(prefs),
      tokenStoreProvider.overrideWithValue(tokens),
    ];
