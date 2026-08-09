import 'package:flutter/material.dart';

import '../../../animations/hover_region.dart';
import '../../../animations/reveal.dart';
import '../../../core/responsive/responsive.dart';
import '../../../core/utils/launcher.dart';
import '../../../data/portfolio_data.dart';
import '../../../models/project.dart';
import '../theme/design_2_theme.dart';
import '../widgets/d2_primitives.dart';
import '../widgets/d2_project_mockup.dart';

/// Studio's work section: full-width alternating panels.
///
/// Design 1 presents projects as a bento grid of compact cards; Studio gives
/// each project a whole row — mockup on one side, the case for it on the
/// other, sides swapping down the page so the eye zig-zags rather than
/// scanning a column.
class D2Projects extends StatelessWidget {
  const D2Projects({super.key, this.anchorKey});

  final Key? anchorKey;

  @override
  Widget build(BuildContext context) {
    const projects = PortfolioData.projects;

    return D2Section(
      anchorKey: anchorKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          D2SectionHeader(
            number: '03',
            eyebrow: 'Selected work',
            title: 'Things I have shipped.',
            lead:
                '${projects.length} projects, most of them live on the Google '
                'Play Store. Open any one for the full case study.',
            trailing: D2Button(
              label: 'GitHub',
              filled: false,
              compact: true,
              icon: Icons.north_east_rounded,
              onPressed: () => Launcher.open(PortfolioData.githubUrl),
            ),
          ),
          const SizedBox(height: 72),
          for (var i = 0; i < projects.length; i++)
            Padding(
              padding: EdgeInsets.only(
                bottom: i == projects.length - 1 ? 0 : 40,
              ),
              child: Reveal(
                offset: const Offset(0, 44),
                child: _ProjectPanel(
                  project: projects[i],
                  index: i,
                  flipped: i.isOdd,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ProjectPanel extends StatefulWidget {
  const _ProjectPanel({
    required this.project,
    required this.index,
    required this.flipped,
  });

  final Project project;
  final int index;
  final bool flipped;

  @override
  State<_ProjectPanel> createState() => _ProjectPanelState();
}

class _ProjectPanelState extends State<_ProjectPanel> {
  /// Studio expands the case study in place rather than pushing a route.
  /// Design 1 owns the full-screen detail page; repeating it here would drag
  /// Design 1's violet palette into a warm monochrome layout.
  bool _expanded = false;

  Project get project => widget.project;

  @override
  Widget build(BuildContext context) {
    final wide = context.screenWidth >= 1000;

    return HoverRegion(
      onTap: () => setState(() => _expanded = !_expanded),
      focusable: true,
      semanticLabel:
          '${project.name} — ${project.tagline}. '
          '${_expanded ? 'Collapse' : 'Expand'} details.',
      builder: (context, state) {
        final hovered = state.isActive || _expanded;

        return AnimatedContainer(
          duration: D2.medium,
          curve: D2.ease,
          padding: EdgeInsets.all(wide ? 24 : 16),
          decoration: BoxDecoration(
            borderRadius: D2.radius,
            color: hovered ? D2.surface : Colors.transparent,
            border: Border.all(color: hovered ? D2.lineStrong : D2.line),
          ),
          child: wide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: widget.flipped
                      ? [
                          Expanded(flex: 5, child: _copy(context, hovered)),
                          const SizedBox(width: 44),
                          Expanded(
                            flex: 5,
                            child: D2ProjectMockup(
                              project: project,
                              hovered: hovered,
                            ),
                          ),
                        ]
                      : [
                          Expanded(
                            flex: 5,
                            child: D2ProjectMockup(
                              project: project,
                              hovered: hovered,
                            ),
                          ),
                          const SizedBox(width: 44),
                          Expanded(flex: 5, child: _copy(context, hovered)),
                        ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    D2ProjectMockup(
                      project: project,
                      hovered: hovered,
                      height: 330,
                    ),
                    const SizedBox(height: 28),
                    _copy(context, hovered),
                  ],
                ),
        );
      },
    );
  }

  Widget _copy(BuildContext context, bool hovered) {
    final link = project.primaryLink;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              (widget.index + 1).toString().padLeft(2, '0'),
              style: D2.label.copyWith(color: project.accent),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: AnimatedContainer(
                duration: D2.medium,
                curve: D2.ease,
                height: 1,
                margin: EdgeInsets.only(right: hovered ? 0 : 40),
                color: hovered ? project.accent : D2.line,
              ),
            ),
            const SizedBox(width: 14),
            _StatusText(project: project),
          ],
        ),
        const SizedBox(height: 22),
        Text(project.name, style: D2.cardTitle(context).copyWith(fontSize: 34)),
        const SizedBox(height: 10),
        Text(
          project.tagline,
          style: D2.small.copyWith(color: project.accent, fontSize: 14),
        ),
        const SizedBox(height: 18),
        Text(
          project.summary,
          style: D2.bodyText,
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 22),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final tech in project.tech.take(5)) D2Tag(tech),
            if (project.tech.length > 5) D2Tag('+${project.tech.length - 5}'),
          ],
        ),
        // Case study expands in place. Collapsed height stays predictable so
        // the alternating rhythm of the section is not disturbed.
        AnimatedCrossFade(
          firstChild: const SizedBox(width: double.infinity),
          secondChild: _details(context),
          crossFadeState: _expanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: D2.medium,
          sizeCurve: D2.ease,
          firstCurve: Curves.easeOut,
          secondCurve: Curves.easeIn,
        ),
        const SizedBox(height: 26),
        Row(
          children: [
            AnimatedDefaultTextStyle(
              duration: D2.fast,
              style: TextStyle(
                fontFamily: D2.body,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: hovered ? D2.ink : D2.inkMuted,
              ),
              child: Text(_expanded ? 'Show less' : 'View case study'),
            ),
            const SizedBox(width: 8),
            AnimatedSlide(
              offset: Offset(hovered ? 0.35 : 0, 0),
              duration: D2.fast,
              curve: D2.ease,
              child: Icon(
                Icons.arrow_forward_rounded,
                size: 16,
                color: hovered ? project.accent : D2.inkFaint,
              ),
            ),
            const Spacer(),
            if (link != null)
              // Nested tap target: jumps straight to the store or repo.
              HoverRegion(
                onTap: () => Launcher.open(link.url),
                focusable: true,
                semanticLabel: '${project.name} on ${link.kind.label}',
                builder: (context, s) => AnimatedContainer(
                  duration: D2.fast,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: D2.pill,
                    color: s.isActive ? D2.ink : Colors.transparent,
                    border: Border.all(color: s.isActive ? D2.ink : D2.line),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        link.kind.icon,
                        size: 13,
                        color: s.isActive ? D2.bg : D2.inkMuted,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        link.kind.label,
                        style: TextStyle(
                          fontFamily: D2.mono,
                          fontSize: 11,
                          color: s.isActive ? D2.bg : D2.inkMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

extension on _ProjectPanelState {
  /// The expanded case study: features, architecture and outcomes, all read
  /// straight off the shared [Project] model.
  Widget _details(BuildContext context) {
    Widget block(String title, List<String> items, {bool numbered = false}) {
      if (items.isEmpty) return const SizedBox.shrink();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 26),
          Text(title.toUpperCase(), style: D2.label.copyWith(fontSize: 9.5)),
          const SizedBox(height: 14),
          for (var i = 0; i < items.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 26,
                    child: numbered
                        ? Text(
                            (i + 1).toString().padLeft(2, '0'),
                            style: D2.mono13.copyWith(
                              fontSize: 10.5,
                              color: D2.inkFaint,
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: project.accent.withValues(alpha: 0.8),
                              ),
                            ),
                          ),
                  ),
                  Expanded(child: Text(items[i], style: D2.small)),
                ],
              ),
            ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 1, color: D2.line),
          block('Key features', project.features, numbered: true),
          block('Architecture', project.architecture),
          block('Results', project.results),
          if (project.role != null) ...[
            const SizedBox(height: 22),
            Row(
              children: [
                Text('ROLE', style: D2.label.copyWith(fontSize: 9.5)),
                const SizedBox(width: 14),
                Text(project.role!, style: D2.small.copyWith(color: D2.ink)),
                if (project.year != null) ...[
                  const SizedBox(width: 20),
                  Text('YEAR', style: D2.label.copyWith(fontSize: 9.5)),
                  const SizedBox(width: 14),
                  Text(project.year!, style: D2.small.copyWith(color: D2.ink)),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusText extends StatelessWidget {
  const _StatusText({required this.project});
  final Project project;

  @override
  Widget build(BuildContext context) {
    final live = project.status == ProjectStatus.live;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 5,
          height: 5,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: live ? D2.positive : D2.inkFaint,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          project.status.label.toUpperCase(),
          style: D2.label.copyWith(fontSize: 9),
        ),
      ],
    );
  }
}
