import 'package:flutter/material.dart';

import '../animations/hover_region.dart';
import '../core/constants/app_constants.dart';
import '../core/responsive/responsive.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/section_controller.dart';

/// Floating back-to-top control with a ring showing scroll progress.
///
/// Appears once the visitor is a screen or so down the page.
class ScrollToTopButton extends StatelessWidget {
  const ScrollToTopButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SectionScope.read(context);

    return ValueListenableBuilder<double>(
      valueListenable: controller.offset,
      builder: (context, offset, _) {
        final progress = controller.scrollProgress;
        final visible = offset > context.screenHeight * 0.8;

        return IgnorePointer(
          ignoring: !visible,
          child: AnimatedOpacity(
            opacity: visible ? 1 : 0,
            duration: AppDurations.medium,
            child: AnimatedSlide(
              offset: Offset(0, visible ? 0 : 0.4),
              duration: AppDurations.medium,
              curve: AppCurves.emphasized,
              child: HoverRegion(
                onTap: () =>
                    controller.scrollToTop(reduceMotion: context.reduceMotion),
                focusable: true,
                semanticLabel: 'Scroll back to top',
                builder: (context, state) {
                  final active = state.isActive;

                  return SizedBox.square(
                    dimension: 48,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Progress ring.
                        SizedBox.square(
                          dimension: 48,
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 2,
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.07,
                            ),
                            valueColor: AlwaysStoppedAnimation(
                              active
                                  ? AppColors.accentAlt
                                  : AppColors.accent.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                        AnimatedContainer(
                          duration: AppDurations.fast,
                          width: active ? 40 : 38,
                          height: active ? 40 : 38,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.surface.withValues(alpha: 0.9),
                            border: Border.all(color: AppColors.border),
                            boxShadow: active
                                ? [
                                    BoxShadow(
                                      color: AppColors.accent.withValues(
                                        alpha: 0.35,
                                      ),
                                      blurRadius: 22,
                                      spreadRadius: -6,
                                    ),
                                  ]
                                : null,
                          ),
                          child: Icon(
                            Icons.arrow_upward_rounded,
                            size: 17,
                            color: active
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
