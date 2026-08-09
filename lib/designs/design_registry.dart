import 'package:flutter/material.dart';

import '../core/config/portfolio_config.dart';
import '../core/theme/app_theme.dart';
import 'design_1/design_1_portfolio.dart';
import 'design_2/design_2_portfolio.dart';
import 'design_2/theme/design_2_theme.dart';
import 'design_3/design_3_portfolio.dart';
import 'design_3/theme/design_3_theme.dart';

/// Everything the app needs to know about a design, in one place.
///
/// The registry is the only file that has to change when a design is added,
/// which is what keeps `main.dart`, `app.dart` and the switcher untouched as
/// the set grows.
@immutable
class DesignMeta {
  const DesignMeta({
    required this.id,
    required this.label,
    required this.tagline,
    required this.swatch,
    required this.themeBuilder,
    required this.builder,
  });

  final PortfolioDesign id;

  /// Short name shown in the development switcher.
  final String label;

  /// One-line description of the visual language.
  final String tagline;

  /// Representative colour, used as the switcher's dot.
  final Color swatch;

  /// Each design owns its own [ThemeData]; they deliberately do not share one.
  final ThemeData Function() themeBuilder;

  final Widget Function() builder;
}

/// The registry. Order here is the order shown in the switcher.
const List<PortfolioDesign> designOrder = PortfolioDesign.values;

DesignMeta designMetaOf(PortfolioDesign design) => switch (design) {
  PortfolioDesign.design1 => DesignMeta(
    id: PortfolioDesign.design1,
    label: 'Aurora',
    tagline: 'Dark glass · violet to cyan',
    swatch: const Color(0xFF7C5CFF),
    themeBuilder: () => AppTheme.dark,
    builder: () => const Design1Portfolio(),
  ),
  PortfolioDesign.design2 => DesignMeta(
    id: PortfolioDesign.design2,
    label: 'Studio',
    tagline: 'Warm monochrome · oversized type',
    swatch: const Color(0xFFFF7A45),
    themeBuilder: Design2Theme.build,
    builder: () => const Design2Portfolio(),
  ),
  PortfolioDesign.design3 => DesignMeta(
    id: PortfolioDesign.design3,
    label: 'Index',
    tagline: 'Editorial serif · terminal detail',
    swatch: const Color(0xFFE8E4DA),
    themeBuilder: Design3Theme.build,
    builder: () => const Design3Portfolio(),
  ),
};

/// Builds the portfolio for [design].
///
/// This is the single dispatch point the whole app funnels through.
Widget buildPortfolio(PortfolioDesign design) => designMetaOf(design).builder();

/// The [ThemeData] for [design].
ThemeData buildDesignTheme(PortfolioDesign design) =>
    designMetaOf(design).themeBuilder();
