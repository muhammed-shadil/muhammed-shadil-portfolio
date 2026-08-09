import 'package:flutter/material.dart';

import '../../../../animations/hover_region.dart';
import '../../../../animations/reveal.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/portfolio_data.dart';
import '../../../../models/content_models.dart';
import '../../../../widgets/glass_card.dart';
import '../../../../widgets/section_header.dart';
import '../../../../widgets/section_shell.dart';
import '../../../../widgets/tech_chip.dart';

/// Interactive career timeline, followed by education and achievements.
class ExperienceSection extends StatefulWidget {
  const ExperienceSection({super.key, this.anchorKey});

  final Key? anchorKey;

  @override
  State<ExperienceSection> createState() => _ExperienceSectionState();
}

class _ExperienceSectionState extends State<ExperienceSection> {
  /// The most recent role starts open; the rest expand on tap.
  int _expanded = 0;

  @override
  Widget build(BuildContext context) {
    const items = PortfolioData.experience;

    return SectionShell(
      anchorKey: widget.anchorKey,
      semanticLabel: 'Experience',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            eyebrow: 'Career',
            title: 'Experience & journey.',
            highlight: 'journey',
            lead:
                'From an internship building Firebase apps to shipping '
                'production releases for a Bengaluru product team.',
          ),
          const SizedBox(height: 52),
          for (var i = 0; i < items.length; i++)
            Reveal.at(
              i,
              step: const Duration(milliseconds: 120),
              child: _TimelineEntry(
                item: items[i],
                isLast: i == items.length - 1,
                expanded: _expanded == i,
                onToggle: () =>
                    setState(() => _expanded = _expanded == i ? -1 : i),
              ),
            ),
          SizedBox(height: context.responsive(mobile: 44.0, laptop: 60.0)),
          const _EducationAndAchievements(),
        ],
      ),
    );
  }
}

class _TimelineEntry extends StatelessWidget {
  const _TimelineEntry({
    required this.item,
    required this.isLast,
    required this.expanded,
    required this.onToggle,
  });

  final ExperienceItem item;
  final bool isLast;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final compact = context.isHandset;
    final railWidth = compact ? 34.0 : 56.0;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: railWidth,
            child: _Rail(current: item.current, isLast: isLast),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 22),
              child: _card(context, compact),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(BuildContext context, bool compact) {
    return HoverRegion(
      onTap: onToggle,
      focusable: true,
      semanticLabel:
          '${item.role} at ${item.company}, ${item.period}. '
          '${expanded ? 'Collapse' : 'Expand'} details.',
      builder: (context, state) {
        final active = state.isActive || expanded;

        return GlassCard(
          glowStrength: active ? 0.5 : 0,
          padding: EdgeInsets.all(compact ? 20 : 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _headerRow(context, compact),
              const SizedBox(height: 14),
              Text(item.summary, style: AppText.bodySmall),
              // Expanding the entry reveals the responsibility list; the
              // collapsed state keeps the timeline scannable.
              AnimatedCrossFade(
                firstChild: const SizedBox(width: double.infinity),
                secondChild: _details(context),
                crossFadeState: expanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: AppDurations.medium,
                sizeCurve: AppCurves.emphasized,
                firstCurve: Curves.easeOut,
                secondCurve: Curves.easeIn,
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 7,
                      runSpacing: 7,
                      children: [
                        for (final tech in item.tech)
                          TechChip(tech, compact: true),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  AnimatedRotation(
                    turns: expanded ? 0.5 : 0,
                    duration: AppDurations.fast,
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20,
                      color: active
                          ? AppColors.accentAlt
                          : AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _headerRow(BuildContext context, bool compact) {
    final title = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(item.role, style: AppText.title(context).copyWith(fontSize: 19)),
        const SizedBox(height: 6),
        Row(
          children: [
            Flexible(
              child: Text(
                item.company,
                style: AppText.bodySmall.copyWith(
                  color: AppColors.accentAlt,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text('  ·  ${item.location}', style: AppText.caption),
          ],
        ),
      ],
    );

    final period = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (item.current) ...[
          const StatusBadge(
            label: 'Current',
            color: Color(0xFF4ADE80),
            pulse: true,
          ),
          const SizedBox(width: 10),
        ],
        Text(
          item.period,
          style: AppText.chip.copyWith(color: AppColors.textTertiary),
        ),
      ],
    );

    if (compact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [period, const SizedBox(height: 12), title],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: title),
        const SizedBox(width: 16),
        period,
      ],
    );
  }

  Widget _details(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          const SizedBox(height: 18),
          for (final highlight in item.highlights)
            Padding(
              padding: const EdgeInsets.only(bottom: 11),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Icon(
                      Icons.chevron_right_rounded,
                      size: 15,
                      color: AppColors.accent,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text(highlight, style: AppText.bodySmall)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// The vertical line and node beside each entry.
class _Rail extends StatelessWidget {
  const _Rail({required this.current, required this.isLast});

  final bool current;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 26),
        Container(
          width: 13,
          height: 13,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: current ? AppColors.accentGradient : null,
            color: current ? null : AppColors.surfaceHigh,
            border: Border.all(
              color: current ? Colors.transparent : AppColors.borderStrong,
              width: 2,
            ),
            boxShadow: current
                ? [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.6),
                      blurRadius: 16,
                      spreadRadius: -2,
                    ),
                  ]
                : null,
          ),
        ),
        if (!isLast)
          Expanded(
            child: Container(
              width: 1.5,
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.accent.withValues(alpha: 0.5),
                    AppColors.border,
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _EducationAndAchievements extends StatelessWidget {
  const _EducationAndAchievements();

  @override
  Widget build(BuildContext context) {
    final isWide = context.screenWidth >= 860;

    final education = Reveal(
      child: GlassCard(
        padding: const EdgeInsets.all(26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Eyebrow('Education', showRule: false),
            const SizedBox(height: 22),
            for (var i = 0; i < PortfolioData.education.length; i++) ...[
              if (i > 0) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
              ],
              _EducationRow(item: PortfolioData.education[i]),
            ],
          ],
        ),
      ),
    );

    final achievements = Reveal(
      delay: const Duration(milliseconds: 120),
      child: GlassCard(
        padding: const EdgeInsets.all(26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Eyebrow('Achievements', showRule: false),
            const SizedBox(height: 22),
            for (final achievement in PortfolioData.achievements)
              Padding(
                padding: const EdgeInsets.only(bottom: 13),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 3),
                      child: Icon(
                        Icons.star_rounded,
                        size: 14,
                        color: AppColors.accentAlt,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(achievement, style: AppText.bodySmall),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );

    if (!isWide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [education, const SizedBox(height: 20), achievements],
      );
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: education),
          const SizedBox(width: 20),
          Expanded(child: achievements),
        ],
      ),
    );
  }
}

class _EducationRow extends StatelessWidget {
  const _EducationRow({required this.item});

  final EducationItem item;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AccentTile(
          size: 38,
          radius: 11,
          child: const Icon(
            Icons.school_rounded,
            size: 17,
            color: AppColors.accent,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.title, style: AppText.subtitle.copyWith(fontSize: 15)),
              const SizedBox(height: 4),
              Text(
                '${item.institution}  ·  ${item.period}',
                style: AppText.caption,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
