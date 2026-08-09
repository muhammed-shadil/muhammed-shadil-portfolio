import 'dart:ui';

import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
import '../core/theme/app_colors.dart';

/// The project's base surface: a translucent fill inside a 1px gradient
/// hairline, optionally lit by an accent glow.
///
/// [blur] defaults to 0 because `BackdropFilter` is the single most expensive
/// effect on Flutter Web — it is opted into only where the frosting is
/// actually visible (the nav bar and the hero terminal), never on the dozens
/// of cards in a grid.
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.borderRadius = AppRadii.lgAll,
    this.accent,
    this.glowStrength = 0,
    this.fillOpacity = 1,
    this.borderOpacity = 1,
    this.blur = 0,
    this.width,
    this.height,
    this.margin,
    this.clip = true,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;

  /// Tints the fill, the hairline and the glow. Falls back to neutral white.
  final Color? accent;

  /// 0 = flat, 1 = full hover glow. Animate this to light a card up.
  final double glowStrength;

  final double fillOpacity;
  final double borderOpacity;
  final double blur;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final bool clip;

  @override
  Widget build(BuildContext context) {
    final tint = accent ?? AppColors.accent;
    final t = glowStrength.clamp(0.0, 1.0);

    Widget content = Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          // The tint targets are deliberately low: on a small card 12% reads
          // as a hint of colour, but across a 800px-wide project tile the same
          // value reads as a solid block of paint.
          colors: [
            Color.lerp(
              Colors.white.withValues(alpha: 0.055 * fillOpacity),
              tint.withValues(alpha: 0.075),
              t * 0.9,
            )!,
            Color.lerp(
              Colors.white.withValues(alpha: 0.022 * fillOpacity),
              tint.withValues(alpha: 0.025),
              t * 0.9,
            )!,
          ],
        ),
      ),
      child: child,
    );

    if (blur > 0) {
      content = ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: content,
        ),
      );
    } else if (clip) {
      content = ClipRRect(borderRadius: borderRadius, child: content);
    }

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        // The hairline is drawn as a gradient-filled 1px inset rather than a
        // flat Border, so the top-left edge catches more "light" than the
        // bottom-right — the detail that sells the glass.
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.lerp(
              Colors.white.withValues(alpha: 0.14 * borderOpacity),
              tint.withValues(alpha: 0.65),
              t,
            )!,
            Color.lerp(
              Colors.white.withValues(alpha: 0.045 * borderOpacity),
              tint.withValues(alpha: 0.16),
              t,
            )!,
          ],
        ),
        boxShadow: [
          const BoxShadow(
            color: Color(0x33000000),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
          if (t > 0.01)
            BoxShadow(
              color: tint.withValues(alpha: 0.28 * t),
              blurRadius: 44,
              spreadRadius: -8,
              offset: const Offset(0, 16),
            ),
        ],
      ),
      padding: const EdgeInsets.all(1),
      child: content,
    );
  }
}

/// A rounded tile filled with an accent gradient at low opacity — used for
/// icon containers throughout the site.
class AccentTile extends StatelessWidget {
  const AccentTile({
    super.key,
    required this.child,
    this.accent = AppColors.accent,
    this.size = 44,
    this.radius = 14,
    this.strength = 1,
  });

  final Widget child;
  final Color accent;
  final double size;
  final double radius;
  final double strength;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.withValues(alpha: 0.28 * strength),
            accent.withValues(alpha: 0.08 * strength),
          ],
        ),
        border: Border.all(color: accent.withValues(alpha: 0.30 * strength)),
      ),
      child: child,
    );
  }
}
