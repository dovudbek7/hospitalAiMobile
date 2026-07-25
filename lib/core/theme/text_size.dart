// Patient-chosen text size (P16). Three steps, Medium by default.
//
// The app scales its OWN type instead of inheriting the OS font-size slider:
// a phone left on "Huge" was rendering 18sp body text at ~24sp and breaking
// every layout, and a post-operative patient cannot be asked to go fix a
// system setting first. Large is the accessibility step (elderly patients),
// and it is bounded — a size the layouts are actually tested at.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/session.dart' show sharedPrefsProvider;

enum TextSizeChoice {
  small(0.88),
  medium(1),
  large(1.18);

  const TextSizeChoice(this.factor);

  /// Multiplier applied to every [AppText] size in the tree.
  final double factor;
}

class TextSizeNotifier extends Notifier<TextSizeChoice> {
  static const _prefsKey = 'settings.text_size_v1';

  @override
  TextSizeChoice build() {
    try {
      final raw = ref.read(sharedPrefsProvider).getString(_prefsKey);
      return TextSizeChoice.values.firstWhere(
        (c) => c.name == raw,
        orElse: () => TextSizeChoice.medium,
      );
    } catch (_) {
      return TextSizeChoice.medium; // tests without prefs
    }
  }

  void set(TextSizeChoice choice) {
    state = choice;
    try {
      ref.read(sharedPrefsProvider).setString(_prefsKey, choice.name);
    } catch (_) {}
  }
}

final textSizeProvider =
    NotifierProvider<TextSizeNotifier, TextSizeChoice>(TextSizeNotifier.new);

/// Applies the chosen size to everything below it. Placed once, in
/// [MaterialApp.builder], so no screen has to think about it.
class AppTextScale extends ConsumerWidget {
  const AppTextScale({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final choice = ref.watch(textSizeProvider);
    // linear() REPLACES the OS scaler rather than composing with it — that
    // is the point: the size the patient picked here is the size they get.
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(choice.factor),
      ),
      child: child,
    );
  }
}
