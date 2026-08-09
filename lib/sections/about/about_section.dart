import 'package:flutter/material.dart';

import '../../animations/animated_counter.dart';
import '../../animations/hover_region.dart';
import '../../animations/reveal.dart';
import '../../core/responsive/responsive.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/portfolio_data.dart';
import '../../models/content_models.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/responsive_grid.dart';
import '../../widgets/section_header.dart';
import '../../widgets/section_shell.dart';
import '../../widgets/tech_chip.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key, this.anchorKey});

  final Key? anchorKey;

  @override
  Widget build(BuildContext context) {
    final isWide = context.screenWidth >= 960;

    return SectionShell(
      anchorKey: anchorKey,
      semanticLabel: 'About',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            eyebrow: 'About me',
            title: PortfolioData.aboutTitle,
            highlight: 'real products',
          ),
          const SizedBox(height: 48),
          if (isWide)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 6, child: _prose(context)),
                const SizedBox(width: 64),
                Expanded(flex: 5, child: _capabilities(context)),
              ],
            )
          else ...[
            _prose(context),
            const SizedBox(height: 40),
            _capabilities(context),
          ],
          SizedBox(height: context.responsive(mobile: 48.0, laptop: 64.0)),
          const _StatsRow(),
        ],
      ),
    );
  }

  Widget _prose(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < PortfolioData.aboutParagraphs.length; i++)
          Reveal.at(
            i,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                PortfolioData.aboutParagraphs[i],
                style: AppText.lead(context),
              ),
            ),
          ),
        const SizedBox(height: 12),
        Reveal.at(2, child: const _SignatureCard()),
      ],
    );
  }

  Widget _capabilities(BuildContext context) {
    return Reveal(
      delay: const Duration(milliseconds: 140),
      child: GlassCard(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Eyebrow('What I work with', showRule: false),
            const SizedBox(height: 22),
            Wrap(
              spacing: 12,
              runSpacing: 14,
              children: [
                for (final capability in PortfolioData.aboutCapabilities)
                  SizedBox(
                    width: context.screenWidth < 480 ? double.infinity : 190,
                    child: Row(
                      children: [
                        Container(
                          width: 18,
                          height: 18,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.accentAlt.withValues(alpha: 0.14),
                            border: Border.all(
                              color: AppColors.accentAlt.withValues(
                                alpha: 0.35,
                              ),
                            ),
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            size: 11,
                            color: AppColors.accentAlt,
                          ),
                        ),
                        const SizedBox(width: 11),
                        Expanded(
                          child: Text(
                            capability,
                            style: AppText.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// A quiet card with the role, location and a link-free summary line — gives
/// the prose column a visual base.
class _SignatureCard extends StatelessWidget {
  const _SignatureCard();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
      child: Row(
        children: [
          AccentTile(
            size: 46,
            radius: 14,
            child: const Icon(
              Icons.flutter_dash_rounded,
              color: AppColors.accent,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(PortfolioData.role, style: AppText.subtitle),
                const SizedBox(height: 4),
                Text(
                  '${PortfolioData.location}  ·  ${PortfolioData.yearsExperience} years',
                  style: AppText.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Four counters that animate the first time they scroll into view.
class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    const stats = PortfolioData.stats;

    return ResponsiveGrid(
      columns: context.responsive(mobile: 2, tablet: 2, laptop: 4),
      spacing: 16,
      runSpacing: 16,
      children: [
        for (var i = 0; i < stats.length; i++)
          Reveal.at(i, child: _StatCard(stat: stats[i])),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.stat});

  final StatItem stat;

  @override
  Widget build(BuildContext context) {
    return HoverRegion(
      builder: (context, state) {
        final active = state.isHovered;

        return GlassCard(
          glowStrength: active ? 0.6 : 0,
          padding: EdgeInsets.symmetric(
            horizontal: context.responsive(mobile: 16.0, laptop: 22.0),
            vertical: context.responsive(mobile: 20.0, laptop: 26.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (stat.icon != null) ...[
                Icon(
                  stat.icon,
                  size: 18,
                  color: active ? AppColors.accentAlt : AppColors.textTertiary,
                ),
                const SizedBox(height: 18),
              ],
              if (stat.isNumeric)
                AnimatedCounter(
                  value: stat.value,
                  suffix: stat.suffix,
                  prefix: stat.prefix,
                  style: AppText.stat(context),
                )
              else
                Text(
                  stat.text ?? '',
                  style: AppText.stat(context).copyWith(
                    fontSize: context.responsive(mobile: 26.0, laptop: 34.0),
                  ),
                ),
              const SizedBox(height: 8),
              Text(stat.label, style: AppText.caption),
            ],
          ),
        );
      },
    );
  }
}
