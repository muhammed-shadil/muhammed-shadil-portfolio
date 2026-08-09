import 'package:flutter/foundation.dart';

/// The available portfolio designs.
///
/// Adding a fourth is three steps and touches nothing that already exists:
///   1. add a value here,
///   2. give it a [DesignMeta] entry in `designs/design_registry.dart`,
///   3. build `designs/design_4/design_4_portfolio.dart`.
///
/// The data layer, models, responsive helpers and animation utilities are
/// shared, so a new design writes UI only — never content.
enum PortfolioDesign {
  /// Dark glass surfaces, violet-to-cyan accents, single scrolling page.
  design1,

  /// Warm monochrome, oversized editorial-sans headings, immersive project
  /// panels. Premium-SaaS restraint.
  design2,

  /// Editorial/terminal hybrid: serif display type, numbered work index,
  /// horizontal scroll, monospace technical detail.
  design3,
}

/// Single place to choose the active design.
///
/// Change [design] and the whole site changes — layout, navigation, type,
/// colour, motion and section order. The content never moves.
abstract final class PortfolioConfig {
  /// THE SWITCH. Set this to design1, design2 or design3.
  static const PortfolioDesign design = PortfolioDesign.design3;

  /// Whether the floating design switcher is available.
  ///
  /// `kDebugMode` is compile-time, so in a `flutter build web --release`
  /// bundle the switcher and its widget tree are tree-shaken away entirely —
  /// visitors can never reach it, and it costs nothing in the shipped app.
  static const bool showDesignSwitcher = kDebugMode;

  /// Allows a design to be forced without editing source, which is handy for
  /// screenshots and for previewing a release build:
  ///
  ///   flutter run -d chrome --dart-define=DESIGN=design3
  ///   flutter build web --release --dart-define=DESIGN=design3
  ///
  /// An unrecognised or absent value falls back to [design].
  static const String _designOverride = String.fromEnvironment('DESIGN');

  /// The design the app should start on, honouring any `--dart-define`.
  static PortfolioDesign get initialDesign {
    if (_designOverride.isEmpty) return design;
    for (final candidate in PortfolioDesign.values) {
      if (candidate.name.toLowerCase() == _designOverride.toLowerCase()) {
        return candidate;
      }
    }
    return design;
  }
}

/// Holds the design currently on screen.
///
/// In release this only ever emits [PortfolioConfig.initialDesign]. In debug
/// the floating switcher writes to it, so designs can be compared live without
/// a hot restart.
abstract final class DesignController {
  static final ValueNotifier<PortfolioDesign> current =
      ValueNotifier<PortfolioDesign>(PortfolioConfig.initialDesign);

  static void select(PortfolioDesign next) {
    if (!PortfolioConfig.showDesignSwitcher) return;
    if (current.value == next) return;
    current.value = next;
  }
}
