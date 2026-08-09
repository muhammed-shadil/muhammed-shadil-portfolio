import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/widgets.dart';

import '../constants/app_constants.dart';

/// Named device classes. Breakpoints are chosen to sit between the widths the
/// site is verified against (320 / 375 / 414 / 768 / 1024 / 1440 / 1920).
enum DeviceType { mobile, mobileLarge, tablet, laptop, desktop }

abstract final class Breakpoints {
  static const double mobileLarge = 400;
  static const double tablet = 700;
  static const double laptop = 1024;
  static const double desktop = 1440;
}

extension ResponsiveContext on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  DeviceType get deviceType {
    final w = screenWidth;
    if (w < Breakpoints.mobileLarge) return DeviceType.mobile;
    if (w < Breakpoints.tablet) return DeviceType.mobileLarge;
    if (w < Breakpoints.laptop) return DeviceType.tablet;
    if (w < Breakpoints.desktop) return DeviceType.laptop;
    return DeviceType.desktop;
  }

  /// True below the tablet breakpoint — the point where multi-column layouts
  /// collapse to a single column and the nav becomes a drawer.
  bool get isHandset => screenWidth < Breakpoints.tablet;

  bool get isTablet =>
      screenWidth >= Breakpoints.tablet && screenWidth < Breakpoints.laptop;

  /// True at laptop width and up — where hover, the custom cursor and
  /// two-column layouts are enabled.
  bool get isDesktop => screenWidth >= Breakpoints.laptop;

  /// True when the visitor has a hovering pointer (mouse/trackpad) *and*
  /// enough width for it to matter. Gates the custom cursor and hover-only
  /// affordances. On web `defaultTargetPlatform` reports the underlying OS,
  /// so mobile browsers correctly fall out here.
  bool get hasPointer => switch (defaultTargetPlatform) {
    TargetPlatform.android ||
    TargetPlatform.iOS ||
    TargetPlatform.fuchsia => false,
    _ => screenWidth >= Breakpoints.laptop,
  };

  /// Honour the OS "reduce motion" setting. Every non-essential animation in
  /// the app checks this before running.
  bool get reduceMotion => MediaQuery.disableAnimationsOf(this);

  double get pageGutter => switch (deviceType) {
    DeviceType.mobile || DeviceType.mobileLarge => AppSizes.gutterMobile,
    DeviceType.tablet => AppSizes.gutterTablet,
    _ => AppSizes.gutterDesktop,
  };

  double get sectionGap => switch (deviceType) {
    DeviceType.mobile || DeviceType.mobileLarge => AppSizes.sectionGapMobile,
    DeviceType.tablet => AppSizes.sectionGapTablet,
    _ => AppSizes.sectionGapDesktop,
  };

  /// Pick a value per device class. Unspecified tiers fall back down the
  /// chain, so `responsive(mobile: 1, desktop: 3)` is valid.
  T responsive<T>({
    required T mobile,
    T? mobileLarge,
    T? tablet,
    T? laptop,
    T? desktop,
  }) {
    return switch (deviceType) {
      DeviceType.mobile => mobile,
      DeviceType.mobileLarge => mobileLarge ?? mobile,
      DeviceType.tablet => tablet ?? mobileLarge ?? mobile,
      DeviceType.laptop => laptop ?? tablet ?? mobileLarge ?? mobile,
      DeviceType.desktop =>
        desktop ?? laptop ?? tablet ?? mobileLarge ?? mobile,
    };
  }
}

/// Builder that hands the resolved [DeviceType] to its child. Useful where a
/// layout differs structurally rather than just by a value.
class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({super.key, required this.builder});

  final Widget Function(BuildContext context, DeviceType device) builder;

  @override
  Widget build(BuildContext context) => builder(context, context.deviceType);
}

/// Centres content in a max-width column with the correct page gutters.
class ContentContainer extends StatelessWidget {
  const ContentContainer({
    super.key,
    required this.child,
    this.maxWidth = AppSizes.maxContentWidth,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.pageGutter),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: child,
        ),
      ),
    );
  }
}
