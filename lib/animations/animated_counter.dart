import 'package:flutter/widgets.dart';

import '../core/constants/app_constants.dart';
import '../core/responsive/responsive.dart';
import 'scroll_visibility.dart';

/// Counts up from zero to [value] the first time it scrolls into view.
///
/// Handles fractional targets (2.5 renders as "2.5") without printing a
/// trailing `.0` on whole numbers.
class AnimatedCounter extends StatelessWidget {
  const AnimatedCounter({
    super.key,
    required this.value,
    required this.style,
    this.prefix = '',
    this.suffix = '',
    this.duration = const Duration(milliseconds: 1600),
    this.textAlign,
  });

  final double value;
  final TextStyle style;
  final String prefix;
  final String suffix;
  final Duration duration;
  final TextAlign? textAlign;

  static String format(double v) {
    // One decimal place only when the value actually has a fraction.
    final isWhole = (v - v.roundToDouble()).abs() < 0.05;
    return isWhole ? v.round().toString() : v.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    if (context.reduceMotion) {
      return Text(
        '$prefix${format(value)}$suffix',
        style: style,
        textAlign: textAlign,
      );
    }

    return OnVisible(
      builder: (context, visible) => TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: visible ? value : 0),
        duration: duration,
        curve: AppCurves.emphasized,
        builder: (context, animated, _) => Text(
          '$prefix${format(animated)}$suffix',
          style: style,
          textAlign: textAlign,
        ),
      ),
    );
  }
}
