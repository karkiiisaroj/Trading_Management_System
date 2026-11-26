/// Spacing scale (design system: 4 8 12 16 24 32).
abstract final class AppSpacing {
  static const double xs = 4;
  static const double s = 8;
  static const double m = 12;
  static const double l = 16;
  static const double xl = 24;
  static const double xxl = 32;

  /// Standard height for inputs and primary buttons.
  static const double controlHeight = 52;
}

/// Corner radii (design system: 10 14 18 24).
abstract final class AppRadius {
  static const double sm = 10;
  static const double md = 14;
  static const double lg = 18;
  static const double xl = 24;
  static const double pill = 999;
}

/// Width breakpoints shared by every screen.
abstract final class Breakpoints {
  /// From this width up, auth screens use a centred card instead of full bleed.
  static const double card = 600;

  static bool isCard(double width) => width >= card;
}
