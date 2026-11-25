import 'dart:ui' show FontFeature;

import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Font families registered in pubspec.yaml.
abstract final class AppFonts {
  static const String serif = 'CormorantGaramond';
  static const String sans = 'Manrope';
}

/// AARTHA type styles. Cormorant Garamond for display, Manrope for the rest.
abstract final class AppTypography {
  /// Display 40.
  static const TextStyle display = TextStyle(
    fontFamily: AppFonts.serif,
    fontSize: 36,
    fontWeight: FontWeight.w600,
    height: 1.1,
    color: AppColors.text,
  );

  /// Heading 28.
  static const TextStyle heading = TextStyle(
    fontFamily: AppFonts.serif,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.1,
    color: AppColors.text,
  );

  /// Brass italic tagline.
  static const TextStyle tagline = TextStyle(
    fontFamily: AppFonts.serif,
    fontSize: 19,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.italic,
    color: AppColors.brass,
  );

  /// "AARTHA" wordmark.
  static const TextStyle wordmark = TextStyle(
    fontFamily: AppFonts.serif,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: 7.2, // .3em
    height: 1,
    color: AppColors.text,
  );

  /// Small caps line under the wordmark.
  static const TextStyle overline = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 2.2, // .2em
    color: AppColors.muted,
  );

  static const TextStyle body = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.text,
  );

  static const TextStyle bodyMuted = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.muted,
  );

  /// Field labels, helper text.
  static const TextStyle label = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.muted,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.muted,
  );

  static const TextStyle input = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.text,
  );

  static const TextStyle button = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  /// Money and other figures: tabular so digits line up.
  static const TextStyle figures = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.text,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  /// Maps the tokens onto Material's [TextTheme] so stock widgets match.
  static const TextTheme textTheme = TextTheme(
    displayLarge: display,
    headlineLarge: display,
    headlineMedium: heading,
    titleMedium: body,
    bodyLarge: body,
    bodyMedium: body,
    bodySmall: caption,
    labelLarge: button,
    labelMedium: label,
    labelSmall: caption,
  );
}
