import 'package:flutter/material.dart';

/// App shell. The router and theme land in F1/F4; until then this is a
/// deliberately minimal placeholder that proves fonts and configuration.
///
/// NOTE: this widget is developer-facing scaffolding, not a patient screen.
/// Patient-visible text must come from the content library (see md/steps.md,
/// standing rule 2) — which is why nothing here will survive to F6.
class HospitalAiApp extends StatelessWidget {
  const HospitalAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Inter', useMaterial3: true),
      home: const _BootScreen(),
    );
  }
}

class _BootScreen extends StatelessWidget {
  const _BootScreen();

  @override
  Widget build(BuildContext context) {
    // Dev-only boot placeholder (F0). Replaced by the router in F4.
    return const Scaffold(
      body: Center(
        child: Text(
          'Hospital AI — F0 foundation',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
