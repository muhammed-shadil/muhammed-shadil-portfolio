import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/responsive/responsive.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../widgets/brand_icons.dart';

/// A small glass badge that bobs on its own sine cycle.
///
/// [phase] offsets the cycle so a cluster of badges never moves in lockstep.
class FloatingBadge extends StatelessWidget {
  const FloatingBadge({
    super.key,
    required this.time,
    required this.phase,
    required this.accent,
    required this.child,
    this.label,
    this.amplitude = 9,
    this.parallax = Offset.zero,
  });

  /// Shared 0–1 clock from the hero's single ticker.
  final double time;
  final double phase;
  final Color accent;
  final Widget child;
  final String? label;
  final double amplitude;

  /// Pointer-driven offset, already scaled by the caller.
  final Offset parallax;

  @override
  Widget build(BuildContext context) {
    final angle = (time + phase) * 2 * math.pi;
    final dy = math.sin(angle) * amplitude;
    final dx = math.cos(angle * 0.7) * amplitude * 0.4;

    return Transform.translate(
      offset: Offset(dx, dy) + parallax,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: label == null ? 12 : 14,
          vertical: 11,
        ),
        decoration: BoxDecoration(
          borderRadius: AppRadii.mdAll,
          color: AppColors.surface.withValues(alpha: 0.72),
          border: Border.all(color: accent.withValues(alpha: 0.32)),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: 0.25),
              blurRadius: 26,
              spreadRadius: -8,
              offset: const Offset(0, 10),
            ),
            const BoxShadow(
              color: Color(0x40000000),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconTheme(
              data: IconThemeData(color: accent, size: 18),
              child: child,
            ),
            if (label != null) ...[
              const SizedBox(width: 9),
              Text(
                label!,
                style: AppText.chip.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 11.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Scatters technology badges around the hero visual.
///
/// Positions are fractional so the cluster scales with whatever box it is
/// given, and the whole thing is hidden below the tablet breakpoint where
/// there simply is not room for it.
class FloatingTechCluster extends StatelessWidget {
  const FloatingTechCluster({
    super.key,
    required this.time,
    required this.pointer,
    required this.child,
  });

  final double time;

  /// Pointer position normalised to -1..1, or zero on touch devices.
  final Offset pointer;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final show = context.screenWidth >= Breakpoints.laptop;

    if (!show) return child;

    // Each badge gets a different parallax depth so the cluster has a sense
    // of layering rather than moving as one flat plane.
    Offset depth(double factor) => pointer * factor;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          top: -22,
          left: -34,
          child: FloatingBadge(
            time: time,
            phase: 0,
            accent: const Color(0xFF54C5F8),
            label: 'Flutter',
            parallax: depth(14),
            child: const BrandIcon(BrandPaths.flutter),
          ),
        ),
        Positioned(
          top: 96,
          right: -40,
          child: FloatingBadge(
            time: time,
            phase: 0.33,
            accent: const Color(0xFF0175C2),
            label: 'Dart',
            parallax: depth(-10),
            child: const BrandIcon(BrandPaths.dart),
          ),
        ),
        Positioned(
          bottom: 64,
          left: -52,
          child: FloatingBadge(
            time: time,
            phase: 0.66,
            accent: const Color(0xFFFFCA28),
            label: 'Firebase',
            parallax: depth(9),
            child: const BrandIcon(BrandPaths.firebase),
          ),
        ),
        Positioned(
          bottom: -18,
          right: 34,
          child: FloatingBadge(
            time: time,
            phase: 0.5,
            accent: AppColors.textSecondary,
            parallax: depth(-13),
            amplitude: 7,
            child: const BrandIcon(BrandPaths.github),
          ),
        ),
        Positioned(
          top: 36,
          right: 76,
          child: FloatingBadge(
            time: time,
            phase: 0.18,
            accent: AppColors.accentAlt,
            amplitude: 6,
            parallax: depth(7),
            child: const Icon(Icons.api_rounded),
          ),
        ),
      ],
    );
  }
}
