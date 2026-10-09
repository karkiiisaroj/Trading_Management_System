import 'package:flutter/material.dart';

/// Asset paths. Keep in sync with `pubspec.yaml`.
abstract final class AarthaAssets {
  static const logo = 'assets/images/aartha_logo.png';
}

/// Brand palette taken from the AARTHA UI design.
abstract final class AarthaColors {
  static const forest = Color(0xFF18372B); // page background
  static const forestDeep = Color(0xFF12291F); // brand panel / logo tile
  static const surface = Color(0xFF1F4435); // inputs, tablet card
  static const outline = Color(0xFF34584A); // borders
  static const outlineHover = Color(0xFF4B7A66); // border on hover (desktop)
  static const ivory = Color(0xFFF4F1E9); // primary text
  static const mist = Color(0xFFB5C3B9); // secondary text
  static const mistDim = Color(0xFFA8B6AC); // desktop supporting copy
  static const brass = Color(0xFFC4A76C); // accent / primary button
  static const brassHover = Color(0xFFD3B880);
  static const onBrass = Color(0xFF12241C); // text on brass
  static const error = Color(0xFFE8A598);
}

/// Type styles. Families are declared in `pubspec.yaml`.
abstract final class AarthaType {
  static const display = 'CormorantGaramond'; // 600 / 700, 500 italic
  static const body = 'Manrope'; // 400 / 500 / 600 / 700

  /// "AARTHA" wordmark. [em] is letter-spacing in em (design uses .3).
  static TextStyle wordmark(double size, {double em = 0.3}) => TextStyle(
        fontFamily: display,
        fontSize: size,
        fontWeight: FontWeight.w700,
        letterSpacing: size * em,
        height: 1,
        color: AarthaColors.ivory,
      );

  static TextStyle heading(double size, {double height = 1.1}) => TextStyle(
        fontFamily: display,
        fontSize: size,
        fontWeight: FontWeight.w600,
        height: height,
        color: AarthaColors.ivory,
      );

  static TextStyle tagline(double size) => TextStyle(
        fontFamily: display,
        fontSize: size,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w500,
        color: AarthaColors.brass,
      );

  static const caps = TextStyle(
    fontFamily: body,
    fontSize: 11,
    letterSpacing: 11 * 0.2,
    color: AarthaColors.mist,
  );

  static const label = TextStyle(
    fontFamily: body,
    fontSize: 13,
    color: AarthaColors.mist,
  );

  static const bodyMuted = TextStyle(
    fontFamily: body,
    fontSize: 15,
    height: 1.5,
    color: AarthaColors.mist,
  );

  static const input = TextStyle(
    fontFamily: body,
    fontSize: 15,
    color: AarthaColors.ivory,
  );

  static const small = TextStyle(
    fontFamily: body,
    fontSize: 12,
    color: AarthaColors.mist,
  );
}

/// Which layout to use. Matches the three boards in the design:
/// phone 390x844, tablet 820x1180, desktop 1440x900.
enum FormFactor {
  phone,
  tablet,
  desktop;

  static const double tabletMin = 600;
  static const double desktopMin = 1000;

  static FormFactor fromWidth(double width) {
    if (width >= desktopMin) return FormFactor.desktop;
    if (width >= tabletMin) return FormFactor.tablet;
    return FormFactor.phone;
  }
}

abstract final class AarthaTheme {
  static ThemeData get dark {
    const scheme = ColorScheme.dark(
      primary: AarthaColors.brass,
      onPrimary: AarthaColors.onBrass,
      secondary: AarthaColors.brass,
      surface: AarthaColors.forest,
      onSurface: AarthaColors.ivory,
      error: AarthaColors.error,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AarthaColors.forest,
      fontFamily: AarthaType.body,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AarthaColors.brass,
        selectionColor: AarthaColors.brass.withAlpha(90),
        selectionHandleColor: AarthaColors.brass,
      ),
      // Same look everywhere; hover/focus states are handled per widget.
      visualDensity: VisualDensity.standard,
    );
  }
}
