import 'package:flutter/material.dart';

import 'theme/tokens.dart';

/// Shown when `main()` fails before the real app can start — a build with no
/// API_BASE_URL and no DEMO_MODE, a storage layer that will not open, and so
/// on. It is a BUILD fault, never a patient state: this screen can only
/// appear on a binary that could never have worked, so its text is
/// developer-facing English and does not go through the content library.
class BootFailureApp extends StatelessWidget {
  const BootFailureApp({required this.error, super.key});

  final String error;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.canvas,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpace.s24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.build_circle_outlined,
                    size: 48,
                    color: AppColors.muted,
                  ),
                  const SizedBox(height: AppSpace.s16),
                  const Text(
                    // literal-ok: build-fault screen, developer-facing.
                    'This build could not start',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: AppSpace.s12),
                  SelectableText(
                    error, // literal-ok: the raw startup error, for the log.
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: AppColors.muted,
                    ),
                  ),
                  const SizedBox(height: AppSpace.s16),
                  const SelectableText(
                    // literal-ok: the fix, for whoever produced the binary.
                    'Rebuild with one of:\n'
                    '  flutter build apk --release '
                    '--dart-define=DEMO_MODE=true\n'
                    '  flutter build apk --release '
                    '--dart-define=API_BASE_URL=https://…/v1',
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      fontFamily: 'monospace',
                      color: AppColors.ink,
                    ),
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
