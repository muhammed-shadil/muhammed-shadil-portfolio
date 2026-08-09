import 'package:flutter/widgets.dart';

/// Layout, radius and motion tokens. Nothing in the UI should hard-code a
/// magic number that belongs here.
abstract final class AppSizes {
  /// Maximum width of the readable content column on very wide monitors.
  static const double maxContentWidth = 1240;

  /// Narrower column used for centred prose so lines stay readable.
  static const double maxProseWidth = 720;

  static const double navHeight = 72;
  static const double navHeightCompact = 62;

  // Horizontal page gutters per breakpoint.
  static const double gutterMobile = 20;
  static const double gutterTablet = 40;
  static const double gutterDesktop = 64;

  // Vertical rhythm between sections.
  static const double sectionGapMobile = 88;
  static const double sectionGapTablet = 112;
  static const double sectionGapDesktop = 150;
}

abstract final class AppRadii {
  static const Radius sm = Radius.circular(10);
  static const Radius md = Radius.circular(16);
  static const Radius lg = Radius.circular(24);
  static const Radius xl = Radius.circular(32);

  static const BorderRadius smAll = BorderRadius.all(sm);
  static const BorderRadius mdAll = BorderRadius.all(md);
  static const BorderRadius lgAll = BorderRadius.all(lg);
  static const BorderRadius xlAll = BorderRadius.all(xl);
  static const BorderRadius pill = BorderRadius.all(Radius.circular(999));
}

abstract final class AppDurations {
  static const Duration instant = Duration(milliseconds: 120);
  static const Duration fast = Duration(milliseconds: 220);
  static const Duration medium = Duration(milliseconds: 420);
  static const Duration slow = Duration(milliseconds: 700);
  static const Duration reveal = Duration(milliseconds: 780);

  /// Scroll-to-section animation.
  static const Duration scrollTo = Duration(milliseconds: 820);
}

abstract final class AppCurves {
  /// Main easing — fast out, long settle. Used for reveals and page motion.
  static const Curve emphasized = Cubic(0.16, 1, 0.3, 1);

  /// Short interactions: hover, press, colour changes.
  static const Curve standard = Cubic(0.2, 0, 0, 1);
}
