import 'package:flutter/material.dart';

import '../../animations/hover_region.dart';
import '../../animations/reveal.dart';
import '../../core/constants/app_constants.dart';
import '../../core/responsive/responsive.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/launcher.dart';
import '../../data/portfolio_data.dart';
import '../../models/content_models.dart';
import '../../widgets/brand_icons.dart';
import '../../widgets/buttons.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/responsive_grid.dart';
import '../../widgets/section_header.dart';
import '../../widgets/section_shell.dart';
import '../../widgets/tech_chip.dart';
import 'contribution_grid.dart';

/// GitHub-flavoured section: activity graph, public repositories and the
/// day-to-day technology list.
class GithubSection extends StatelessWidget {
  const GithubSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionShell(
      semanticLabel: 'GitHub',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            eyebrow: 'Open source',
            title: PortfolioData.githubTitle,
            highlight: 'build',
            lead: PortfolioData.githubBlurb,
            trailing: SecondaryButton(
              label: '@${PortfolioData.githubHandle}',
              compact: true,
              icon: Icons.north_east_rounded,
              onPressed: () => Launcher.open(PortfolioData.githubUrl),
            ),
          ),
          const SizedBox(height: 48),
          Reveal(child: _activityCard(context)),
          const SizedBox(height: 20),
          _repoGrid(context),
          const SizedBox(height: 20),
          Reveal.at(2, child: _techStrip(context)),
        ],
      ),
    );
  }

  Widget _activityCard(BuildContext context) {
    return GlassCard(
      padding: EdgeInsets.all(context.responsive(mobile: 20.0, laptop: 28.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const BrandIcon(
                BrandPaths.github,
                size: 20,
                color: AppColors.textPrimary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Contribution activity',
                  style: AppText.subtitle.copyWith(fontSize: 15.5),
                ),
              ),
              TextArrowLink(
                label: context.isHandset ? 'GitHub' : 'View on GitHub',
                onPressed: () => Launcher.open(PortfolioData.githubUrl),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const ContributionGrid(),
          const SizedBox(height: 14),
          // Honest labelling: this graph is a stylised stand-in, not scraped
          // contribution counts.
          Text(
            'Illustrative activity pattern — the live graph is on my GitHub '
            'profile.',
            style: AppText.caption.copyWith(fontSize: 11.5),
          ),
        ],
      ),
    );
  }

  Widget _repoGrid(BuildContext context) {
    const repos = PortfolioData.repos;

    return ResponsiveGrid(
      columns: context.responsive(mobile: 1, tablet: 2, laptop: 3),
      children: [
        for (var i = 0; i < repos.length; i++)
          Reveal.at(i, child: _RepoCard(repo: repos[i])),
      ],
    );
  }

  Widget _techStrip(BuildContext context) {
    return GlassCard(
      padding: EdgeInsets.symmetric(
        horizontal: context.responsive(mobile: 20.0, laptop: 28.0),
        vertical: 22,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Eyebrow('Daily drivers', showRule: false),
          const SizedBox(height: 18),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final chip in PortfolioData.techChips) TechChip(chip),
            ],
          ),
        ],
      ),
    );
  }
}

class _RepoCard extends StatelessWidget {
  const _RepoCard({required this.repo});

  final RepoCard repo;

  @override
  Widget build(BuildContext context) {
    return HoverLift(
      onTap: () => Launcher.open(repo.url),
      lift: 5,
      semanticLabel: 'Open ${repo.name} on GitHub',
      builder: (context, state) {
        final active = state.isActive;

        return GlassCard(
          glowStrength: active ? 0.6 : 0,
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.folder_outlined,
                    size: 16,
                    color: active
                        ? AppColors.accentAlt
                        : AppColors.textTertiary,
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      repo.name,
                      style: AppText.subtitle.copyWith(
                        fontSize: 14.5,
                        fontFamily: AppFonts.mono,
                        color: active
                            ? AppColors.accentAlt
                            : AppColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  AnimatedSlide(
                    offset: Offset(active ? 0.25 : 0, active ? -0.25 : 0),
                    duration: AppDurations.fast,
                    child: Icon(
                      Icons.arrow_outward_rounded,
                      size: 14,
                      color: active
                          ? AppColors.accentAlt
                          : AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                repo.description,
                style: AppText.bodySmall,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: repo.languageColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    repo.language,
                    style: AppText.caption.copyWith(fontSize: 11.5),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
