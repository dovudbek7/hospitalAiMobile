import 'package:flutter/material.dart';

/// Design tokens — ratified from `design/index.html` (the approved prototype).
///
/// Brand is the dashboard blue, a ratified deviation from the written spec's
/// teal. The SAFETY tokens below are verbatim from the spec and must never be
/// re-mapped or reused for anything else (md/steps.md, standing rule 8).
abstract final class AppColors {
  // Brand ramp.
  static const brand50 = Color(0xFFEEF3FF);
  static const brand100 = Color(0xFFDDE7FF);
  static const brand200 = Color(0xFFC2D3FF);
  static const brand300 = Color(0xFF9DB8FF);
  static const brand400 = Color(0xFF6E93FF);
  static const brand500 = Color(0xFF4C7CFF);
  static const brand600 = Color(0xFF3B6EF6);
  static const brand700 = Color(0xFF2F5FE0);
  static const brand800 = Color(0xFF2450C8);

  // Neutrals.
  static const ink = Color(0xFF1A2430);
  static const muted = Color(0xFF5B6673);
  static const line = Color(0xFFE6EAF2);
  static const surface = Color(0xFFFFFFFF);
  static const canvas = Color(0xFFF2F5FA);

  // SAFETY TOKENS — spec-fixed. `emergency` is tier 1 only, never anything
  // else, ever. Overdue is grey, never red.
  static const emergency = Color(0xFFB3261E);
  static const urgent = Color(0xFFB36B00);
  static const routine = Color(0xFF7A6A00);
  static const success = Color(0xFF1B7F5A);
  static const overdue = Color(0xFF5B6673);

  // Soft task-icon tints (from the prototype).
  static const tintGreenBg = Color(0xFFE9F7F1);
  static const tintAmberBg = Color(0xFFFDF1EC);
  static const tintAmberFg = Color(0xFFC2603A);
  static const tintVioletBg = Color(0xFFF2EEFB);
  static const tintVioletFg = Color(0xFF6D53C7);
}

/// 4pt grid. Permitted values only — an off-grid number should not compile.
abstract final class AppSpace {
  static const double s4 = 4;
  static const double s8 = 8;
  static const double s12 = 12;
  static const double s16 = 16;
  static const double s24 = 24;
  static const double s32 = 32;
  static const double s48 = 48;
  static const double s64 = 64;
}

abstract final class AppRadius {
  static const double card = 20;
  static const double button = 16;
  static const double tile = 15;
  static const double sheet = 30;
  static const double chip = 999;

  static final BorderRadius cardAll = BorderRadius.circular(card);
  static final BorderRadius buttonAll = BorderRadius.circular(button);
  static final BorderRadius tileAll = BorderRadius.circular(tile);
}

abstract final class AppShadow {
  static const card = [
    BoxShadow(color: Color(0x0A102840), offset: Offset(0, 1), blurRadius: 2),
    BoxShadow(color: Color(0x0F102840), offset: Offset(0, 8), blurRadius: 24),
  ];
  static const lift = [
    BoxShadow(color: Color(0x0F102840), offset: Offset(0, 2), blurRadius: 6),
    BoxShadow(color: Color(0x1A102840), offset: Offset(0, 16), blurRadius: 40),
  ];
  static const nav = [
    BoxShadow(color: Color(0x29102840), offset: Offset(0, 8), blurRadius: 32),
  ];
}

/// Touch targets — spec minimums.
abstract final class AppHit {
  /// Absolute minimum for anything tappable.
  static const double min = 48;

  /// Primary patient actions: task checkbox, Continue, Taken.
  static const double key = 64;

  /// The emergency call button inside the sheet.
  static const double emergencyCall = 68;

  /// The persistent emergency affordance (44dp circle, spec banner height).
  static const double emergencyFab = 44;
}

abstract final class AppDur {
  static const fast = Duration(milliseconds: 120);
  static const screen = Duration(milliseconds: 220);
  static const sheet = Duration(milliseconds: 340);
  static const halo = Duration(milliseconds: 2800);
}
