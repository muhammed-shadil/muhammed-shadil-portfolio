import 'package:flutter/material.dart';

import '../animations/hover_region.dart';
import '../core/constants/app_constants.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';

/// Small monospaced pill naming a technology.
class TechChip extends StatelessWidget {
  const TechChip(
    this.label, {
    super.key,
    this.accent,
    this.compact = false,
    this.filled = false,
  });

  final String label;
  final Color? accent;
  final bool compact;

  /// Filled chips carry more weight — used for a card's primary stack.
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final tint = accent ?? AppColors.accentAlt;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        borderRadius: AppRadii.smAll,
        color: filled
            ? tint.withValues(alpha: 0.13)
            : Colors.white.withValues(alpha: 0.035),
        border: Border.all(
          color: filled
              ? tint.withValues(alpha: 0.32)
              : Colors.white.withValues(alpha: 0.07),
        ),
      ),
      child: Text(
        label,
        style: AppText.chip.copyWith(
          fontSize: compact ? 10.5 : 11.5,
          color: filled ? tint : AppColors.textSecondary,
        ),
      ),
    );
  }
}

/// Interactive skill pill — scales, glows and brightens its dot on hover.
class SkillPill extends StatelessWidget {
  const SkillPill({super.key, required this.label, required this.accent});

  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return HoverRegion(
      builder: (context, state) {
        final active = state.isHovered;

        return AnimatedContainer(
          duration: AppDurations.fast,
          curve: AppCurves.standard,
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
          transform: Matrix4.diagonal3Values(
            active ? 1.05 : 1.0,
            active ? 1.05 : 1.0,
            1,
          ),
          transformAlignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: AppRadii.pill,
            color: active
                ? accent.withValues(alpha: 0.14)
                : Colors.white.withValues(alpha: 0.035),
            border: Border.all(
              color: active
                  ? accent.withValues(alpha: 0.55)
                  : Colors.white.withValues(alpha: 0.08),
            ),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: accent.withValues(alpha: 0.30),
                      blurRadius: 20,
                      spreadRadius: -6,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: AppDurations.fast,
                width: active ? 7 : 5,
                height: active ? 7 : 5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: active ? accent : accent.withValues(alpha: 0.55),
                  boxShadow: active
                      ? [
                          BoxShadow(
                            color: accent.withValues(alpha: 0.9),
                            blurRadius: 8,
                          ),
                        ]
                      : null,
                ),
              ),
              const SizedBox(width: 9),
              AnimatedDefaultTextStyle(
                duration: AppDurations.fast,
                style: AppText.bodySmall.copyWith(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: active
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                ),
                child: Text(label),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// The tracked-out uppercase label that sits above every section heading.
class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key, this.color, this.showRule = true});

  final String text;
  final Color? color;
  final bool showRule;

  @override
  Widget build(BuildContext context) {
    final tint = color ?? AppColors.accentAlt;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: tint,
            boxShadow: [
              BoxShadow(color: tint.withValues(alpha: 0.8), blurRadius: 10),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Text(text.toUpperCase(), style: AppText.eyebrow.copyWith(color: tint)),
        if (showRule) ...[
          const SizedBox(width: 14),
          SizedBox(
            width: 46,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [tint.withValues(alpha: 0.5), Colors.transparent],
                ),
              ),
              child: const SizedBox(height: 1),
            ),
          ),
        ],
      ],
    );
  }
}

/// Pill badge — "Live on Play Store", "Company project", availability, etc.
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.label,
    this.color = AppColors.accentAlt,
    this.pulse = false,
  });

  final String label;
  final Color color;

  /// Adds a breathing dot — reserved for genuinely live/available states.
  final bool pulse;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: AppRadii.pill,
        color: color.withValues(alpha: 0.10),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (pulse)
            _PulseDot(color: color)
          else
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            ),
          const SizedBox(width: 8),
          Text(label, style: AppText.chip.copyWith(color: color, fontSize: 11)),
        ],
      ),
    );
  }
}

class _PulseDot extends StatefulWidget {
  const _PulseDot({required this.color});

  final Color color;

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 8,
      height: 8,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _controller.value;
          return Stack(
            alignment: Alignment.center,
            children: [
              // Expanding halo that fades as it grows.
              Transform.scale(
                scale: 1 + t * 1.6,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color.withValues(alpha: 0.45 * (1 - t)),
                  ),
                ),
              ),
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
