import 'package:flutter/material.dart';

/// Central colour palette.
///
/// To re-skin the whole site, change [accent] and [accentAlt]. Every gradient,
/// glow, focus ring and hover state derives from those two values.
abstract final class AppColors {
  // ---------------------------------------------------------------- accents
  /// Primary accent — electric violet.
  static const Color accent = Color(0xFF7C5CFF);

  /// Secondary accent — cyan. Used as the far end of every accent gradient.
  static const Color accentAlt = Color(0xFF22D3EE);

  /// Rare third accent, used sparingly for "live"/success signals.
  static const Color accentWarm = Color(0xFFFF7A59);

  // ------------------------------------------------------------- surfaces
  /// Page background. Near-black with a hint of blue so it never looks muddy.
  static const Color background = Color(0xFF08080B);

  /// Slightly raised background used to separate alternating bands.
  static const Color backgroundAlt = Color(0xFF0B0B11);

  /// Base glass surface (drawn over [background] with a blur behind it).
  static const Color surface = Color(0xFF12121A);

  /// A surface one step brighter, for nested cards.
  static const Color surfaceHigh = Color(0xFF1A1A25);

  // ------------------------------------------------------------------ text
  // Contrast against [background]: primary 17.9:1, secondary 8.3:1,
  // tertiary 5.3:1 — all clear of the WCAG AA 4.5:1 threshold for body text.
  // Tertiary in particular cannot go much darker without failing.
  static const Color textPrimary = Color(0xFFF4F4F7);
  static const Color textSecondary = Color(0xFFA6A6B8);
  static const Color textTertiary = Color(0xFF82829A);

  // --------------------------------------------------------------- strokes
  static const Color border = Color(0x14FFFFFF); // 8% white
  static const Color borderStrong = Color(0x24FFFFFF); // 14% white

  // ------------------------------------------------------------- gradients
  /// The signature accent gradient: violet → cyan.
  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, accentAlt],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Softer version for large fills where the full-strength gradient shouts.
  static const LinearGradient accentGradientSoft = LinearGradient(
    colors: [Color(0x337C5CFF), Color(0x3322D3EE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Glass fill — a barely-there vertical sheen that reads as a pane of glass.
  static const LinearGradient glassFill = LinearGradient(
    colors: [Color(0x0DFFFFFF), Color(0x05FFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Hairline highlight along the top edge of a glass card.
  static const LinearGradient glassStroke = LinearGradient(
    colors: [Color(0x2EFFFFFF), Color(0x0AFFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Fades a text block out at the bottom (used behind long descriptions).
  static const LinearGradient fadeOut = LinearGradient(
    colors: [Color(0x00000000), background],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ------------------------------------------------------------- utilities
  /// Accent at a given opacity — shorthand used throughout the widget tree.
  static Color accentOn(double opacity) => accent.withValues(alpha: opacity);

  static Color altOn(double opacity) => accentAlt.withValues(alpha: opacity);

  /// A soft outer glow used on hovered cards and primary buttons.
  static List<BoxShadow> glow({
    Color color = accent,
    double opacity = 0.30,
    double blur = 40,
    double spread = -6,
    Offset offset = const Offset(0, 14),
  }) => [
    BoxShadow(
      color: color.withValues(alpha: opacity),
      blurRadius: blur,
      spreadRadius: spread,
      offset: offset,
    ),
  ];

  /// Neutral elevation shadow for resting cards.
  static const List<BoxShadow> ambientShadow = [
    BoxShadow(color: Color(0x40000000), blurRadius: 30, offset: Offset(0, 16)),
  ];
}
