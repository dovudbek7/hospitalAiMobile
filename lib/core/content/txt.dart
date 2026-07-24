import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';
import 'interpolate.dart';

/// THE way patient-visible text reaches the screen. `Txt('content.key')`
/// resolves the key through the content library in the current language and
/// renders the result. There is no code path from any other text source to
/// a patient screen — the CI literal gate enforces the negative side.
///
/// Behaviour by result:
///  - Resolved       → interpolated text.
///  - NotApproved    → renders NOTHING (fail closed). Screens that need the
///                     explanatory panel use [TxtGate] around their content.
///  - Unavailable    → renders nothing (offline, uncached) — the screen's
///                     offline state explains; no invented text here.
///  - loading        → nothing. Never a flash of another language.
class Txt extends ConsumerWidget {
  const Txt(
    this.contentKey, {
    this.style,
    this.textAlign,
    this.vars = const {},
    this.maxLines,
    this.overflow,
    super.key,
  });

  final String contentKey;
  final TextStyle? style;
  final TextAlign? textAlign;

  /// Extra interpolation values (N, TOTAL, …) merged over the app-level set.
  final Map<String, String> vars;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(txtProvider(contentKey));
    final appVars = ref.watch(interpolationVarsProvider);

    return switch (result) {
      AsyncData(value: final ContentResolved r) => Text(
          interpolate(r.text, {...appVars, ...vars}),
          style: style,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
        ),
      // Fail closed / unavailable / loading: nothing. Never a fallback.
      _ => const SizedBox.shrink(),
    };
  }
}

/// Screen-level gate: shows [child] only when every key in [requiredKeys]
/// resolves; otherwise shows [fallback] (typically a FailClosedPanel wired
/// with the clinic phone). Used where the SPEC demands an explicit
/// "not available in your language" state (P7 instructions, P15 articles).
class TxtGate extends ConsumerWidget {
  const TxtGate({
    required this.requiredKeys,
    required this.child,
    required this.fallback,
    this.loading,
    super.key,
  });

  final List<String> requiredKeys;
  final Widget child;
  final Widget fallback;
  final Widget? loading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var anyLoading = false;
    for (final key in requiredKeys) {
      final result = ref.watch(txtProvider(key));
      switch (result) {
        case AsyncData(value: ContentResolved()):
          continue;
        case AsyncLoading():
          anyLoading = true;
        default:
          return fallback;
      }
    }
    if (anyLoading) {
      return loading ?? const SizedBox.shrink();
    }
    return child;
  }
}
