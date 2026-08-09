import 'package:flutter/material.dart';

import '../responsive/responsive.dart';
import 'app_colors.dart';

/// Font families. All three are bundled in `assets/fonts` — nothing is fetched
/// at runtime, so first paint never flashes a fallback face.
abstract final class AppFonts {
  static const String display = 'SpaceGrotesk';
  static const String body = 'Inter';
  static const String mono = 'JetBrainsMono';
}

/// The type scale.
///
/// Display sizes are returned by methods that take a [BuildContext] because
/// headline sizes shrink meaningfully between 1920px and 320px; body sizes are
/// constants because they should not.
abstract final class AppText {
  // ------------------------------------------------------------- display
  /// Hero headline. 68 → 34 across the breakpoint range.
  static TextStyle display(BuildContext context) => TextStyle(
    fontFamily: AppFonts.display,
    fontSize: context.responsive(
      mobile: 34,
      mobileLarge: 40,
      tablet: 54,
      laptop: 62,
      desktop: 70,
    ),
    fontWeight: FontWeight.w700,
    height: 1.06,
    letterSpacing: -1.6,
    color: AppColors.textPrimary,
  );

  /// Section headings ("Selected Work", "Experience & Journey").
  static TextStyle headline(BuildContext context) => TextStyle(
    fontFamily: AppFonts.display,
    fontSize: context.responsive(
      mobile: 28,
      mobileLarge: 32,
      tablet: 40,
      laptop: 44,
      desktop: 48,
    ),
    fontWeight: FontWeight.w700,
    height: 1.12,
    letterSpacing: -1.1,
    color: AppColors.textPrimary,
  );

  /// Card and sub-section titles.
  static TextStyle title(BuildContext context) => TextStyle(
    fontFamily: AppFonts.display,
    fontSize: context.responsive(mobile: 20, tablet: 22, laptop: 24),
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
  );

  static const TextStyle subtitle = TextStyle(
    fontFamily: AppFonts.display,
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: -0.2,
    color: AppColors.textPrimary,
  );

  // ---------------------------------------------------------------- body
  /// Lead paragraph under a headline.
  static TextStyle lead(BuildContext context) => TextStyle(
    fontFamily: AppFonts.body,
    fontSize: context.responsive(mobile: 15.5, tablet: 17, laptop: 18),
    fontWeight: FontWeight.w400,
    height: 1.65,
    color: AppColors.textSecondary,
  );

  static const TextStyle body = TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.68,
    color: AppColors.textSecondary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 13.5,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: AppColors.textSecondary,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 12.5,
    fontWeight: FontWeight.w400,
    height: 1.45,
    color: AppColors.textTertiary,
  );

  // -------------------------------------------------------------- accents
  /// Small tracked-out uppercase label — the "eyebrow" above every heading.
  static const TextStyle eyebrow = TextStyle(
    fontFamily: AppFonts.mono,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.2,
    letterSpacing: 2.4,
    color: AppColors.accentAlt,
  );

  static const TextStyle button = TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 14.5,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.1,
    color: AppColors.textPrimary,
  );

  static const TextStyle navItem = TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.2,
    letterSpacing: 0.1,
    color: AppColors.textSecondary,
  );

  static const TextStyle chip = TextStyle(
    fontFamily: AppFonts.mono,
    fontSize: 11.5,
    fontWeight: FontWeight.w500,
    height: 1.2,
    letterSpacing: 0.2,
    color: AppColors.textSecondary,
  );

  static const TextStyle code = TextStyle(
    fontFamily: AppFonts.mono,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.7,
    color: AppColors.textSecondary,
  );

  /// Big animated statistics.
  static TextStyle stat(BuildContext context) => TextStyle(
    fontFamily: AppFonts.display,
    fontSize: context.responsive(mobile: 32, tablet: 38, laptop: 44),
    fontWeight: FontWeight.w700,
    height: 1,
    letterSpacing: -1.5,
    color: AppColors.textPrimary,
  );

  /// Ghosted step numerals in the process section.
  static TextStyle numeral(BuildContext context) => TextStyle(
    fontFamily: AppFonts.display,
    fontSize: context.responsive(mobile: 40, tablet: 48, laptop: 54),
    fontWeight: FontWeight.w700,
    height: 1,
    letterSpacing: -2,
    color: AppColors.textPrimary.withValues(alpha: 0.06),
  );
}
