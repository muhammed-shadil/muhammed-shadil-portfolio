import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/config/portfolio_config.dart';
import 'data/portfolio_data.dart';
import 'designs/design_registry.dart';
import 'designs/design_switcher.dart';

/// Root widget.
///
/// Owns nothing design-specific: it listens to [DesignController] and rebuilds
/// the theme *and* the page from whichever [PortfolioDesign] is active. Adding
/// a design never touches this file.
class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<PortfolioDesign>(
      valueListenable: DesignController.current,
      builder: (context, design, _) {
        final theme = buildDesignTheme(design);

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: theme.brightness == Brightness.dark
                ? Brightness.light
                : Brightness.dark,
            systemNavigationBarColor: theme.scaffoldBackgroundColor,
          ),
          child: MaterialApp(
            title: PortfolioData.siteTitle,
            debugShowCheckedModeBanner: false,
            theme: theme,
            darkTheme: theme,
            themeMode: ThemeMode.dark,
            scrollBehavior: const _AppScrollBehavior(),
            builder: (context, child) {
              // Clamp text scaling. Honouring it entirely would break the
              // display type at 2x; ignoring it outright is an accessibility
              // failure — so allow a meaningful range.
              final scale = MediaQuery.textScalerOf(
                context,
              ).clamp(minScaleFactor: 0.85, maxScaleFactor: 1.35);

              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaler: scale),
                child: DesignSwitcherOverlay(
                  child: child ?? const SizedBox.shrink(),
                ),
              );
            },
            // Keyed by design so switching disposes the previous tree
            // completely instead of trying to reuse incompatible state.
            home: KeyedSubtree(
              key: ValueKey(design),
              child: buildPortfolio(design),
            ),
          ),
        );
      },
    );
  }
}

/// Enables drag-scrolling with mouse and touch, and drops the overscroll glow —
/// it looks wrong on a website.
class _AppScrollBehavior extends MaterialScrollBehavior {
  const _AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => const {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.stylus,
  };

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) => child;
}
