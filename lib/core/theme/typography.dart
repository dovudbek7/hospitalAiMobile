import 'package:flutter/material.dart';

import 'tokens.dart';

/// The seven type styles from the design system. Inter, line height 1.5.
///
/// **The 18sp floor.** Patient-default body text is 18, not 16 — post-operative
/// patients are frequently older, tired and medicated. `body` (16) exists for
/// secondary, non-essential text only. Never shrink type to fit; let it wrap.
abstract final class AppText {
  static const String family = 'Inter';
  static const String monoFamily = 'JetBrainsMono';

  static const display = TextStyle(
    fontFamily: family,
    fontSize: 28,
    height: 1.3,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
    color: AppColors.ink,
  );

  static const h1 = TextStyle(
    fontFamily: family,
    fontSize: 22,
    height: 1.35,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    color: AppColors.ink,
  );

  static const h2 = TextStyle(
    fontFamily: family,
    fontSize: 18,
    height: 1.4,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
  );

  /// Patient app default body — the floor, not a suggestion.
  static const bodyL = TextStyle(
    fontFamily: family,
    fontSize: 18,
    height: 1.5,
    fontWeight: FontWeight.w400,
    color: AppColors.ink,
  );

  static const body = TextStyle(
    fontFamily: family,
    fontSize: 16,
    height: 1.5,
    fontWeight: FontWeight.w400,
    color: AppColors.ink,
  );

  static const caption = TextStyle(
    fontFamily: family,
    fontSize: 14,
    height: 1.5,
    fontWeight: FontWeight.w400,
    color: AppColors.muted,
  );

  static const button = TextStyle(
    fontFamily: family,
    fontSize: 18,
    height: 1.2,
    fontWeight: FontWeight.w600,
  );

  /// Enrolment code field: mono, 24, letter-spaced, centred.
  static const code = TextStyle(
    fontFamily: monoFamily,
    fontSize: 24,
    height: 1.3,
    fontWeight: FontWeight.w600,
    letterSpacing: 10,
    color: AppColors.ink,
  );

  /// Section eyebrow (uppercase tracking label from the prototype).
  static const eyebrow = TextStyle(
    fontFamily: family,
    fontSize: 13,
    height: 1.4,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.8,
    color: AppColors.muted,
  );
}
