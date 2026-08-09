import 'package:flutter/material.dart';

import '../../../../animations/hover_region.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/portfolio_data.dart';
import '../../../../widgets/gradient_text.dart';

/// The wordmark: a gradient monogram tile beside the name, framed by the
/// angle-bracket motif that reads as "developer" without being a cliché logo.
class NavLogo extends StatelessWidget {
  const NavLogo({super.key, this.onTap, this.compact = false});

  final VoidCallback? onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final showName = !compact && context.screenWidth >= 480;

    return HoverRegion(
      onTap: onTap,
      focusable: true,
      semanticLabel: '${PortfolioData.name}, back to top',
      builder: (context, state) {
        final active = state.isActive;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: AppDurations.fast,
              curve: AppCurves.standard,
              width: 38,
              height: 38,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: AppRadii.smAll,
                gradient: AppColors.accentGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withValues(
                      alpha: active ? 0.55 : 0.28,
                    ),
                    blurRadius: active ? 24 : 14,
                    spreadRadius: -4,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Text(
                PortfolioData.initials,
                style: AppText.subtitle.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.4,
                  color: const Color(0xFF0B0716),
                ),
              ),
            ),
            if (showName) ...[
              const SizedBox(width: 12),
              _Bracket(text: '<', active: active),
              const SizedBox(width: 2),
              GradientText(
                PortfolioData.shortName,
                style: AppText.subtitle.copyWith(fontSize: 16),
                gradient: active
                    ? AppColors.accentGradient
                    : const LinearGradient(
                        colors: [AppColors.textPrimary, AppColors.textPrimary],
                      ),
              ),
              const SizedBox(width: 2),
              _Bracket(text: '/>', active: active),
            ],
          ],
        );
      },
    );
  }
}

class _Bracket extends StatelessWidget {
  const _Bracket({required this.text, required this.active});

  final String text;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return AnimatedDefaultTextStyle(
      duration: AppDurations.fast,
      style: AppText.code.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: active ? AppColors.accentAlt : AppColors.textTertiary,
      ),
      child: Text(text),
    );
  }
}
