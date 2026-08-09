import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/theme/app_theme.dart';
import 'data/portfolio_data.dart';
import 'home_page.dart';

/// Root widget.
class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppTheme.overlayStyle,
      child: MaterialApp(
        title: PortfolioData.siteTitle,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        // The site is dark by design; forcing the mode stops a light system
        // preference from half-applying Material defaults.
        themeMode: ThemeMode.dark,
        darkTheme: AppTheme.dark,
        scrollBehavior: const _AppScrollBehavior(),
        builder: (context, child) {
          // Clamp text scaling. Respecting it entirely would break the
          // display type at 2x, but ignoring it outright is an accessibility
          // failure — so allow a meaningful range.
          final scale = MediaQuery.textScalerOf(
            context,
          ).clamp(minScaleFactor: 0.85, maxScaleFactor: 1.35);
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: scale),
            child: child ?? const SizedBox.shrink(),
          );
        },
        home: const HomePage(),
      ),
    );
  }
}

/// Enables drag-scrolling with mouse and touch, and keeps the overscroll glow
/// off — it looks wrong on a website.
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
