import 'package:flutter/material.dart';

import '../../../../animations/hover_region.dart';
import '../../../../animations/reveal.dart';
import '../../../../animations/scroll_visibility.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/portfolio_data.dart';
import '../../../../models/content_models.dart';
import '../../../../widgets/glass_card.dart';
import '../../../../widgets/responsive_grid.dart';
import '../../../../widgets/section_header.dart';
import '../../../../widgets/section_shell.dart';

/// "How I build" — four steps joined by a line that draws itself as the
/// section scrolls into view.
class ProcessSection extends StatelessWidget {
  const ProcessSection({super.key});

  @override
  Widget build(BuildContext context) {
    const steps = PortfolioData.process;
    final columns = context.responsive(mobile: 1, tablet: 2, laptop: 4);

    return SectionShell(
      semanticLabel: 'How I build',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            eyebrow: 'Process',
            title: 'How I build.',
            highlight: 'build',
            lead:
                'The same four steps on every project, whether it is a solo '
                'build or a team release.',
          ),
          const SizedBox(height: 56),
          LayoutBuilder(
            builder: (context, constraints) {
              const spacing = 20.0;
              final unit =
                  (constraints.maxWidth - spacing * (columns - 1)) / columns;

              final grid = ResponsiveGrid(
                columns: columns,
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  for (var i = 0; i < steps.length; i++)
                    Reveal.at(
                      i,
                      step: const Duration(milliseconds: 130),
                      child: _StepCard(step: steps[i]),
                    ),
                ],
              );

              // The connecting line only makes sense when all four steps sit
              // on one row; it runs between the centres of the first and last
              // icon tiles.
              if (columns != 4) return grid;

              return Stack(
                children: [
                  Positioned(
                    top: 46,
                    left: unit * 0.5,
                    right: unit * 0.5,
                    child: const _ConnectingLine(),
                  ),
                  grid,
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Gradient rule that animates from left to right when scrolled into view.
class _ConnectingLine extends StatelessWidget {
  const _ConnectingLine();

  @override
  Widget build(BuildContext context) {
    if (context.reduceMotion) {
      return Container(
        height: 1.5,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.accent.withValues(alpha: 0.4),
              AppColors.accentAlt.withValues(alpha: 0.4),
            ],
          ),
        ),
      );
    }

    return OnVisible(
      builder: (context, visible) => TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: visible ? 1 : 0),
        duration: const Duration(milliseconds: 1400),
        curve: AppCurves.emphasized,
        builder: (context, t, _) => Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: t,
            child: Container(
              height: 1.5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.accent.withValues(alpha: 0.15),
                    AppColors.accent.withValues(alpha: 0.55),
                    AppColors.accentAlt.withValues(alpha: 0.55),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({required this.step});

  final ProcessStep step;

  @override
  Widget build(BuildContext context) {
    return HoverLift(
      focusable: false,
      lift: 6,
      builder: (context, state) {
        final active = state.isHovered;

        return GlassCard(
          glowStrength: active ? 0.7 : 0,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  AccentTile(
                    size: 44,
                    strength: active ? 1.6 : 1,
                    child: Icon(
                      step.icon,
                      size: 20,
                      color: active ? AppColors.accentAlt : AppColors.accent,
                    ),
                  ),
                  const Spacer(),
                  Text(step.number, style: AppText.numeral(context)),
                ],
              ),
              const SizedBox(height: 18),
              Text(step.title, style: AppText.subtitle.copyWith(fontSize: 17)),
              const SizedBox(height: 10),
              Text(step.description, style: AppText.bodySmall),
            ],
          ),
        );
      },
    );
  }
}
