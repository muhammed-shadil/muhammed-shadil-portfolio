import 'package:flutter/material.dart';

/// Design 3 — "Index".
///
/// Visual thesis: a printed editorial index rendered in a browser. Designs 1
/// and 2 are both dark; Index is *paper* — bone stock, near-black ink, a
/// single electric blue for links and numbering, hairline rules instead of
/// cards, and an Instrument Serif display face set very large.
///
/// One band deliberately inverts to a dark terminal, which is the only place
/// the design goes dark and therefore reads as a deliberate gear-change
/// rather than a theme.
abstract final class D3 {
  // --------------------------------------------------------------- paper
  static const Color paper = Color(0xFFEFEBE2);
  static const Color paperAlt = Color(0xFFE6E1D6);
  static const Color paperDeep = Color(0xFFDCD6C8);

  // ------------------------------------------------------------------ ink
  static const Color ink = Color(0xFF141310);
  static const Color inkMuted = Color(0xFF55504A);
  static const Color inkFaint = Color(0xFF8A8479);

  // -------------------------------------------------------------- accent
  /// Electric blue: used for numbering, links and the single emphasis word.
  static const Color accent = Color(0xFF2039F3);

  // ------------------------------------------------------------ terminal
  static const Color termBg = Color(0xFF121210);
  static const Color termInk = Color(0xFFD9D4C8);
  static const Color termFaint = Color(0xFF6B665C);
  static const Color termGreen = Color(0xFF8BC97A);
  static const Color termBlue = Color(0xFF7FA6FF);
  static const Color termAmber = Color(0xFFE0A458);

  // -------------------------------------------------------------- strokes
  static const Color rule = Color(0x1F141310);
  static const Color ruleStrong = Color(0x40141310);

  // ------------------------------------------------------------ geometry
  static const double maxWidth = 1440;

  // -------------------------------------------------------------- motion
  static const Duration fast = Duration(milliseconds: 220);
  static const Duration medium = Duration(milliseconds: 520);
  static const Curve ease = Cubic(0.16, 1, 0.3, 1);

  // --------------------------------------------------------------- fonts
  static const String display = 'InstrumentSerif';
  static const String body = 'Inter';
  static const String mono = 'JetBrainsMono';

  // ----------------------------------------------------------------- type
  static double _scale(BuildContext context, List<double> steps) {
    final w = MediaQuery.sizeOf(context).width;
    if (w < 480) return steps[0];
    if (w < 760) return steps[1];
    if (w < 1100) return steps[2];
    if (w < 1440) return steps[3];
    return steps[4];
  }

  /// The enormous stacked name in the hero.
  static TextStyle megaTitle(BuildContext context) {
    final size = _scale(context, [52, 78, 108, 140, 164]);
    return TextStyle(
      fontFamily: display,
      fontSize: size,
      height: 0.88,
      fontWeight: FontWeight.w400,
      letterSpacing: -size * 0.02,
      color: ink,
    );
  }

  static TextStyle sectionTitle(BuildContext context) {
    final size = _scale(context, [34, 44, 56, 66, 72]);
    return TextStyle(
      fontFamily: display,
      fontSize: size,
      height: 0.98,
      fontWeight: FontWeight.w400,
      letterSpacing: -size * 0.015,
      color: ink,
    );
  }

  /// Project titles in the work index.
  static TextStyle indexTitle(BuildContext context) {
    final size = _scale(context, [28, 36, 44, 52, 56]);
    return TextStyle(
      fontFamily: display,
      fontSize: size,
      height: 1,
      fontWeight: FontWeight.w400,
      letterSpacing: -size * 0.012,
      color: ink,
    );
  }

  /// Oversized index numerals — the design's structural signature.
  static TextStyle indexNumber(BuildContext context) {
    final size = _scale(context, [22, 26, 30, 34, 36]);
    return TextStyle(
      fontFamily: mono,
      fontSize: size,
      height: 1,
      fontWeight: FontWeight.w400,
      color: accent,
    );
  }

  static TextStyle lead(BuildContext context) => TextStyle(
    fontFamily: body,
    fontSize: MediaQuery.sizeOf(context).width < 760 ? 16 : 18,
    height: 1.66,
    fontWeight: FontWeight.w400,
    color: inkMuted,
  );

  static const TextStyle bodyText = TextStyle(
    fontFamily: body,
    fontSize: 14.5,
    height: 1.7,
    fontWeight: FontWeight.w400,
    color: inkMuted,
  );

  static const TextStyle small = TextStyle(
    fontFamily: body,
    fontSize: 13,
    height: 1.6,
    fontWeight: FontWeight.w400,
    color: inkMuted,
  );

  /// Tracked-out monospace, used for every piece of metadata on the page.
  static const TextStyle label = TextStyle(
    fontFamily: mono,
    fontSize: 10.5,
    height: 1.2,
    fontWeight: FontWeight.w500,
    letterSpacing: 2.4,
    color: inkFaint,
  );

  static const TextStyle monoText = TextStyle(
    fontFamily: mono,
    fontSize: 12.5,
    height: 1.7,
    fontWeight: FontWeight.w400,
    color: inkMuted,
  );

  /// Italic serif pull-quote, the one decorative flourish in the design.
  static TextStyle quote(BuildContext context) => TextStyle(
    fontFamily: display,
    fontSize: MediaQuery.sizeOf(context).width < 760 ? 24 : 34,
    height: 1.28,
    fontStyle: FontStyle.italic,
    color: ink,
  );
}

abstract final class Design3Theme {
  static ThemeData build() {
    // The only light theme of the three. Brightness goes into the scheme
    // constructor, never a copyWith afterwards.
    const scheme = ColorScheme.light(
      primary: D3.accent,
      onPrimary: Colors.white,
      secondary: D3.ink,
      onSecondary: D3.paper,
      surface: D3.paper,
      onSurface: D3.ink,
      surfaceContainerHighest: D3.paperAlt,
      outline: D3.ruleStrong,
      error: Color(0xFFB3261E),
      onError: Colors.white,
    );

    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      scaffoldBackgroundColor: D3.paper,
      canvasColor: D3.paper,
      fontFamily: D3.body,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(
        fontFamily: D3.body,
        bodyColor: D3.inkMuted,
        displayColor: D3.ink,
      ),
      dividerTheme: const DividerThemeData(
        color: D3.rule,
        thickness: 1,
        space: 1,
      ),
      iconTheme: const IconThemeData(color: D3.inkMuted, size: 20),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: D3.ink,
          borderRadius: BorderRadius.circular(4),
        ),
        textStyle: D3.small.copyWith(color: D3.paper, fontSize: 12),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        waitDuration: const Duration(milliseconds: 400),
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.hovered)
              ? D3.accent.withValues(alpha: 0.7)
              : D3.ink.withValues(alpha: 0.22),
        ),
        thickness: const WidgetStatePropertyAll(6),
        radius: const Radius.circular(0),
      ),
    );
  }
}

/// Height of Index's navigation rail at rest.
const double kD3NavHeight = 72;
