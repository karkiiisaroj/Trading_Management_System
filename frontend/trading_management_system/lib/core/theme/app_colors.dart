import 'package:flutter/material.dart';

/// AARTHA colour tokens (from the design system sheet).
abstract final class AppColors {
  /// Screens.
  static const Color background = Color(0xFF18372B);

  /// Cards, fields.
  static const Color surface = Color(0xFF1F4435);

  /// Tab bar, sidebar, cards that sit on [surface] fields.
  static const Color deep = Color(0xFF12291F);

  /// Dividers and default borders.
  static const Color border = Color(0xFF34584A);

  /// Main text.
  static const Color text = Color(0xFFF4F1E9);

  /// Secondary text.
  static const Color muted = Color(0xFFB5C3B9);

  /// Primary action / accents.
  static const Color brass = Color(0xFFC4A76C);

  /// Text drawn on top of [brass].
  static const Color onBrass = Color(0xFF12241C);

  /// Price up, completed.
  static const Color gain = Color(0xFF7BE0B0);

  /// Price down, errors.
  static const Color loss = Color(0xFFFF8A80);

  /// Pending / caution (e.g. an order waiting on the broker).
  static const Color warning = Color(0xFFFFB86B);

  /// Dark overlay behind modals and splash transitions.
  static const Color scrim = Color(0xB80A1812);
}
