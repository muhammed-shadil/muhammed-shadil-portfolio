import 'package:flutter/material.dart';

/// Design 2 — "Studio".
///
/// Visual thesis: warm monochrome, oversized editorial-sans headings, one
/// accent used sparingly. Where Design 1 leans on glass, glow and a cool
/// violet/cyan gradient, Studio leans on *paper*: flat surfaces, hairline
/// rules, generous space and type doing the heavy lifting.
///
/// Deliberately shares nothing with Design 1's palette or type scale.
abstract final class D2 {
  // ------------------------------------------------------------- surfaces
  /// Near-black with a warm cast, so ivory text sits on it without the blue
  /// chill of Design 1's background.
  static const Color bg = Color(0xFF0A0A09);
  static const Color surface = Color(0xFF131211);
  static const Color surfaceHigh = Color(0xFF1B1A18);

  // ----------------------------------------------------------------- ink
  static const Color ink = Color(0xFFFAF8F5); // ivory, not white
  static const Color inkMuted = Color(0xFFA8A29A);
  static const Color inkFaint = Color(0xFF7A756D);

  // -------------------------------------------------------------- accent
  /// One accent only. Restraint is the point — it marks the single most
  /// important thing on any given screen and nothing else.
  static const Color accent = Color(0xFFFF7A45);
  static const Color accentDim = Color(0xFFC75B31);

  /// Used only for genuinely "live" signals.
  static const Color positive = Color(0xFF9BD17F);

  // -------------------------------------------------------------- strokes
  static const Color line = Color(0x14FAF8F5);
  static const Color lineStrong = Color(0x2EFAF8F5);

  // ------------------------------------------------------------ geometry
  static const double maxWidth = 1280;
  static const BorderRadius radius = BorderRadius.all(Radius.circular(18));
  static const BorderRadius radiusSm = BorderRadius.all(Radius.circular(10));
  static const BorderRadius pill = BorderRadius.all(Radius.circular(999));

  // -------------------------------------------------------------- motion
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 480);
  static const Curve ease = Cubic(0.22, 1, 0.36, 1);

  // --------------------------------------------------------------- fonts
  static const String display = 'Manrope';
  static const String body = 'Manrope';
  static const String mono = 'JetBrainsMono';

  // ----------------------------------------------------------------- type
  /// Hero display. Enormous and tightly tracked — the signature of this design.
  static TextStyle hero(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final size = w < 480
        ? 40.0
        : w < 700
        ? 52.0
        : w < 1100
        ? 68.0
        : w < 1440
        ? 82.0
        : 94.0;
    return TextStyle(
      fontFamily: display,
      fontSize: size,
      height: 1.02,
      fontWeight: FontWeight.w800,
      letterSpacing: -size * 0.035,
      color: ink,
    );
  }

  static TextStyle sectionTitle(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final size = w < 480
        ? 30.0
        : w < 700
        ? 38.0
        : w < 1100
        ? 48.0
        : 58.0;
    return TextStyle(
      fontFamily: display,
      fontSize: size,
      height: 1.06,
      fontWeight: FontWeight.w800,
      letterSpacing: -size * 0.032,
      color: ink,
    );
  }

  static TextStyle cardTitle(BuildContext context) => TextStyle(
    fontFamily: display,
    fontSize: MediaQuery.sizeOf(context).width < 700 ? 22 : 27,
    height: 1.12,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.7,
    color: ink,
  );

  static const TextStyle subtitle = TextStyle(
    fontFamily: display,
    fontSize: 17,
    height: 1.3,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    color: ink,
  );

  static TextStyle lead(BuildContext context) => TextStyle(
    fontFamily: body,
    fontSize: MediaQuery.sizeOf(context).width < 700 ? 16 : 18.5,
    height: 1.62,
    fontWeight: FontWeight.w400,
    color: inkMuted,
  );

  static const TextStyle bodyText = TextStyle(
    fontFamily: body,
    fontSize: 15,
    height: 1.68,
    fontWeight: FontWeight.w400,
    color: inkMuted,
  );

  static const TextStyle small = TextStyle(
    fontFamily: body,
    fontSize: 13.5,
    height: 1.55,
    fontWeight: FontWeight.w400,
    color: inkMuted,
  );

  /// Tracked-out monospace label — the recurring structural motif, used for
  /// section numbers, eyebrows, metadata and nav links.
  static const TextStyle label = TextStyle(
    fontFamily: mono,
    fontSize: 11,
    height: 1.2,
    fontWeight: FontWeight.w500,
    letterSpacing: 2.6,
    color: inkFaint,
  );

  static const TextStyle mono13 = TextStyle(
    fontFamily: mono,
    fontSize: 12.5,
    height: 1.6,
    fontWeight: FontWeight.w400,
    color: inkMuted,
  );

  static TextStyle statNumber(BuildContext context) => TextStyle(
    fontFamily: display,
    fontSize: MediaQuery.sizeOf(context).width < 700 ? 38 : 52,
    height: 1,
    fontWeight: FontWeight.w800,
    letterSpacing: -2,
    color: ink,
  );

  /// Oversized ghost numeral behind section headers and project rows.
  static TextStyle ghostNumeral(BuildContext context) => TextStyle(
    fontFamily: display,
    fontSize: MediaQuery.sizeOf(context).width < 700 ? 64 : 108,
    height: 0.9,
    fontWeight: FontWeight.w800,
    letterSpacing: -4,
    color: ink.withValues(alpha: 0.045),
  );
}

abstract final class Design2Theme {
  static ThemeData build() {
    const scheme = ColorScheme.dark(
      primary: D2.accent,
      onPrimary: Color(0xFF1A0B04),
      secondary: D2.ink,
      onSecondary: D2.bg,
      surface: D2.surface,
      onSurface: D2.ink,
      surfaceContainerHighest: D2.surfaceHigh,
      outline: D2.lineStrong,
      error: Color(0xFFE86A5A),
      onError: Color(0xFF1A0505),
    );

    final base = ThemeData(
      useMaterial3: true,
      // Brightness is passed into the scheme rather than patched on after the
      // fact — copyWith would leave onSurface black and render every default
      // Material text black-on-black.
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: D2.bg,
      canvasColor: D2.bg,
      fontFamily: D2.body,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(
        fontFamily: D2.body,
        bodyColor: D2.inkMuted,
        displayColor: D2.ink,
      ),
      dividerTheme: const DividerThemeData(
        color: D2.line,
        thickness: 1,
        space: 1,
      ),
      iconTheme: const IconThemeData(color: D2.inkMuted, size: 20),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: D2.surfaceHigh,
          borderRadius: D2.radiusSm,
          border: Border.all(color: D2.line),
        ),
        textStyle: D2.small.copyWith(color: D2.ink, fontSize: 12),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        waitDuration: const Duration(milliseconds: 400),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: D2.ink.withValues(alpha: 0.03),
        hintStyle: D2.bodyText.copyWith(color: D2.inkFaint),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: _border(D2.line),
        enabledBorder: _border(D2.line),
        focusedBorder: _border(D2.accent, width: 1.4),
        errorBorder: _border(const Color(0xFFE86A5A)),
        focusedErrorBorder: _border(const Color(0xFFE86A5A), width: 1.4),
        errorStyle: D2.small.copyWith(
          color: const Color(0xFFE86A5A),
          fontSize: 12,
        ),
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.hovered)
              ? D2.accent.withValues(alpha: 0.6)
              : D2.ink.withValues(alpha: 0.14),
        ),
        thickness: const WidgetStatePropertyAll(6),
        radius: const Radius.circular(999),
      ),
    );
  }

  static OutlineInputBorder _border(Color color, {double width = 1}) =>
      OutlineInputBorder(
        borderRadius: D2.radiusSm,
        borderSide: BorderSide(color: color, width: width),
      );
}

/// Height of Studio's navigation bar at rest.
///
/// Lives in the theme rather than the nav file so the hero can offset itself
/// by it without importing the nav (which would be a circular import).
const double kD2NavHeight = 76;
const double kD2NavHeightCompact = 64;
