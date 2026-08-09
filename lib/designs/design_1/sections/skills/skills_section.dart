import 'package:flutter/material.dart';

import '../../../../animations/hover_region.dart';
import '../../../../animations/reveal.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/portfolio_data.dart';
import '../../../../models/content_models.dart';
import '../../../../widgets/glass_card.dart';
import '../../../../widgets/responsive_grid.dart';
import '../../../../widgets/section_header.dart';
import '../../../../widgets/section_shell.dart';
import '../../../../widgets/tech_chip.dart';

/// Skills, grouped into cards that light up in their own accent on hover.
class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key, this.anchorKey});

  final Key? anchorKey;

  @override
  Widget build(BuildContext context) {
    const categories = PortfolioData.skillCategories;

    return SectionShell(
      anchorKey: anchorKey,
      semanticLabel: 'Skills',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            eyebrow: 'Skills',
            title: 'The stack I reach for.',
            highlight: 'stack',
            lead:
                'Everything below is something I have used to ship an app to '
                'production, not something I have read about.',
          ),
          const SizedBox(height: 52),
          ResponsiveGrid(
            columns: context.responsive(
              mobile: 1,
              tablet: 2,
              laptop: 2,
              desktop: 3,
            ),
            children: [
              for (var i = 0; i < categories.length; i++)
                Reveal.at(
                  i,
                  step: const Duration(milliseconds: 90),
                  child: _SkillCard(category: categories[i]),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SkillCard extends StatelessWidget {
  const _SkillCard({required this.category});

  final SkillCategory category;

  @override
  Widget build(BuildContext context) {
    return HoverLift(
      focusable: false,
      lift: 5,
      builder: (context, state) {
        final active = state.isHovered;

        return GlassCard(
          accent: category.accent,
          glowStrength: active ? 0.75 : 0,
          padding: const EdgeInsets.all(26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  AnimatedScale(
                    scale: active ? 1.08 : 1,
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                    child: AccentTile(
                      accent: category.accent,
                      size: 46,
                      strength: active ? 1.5 : 1,
                      child: Icon(
                        category.icon,
                        size: 21,
                        color: category.accent,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      category.title,
                      style: AppText.subtitle.copyWith(fontSize: 16.5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                category.blurb,
                style: AppText.bodySmall.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
              const SizedBox(height: 22),
              Wrap(
                spacing: 9,
                runSpacing: 9,
                children: [
                  for (final skill in category.skills)
                    SkillPill(label: skill.name, accent: category.accent),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
