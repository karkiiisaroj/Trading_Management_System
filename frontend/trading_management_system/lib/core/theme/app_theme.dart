import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// The single app theme. Use this in [MaterialApp.theme]; screens should read
/// colours from [AppColors] / styles from [AppTypography], never hard-code.
abstract final class AppTheme {
  static ThemeData get dark {
    const scheme = ColorScheme.dark(
      primary: AppColors.brass,
      onPrimary: AppColors.onBrass,
      secondary: AppColors.gain,
      onSecondary: AppColors.onBrass,
      surface: AppColors.surface,
      onSurface: AppColors.text,
      error: AppColors.loss,
      onError: AppColors.onBrass,
      outline: AppColors.border,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      fontFamily: AppFonts.sans,
      textTheme: AppTypography.textTheme,
      scaffoldBackgroundColor: AppColors.background,
      canvasColor: AppColors.background,
      dividerColor: AppColors.border,
      splashFactory: InkRipple.splashFactory,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.brass,
        selectionColor: AppColors.brass.withValues(alpha: 0.3),
        selectionHandleColor: AppColors.brass,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.deep,
        contentTextStyle: AppTypography.body.copyWith(fontSize: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
    );
  }
}
