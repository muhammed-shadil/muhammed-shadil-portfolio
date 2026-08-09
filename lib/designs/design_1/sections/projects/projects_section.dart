import 'package:flutter/material.dart';

import '../../../../animations/hover_region.dart';
import '../../../../animations/reveal.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/launcher.dart';
import '../../../../data/portfolio_data.dart';
import '../../../../models/project.dart';
import '../../../../widgets/buttons.dart';
import '../../../../widgets/responsive_grid.dart';
import '../../../../widgets/section_header.dart';
import '../../../../widgets/section_shell.dart';
import 'project_card.dart';
import 'project_detail_page.dart';

/// Filter presets shown above the grid.
enum _Filter { all, live, platform, source }

extension on _Filter {
  String get label => switch (this) {
    _Filter.all => 'All work',
    _Filter.live => 'Live on stores',
    _Filter.platform => 'Platforms & SaaS',
    _Filter.source => 'Source available',
  };

  bool matches(Project project) => switch (this) {
    _Filter.all => true,
    _Filter.live => project.status == ProjectStatus.live,
    _Filter.platform => const {
      'SaaS platform',
      'Real-time platform',
      'Enterprise',
      'Healthcare',
    }.contains(project.category),
    _Filter.source => project.linkOf(LinkKind.github) != null,
  };
}

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key, this.anchorKey});

  final Key? anchorKey;

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  _Filter _filter = _Filter.all;

  List<Project> get _visible =>
      PortfolioData.projects.where(_filter.matches).toList();

  void _open(Project project) {
    Navigator.of(context).push(ProjectDetailPage.route(project));
  }

  @override
  Widget build(BuildContext context) {
    final projects = _visible;

    return SectionShell(
      anchorKey: widget.anchorKey,
      semanticLabel: 'Projects',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            eyebrow: 'Selected work',
            title: 'Apps people actually use.',
            highlight: 'actually use',
            lead:
                '${PortfolioData.projects.length} projects — most of them live '
                'on the Google Play Store. Open any one for the full case '
                'study.',
            // Points at the GitHub profile rather than a "Play Store profile":
            // there is no verified developer-page URL, and aiming a plural
            // label at one app's listing would misrepresent it.
            trailing: SecondaryButton(
              label: 'More on GitHub',
              icon: Icons.north_east_rounded,
              compact: true,
              onPressed: () => Launcher.open(PortfolioData.githubUrl),
            ),
          ),
          const SizedBox(height: 36),
          Reveal(child: _filters()),
          const SizedBox(height: 28),
          // AnimatedSize keeps the page from jumping when the filter changes
          // the number of rows.
          AnimatedSize(
            duration: AppDurations.medium,
            curve: AppCurves.emphasized,
            alignment: Alignment.topCenter,
            child: projects.isEmpty
                ? _empty(context)
                : _grid(context, projects),
          ),
        ],
      ),
    );
  }

  Widget _filters() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final filter in _Filter.values)
          _FilterChip(
            label: filter.label,
            count: PortfolioData.projects.where(filter.matches).length,
            selected: _filter == filter,
            onTap: () => setState(() => _filter = filter),
          ),
      ],
    );
  }

  Widget _empty(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Center(child: Text('Nothing here yet.', style: AppText.body)),
    );
  }

  Widget _grid(BuildContext context, List<Project> projects) {
    final columns = context.responsive(
      mobile: 1,
      mobileLarge: 1,
      tablet: 2,
      laptop: 2,
      desktop: 3,
    );

    // Featured projects take two columns on wide grids — that asymmetry is
    // what gives the section its bento rhythm instead of a uniform matrix.
    //
    // A featured card is only widened when it starts a row AND something is
    // left to fill the remainder. Without that check three consecutive
    // featured projects each claim a row of their own and leave a third of
    // every row empty.
    final spans = <int>[];
    var used = 0;
    for (var i = 0; i < projects.length; i++) {
      final widen =
          projects[i].featured &&
          columns >= 3 &&
          used == 0 &&
          i < projects.length - 1;
      final span = widen ? 2 : 1;
      spans.add(span);
      used = (used + span) % columns;
    }

    return ResponsiveGrid(
      key: ValueKey(_filter),
      columns: columns,
      spans: spans,
      children: [
        for (var i = 0; i < projects.length; i++)
          Reveal.at(
            i,
            step: const Duration(milliseconds: 70),
            offset: const Offset(0, 34),
            child: ProjectCard(
              project: projects[i],
              wide: spans[i] == 2,
              onOpen: () => _open(projects[i]),
            ),
          ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return HoverRegion(
      onTap: onTap,
      focusable: true,
      semanticLabel: '$label, $count projects',
      builder: (context, state) {
        final active = selected || state.isActive;

        return AnimatedContainer(
          duration: AppDurations.fast,
          curve: AppCurves.standard,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: AppRadii.pill,
            gradient: selected ? AppColors.accentGradient : null,
            color: selected
                ? null
                : Colors.white.withValues(alpha: active ? 0.06 : 0.028),
            border: Border.all(
              color: selected
                  ? Colors.transparent
                  : active
                  ? AppColors.borderStrong
                  : AppColors.border,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.32),
                      blurRadius: 22,
                      spreadRadius: -6,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: AppText.button.copyWith(
                  fontSize: 13,
                  color: selected
                      ? const Color(0xFF0B0716)
                      : active
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$count',
                style: AppText.chip.copyWith(
                  fontSize: 10.5,
                  color: selected
                      ? const Color(0xFF0B0716).withValues(alpha: 0.65)
                      : AppColors.textTertiary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
