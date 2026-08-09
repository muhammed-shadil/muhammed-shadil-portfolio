import 'package:flutter/material.dart';

import '../animations/hover_region.dart';
import '../core/constants/app_constants.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';

/// Filled gradient button with a glow and a light sweep on hover.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.expand = false,
    this.compact = false,
    this.busy = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expand;
  final bool compact;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !busy;

    return HoverRegion(
      onTap: enabled ? onPressed : null,
      focusable: true,
      semanticLabel: label,
      builder: (context, state) {
        final active = enabled && state.isActive;

        return AnimatedContainer(
          duration: AppDurations.fast,
          curve: AppCurves.standard,
          width: expand ? double.infinity : null,
          height: compact ? 42 : 52,
          padding: EdgeInsets.symmetric(horizontal: compact ? 18 : 26),
          decoration: BoxDecoration(
            borderRadius: AppRadii.pill,
            gradient: AppColors.accentGradient,
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withValues(alpha: active ? 0.48 : 0.26),
                blurRadius: active ? 34 : 20,
                spreadRadius: active ? -2 : -6,
                offset: Offset(0, active ? 12 : 8),
              ),
            ],
          ),
          foregroundDecoration: BoxDecoration(
            borderRadius: AppRadii.pill,
            // Darkens the button while disabled without changing its layout.
            color: enabled
                ? Colors.transparent
                : AppColors.background.withValues(alpha: 0.45),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Sweep of light travelling across the fill on hover.
              if (active)
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: AppRadii.pill,
                    child: _Sweep(),
                  ),
                ),
              Row(
                mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (busy) ...[
                    const SizedBox(
                      width: 15,
                      height: 15,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFF0B0716),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ] else if (icon != null) ...[
                    Icon(icon, size: 17, color: const Color(0xFF0B0716)),
                    const SizedBox(width: 9),
                  ],
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.button.copyWith(
                        color: const Color(0xFF0B0716),
                        fontSize: compact ? 13.5 : 14.5,
                      ),
                    ),
                  ),
                  if (!busy && icon == null) ...[
                    const SizedBox(width: 9),
                    AnimatedSlide(
                      offset: Offset(active ? 0.22 : 0, 0),
                      duration: AppDurations.fast,
                      curve: AppCurves.standard,
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        size: 17,
                        color: Color(0xFF0B0716),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

/// One-shot band of light that crosses the button when it lights up.
class _Sweep extends StatefulWidget {
  @override
  State<_Sweep> createState() => _SweepState();
}

class _SweepState extends State<_Sweep> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = Curves.easeInOut.transform(_controller.value);
        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-2.4 + t * 3.6, -1),
              end: Alignment(-1.6 + t * 3.6, 1),
              colors: const [
                Color(0x00FFFFFF),
                Color(0x59FFFFFF),
                Color(0x00FFFFFF),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Outlined glass button — the quieter partner to [PrimaryButton].
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.expand = false,
    this.compact = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expand;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return HoverRegion(
      onTap: onPressed,
      focusable: true,
      semanticLabel: label,
      builder: (context, state) {
        final active = state.isActive;

        return AnimatedContainer(
          duration: AppDurations.fast,
          curve: AppCurves.standard,
          width: expand ? double.infinity : null,
          height: compact ? 42 : 52,
          padding: EdgeInsets.symmetric(horizontal: compact ? 18 : 24),
          decoration: BoxDecoration(
            borderRadius: AppRadii.pill,
            color: Colors.white.withValues(alpha: active ? 0.07 : 0.03),
            border: Border.all(
              color: active
                  ? AppColors.accentAlt.withValues(alpha: 0.55)
                  : AppColors.borderStrong,
            ),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: AppColors.accentAlt.withValues(alpha: 0.18),
                      blurRadius: 26,
                      spreadRadius: -6,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 17,
                  color: active
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                ),
                const SizedBox(width: 9),
              ],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.button.copyWith(
                    fontSize: compact ? 13.5 : 14.5,
                    color: active
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Square icon button used for social links and the mobile menu toggle.
class IconActionButton extends StatelessWidget {
  const IconActionButton({
    super.key,
    required this.onPressed,
    required this.tooltip,
    this.icon,
    this.child,
    this.size = 44,
    this.accent = AppColors.accent,
  }) : assert(icon != null || child != null, 'Provide an icon or a child.');

  final VoidCallback? onPressed;
  final String tooltip;
  final IconData? icon;
  final Widget? child;
  final double size;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: HoverRegion(
        onTap: onPressed,
        focusable: true,
        semanticLabel: tooltip,
        builder: (context, state) {
          final active = state.isActive;

          return AnimatedContainer(
            duration: AppDurations.fast,
            curve: AppCurves.standard,
            width: size,
            height: size,
            alignment: Alignment.center,
            transform: Matrix4.translationValues(0, active ? -3 : 0, 0),
            transformAlignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: AppRadii.mdAll,
              color: Colors.white.withValues(alpha: active ? 0.08 : 0.03),
              border: Border.all(
                color: active
                    ? accent.withValues(alpha: 0.6)
                    : AppColors.border,
              ),
              boxShadow: active
                  ? [
                      BoxShadow(
                        color: accent.withValues(alpha: 0.3),
                        blurRadius: 22,
                        spreadRadius: -6,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : null,
            ),
            child: IconTheme(
              data: IconThemeData(
                size: size * 0.42,
                color: active ? AppColors.textPrimary : AppColors.textSecondary,
              ),
              child: child ?? Icon(icon),
            ),
          );
        },
      ),
    );
  }
}

/// Small text link with an arrow that slides on hover.
class TextArrowLink extends StatelessWidget {
  const TextArrowLink({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = AppColors.accentAlt,
    this.icon = Icons.arrow_outward_rounded,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return HoverRegion(
      onTap: onPressed,
      focusable: true,
      semanticLabel: label,
      builder: (context, state) {
        final active = state.isActive;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppText.button.copyWith(
                color: active ? color : AppColors.textSecondary,
                decoration: active ? TextDecoration.underline : null,
                decorationColor: color.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(width: 6),
            AnimatedSlide(
              offset: Offset(active ? 0.18 : 0, active ? -0.18 : 0),
              duration: AppDurations.fast,
              curve: AppCurves.standard,
              child: Icon(
                icon,
                size: 15,
                color: active ? color : AppColors.textTertiary,
              ),
            ),
          ],
        );
      },
    );
  }
}
