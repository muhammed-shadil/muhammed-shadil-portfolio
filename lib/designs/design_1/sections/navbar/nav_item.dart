import 'package:flutter/material.dart';

import '../../../../animations/hover_region.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// A single navigation link.
///
/// The active section is marked by a soft pill plus a short gradient rule
/// underneath — legible without relying on colour alone.
class NavItem extends StatelessWidget {
  const NavItem({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return HoverRegion(
      onTap: onTap,
      focusable: true,
      semanticLabel: 'Go to $label section',
      builder: (context, state) {
        final highlighted = active || state.isActive;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: AnimatedContainer(
            duration: AppDurations.fast,
            curve: AppCurves.standard,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              borderRadius: AppRadii.pill,
              color: active
                  ? Colors.white.withValues(alpha: 0.05)
                  : state.isActive
                  ? Colors.white.withValues(alpha: 0.028)
                  : Colors.transparent,
              border: Border.all(
                color: active ? AppColors.border : Colors.transparent,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedDefaultTextStyle(
                  duration: AppDurations.fast,
                  style: AppText.navItem.copyWith(
                    color: highlighted
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                    fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                  ),
                  child: Text(label),
                ),
                const SizedBox(height: 4),
                AnimatedContainer(
                  duration: AppDurations.fast,
                  curve: AppCurves.standard,
                  height: 2,
                  width: active ? 16 : 0,
                  decoration: const BoxDecoration(
                    gradient: AppColors.accentGradient,
                    borderRadius: AppRadii.pill,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
