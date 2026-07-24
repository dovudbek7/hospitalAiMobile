import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hospital_ai/core/theme/tokens.dart';

/// WCAG AA: 4.5:1 for body text, 3:1 for large text (≥18px bold / ≥24px).
/// Every text/background pair the design system produces is asserted here —
/// a token change that breaks contrast fails CI, not a clinician review.
double _ratio(Color fg, Color bg) {
  final lf = fg.computeLuminance();
  final lb = bg.computeLuminance();
  final hi = lf > lb ? lf : lb;
  final lo = lf > lb ? lb : lf;
  return (hi + 0.05) / (lo + 0.05);
}

void main() {
  group('WCAG AA contrast — body text (>= 4.5)', () {
    final pairs = <String, (Color, Color)>{
      'ink on surface': (AppColors.ink, AppColors.surface),
      'ink on canvas': (AppColors.ink, AppColors.canvas),
      'ink on brand50': (AppColors.ink, AppColors.brand50),
      'muted on surface': (AppColors.muted, AppColors.surface),
      'muted on canvas': (AppColors.muted, AppColors.canvas),
      'overdue on surface': (AppColors.overdue, AppColors.surface),
      'white on emergency': (AppColors.surface, AppColors.emergency),
      'brand700 on brand50': (AppColors.brand700, AppColors.brand50),
      'brand800 on brand50': (AppColors.brand800, AppColors.brand50),
    };
    pairs.forEach((name, p) {
      test(name, () {
        expect(
          _ratio(p.$1, p.$2),
          greaterThanOrEqualTo(4.5),
          reason: '$name is used at body size',
        );
      });
    });
  });

  group('WCAG AA contrast — large/bold text (>= 3.0)', () {
    // Button labels are 18/600 — large text under WCAG.
    final pairs = <String, (Color, Color)>{
      'white on brand600 (primary button)': (
        AppColors.surface,
        AppColors.brand600,
      ),
      'white on success (completed tick)': (
        AppColors.surface,
        AppColors.success,
      ),
      'white on brand700 (gradient end)': (
        AppColors.surface,
        AppColors.brand700,
      ),
      'urgent chip text on surface': (AppColors.urgent, AppColors.surface),
      'routine chip text on surface': (AppColors.routine, AppColors.surface),
      'emergency text on surface': (AppColors.emergency, AppColors.surface),
    };
    pairs.forEach((name, p) {
      test(name, () {
        expect(
          _ratio(p.$1, p.$2),
          greaterThanOrEqualTo(3.0),
          reason: '$name is used at large/bold size',
        );
      });
    });
  });
}
