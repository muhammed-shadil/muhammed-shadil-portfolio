import 'package:flutter/material.dart';

import '../../../animations/hover_region.dart';
import '../../../animations/reveal.dart';
import '../../../core/responsive/responsive.dart';
import '../../../core/utils/launcher.dart';
import '../../../data/portfolio_data.dart';
import '../../../models/project.dart';
import '../theme/design_3_theme.dart';
import '../widgets/d3_primitives.dart';

/// Index's work section: a numbered contents list.
///
/// Nothing is a card. Each project is a rule-separated row carrying its index
/// number and title; selecting one expands it in place to reveal the plate,
/// the description and the technical credits — the way a catalogue entry
/// opens rather than the way a web card flips.
class D3Work extends StatefulWidget {
  const D3Work({super.key, this.anchorKey});

  final Key? anchorKey;

  @override
  State<D3Work> createState() => _D3WorkState();
}

class _D3WorkState extends State<D3Work> {
  int? _open;

  @override
  Widget build(BuildContext context) {
    const projects = PortfolioData.projects;

    return D3Section(
      anchorKey: widget.anchorKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const D3SectionMark(number: '02', label: 'Selected work'),
          const SizedBox(height: 40),
          Reveal(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    'Index of\nprojects',
                    style: D3.sectionTitle(context),
                  ),
                ),
                if (context.screenWidth >= 700)
                  Text('${projects.length} ENTRIES', style: D3.label),
              ],
            ),
          ),
          const SizedBox(height: 48),
          for (var i = 0; i < projects.length; i++)
            _IndexRow(
              project: projects[i],
              index: i,
              open: _open == i,
              onToggle: () => setState(() => _open = _open == i ? null : i),
            ),
          const D3Rule(strong: true),
        ],
      ),
    );
  }
}

class _IndexRow extends StatelessWidget {
  const _IndexRow({
    required this.project,
    required this.index,
    required this.open,
    required this.onToggle,
  });

  final Project project;
  final int index;
  final bool open;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final wide = context.screenWidth >= 900;

    return HoverRegion(
      onTap: onToggle,
      focusable: true,
      semanticLabel:
          '${project.name}. ${open ? 'Collapse' : 'Expand'} project details.',
      builder: (context, state) {
        final lit = state.isActive || open;

        return AnimatedContainer(
          duration: D3.fast,
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: D3.rule)),
          ),
          // A wash of the project's own colour on hover is the only place
          // Index admits colour into the page body.
          foregroundDecoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                project.accent.withValues(alpha: lit ? 0.05 : 0),
                Colors.transparent,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: wide ? 26 : 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: wide ? 96 : 54,
                      child: Text(
                        (index + 1).toString().padLeft(2, '0'),
                        style: D3
                            .indexNumber(context)
                            .copyWith(color: lit ? D3.accent : D3.inkFaint),
                      ),
                    ),
                    Expanded(
                      child: AnimatedSlide(
                        offset: Offset(lit && wide ? 0.02 : 0, 0),
                        duration: D3.fast,
                        curve: D3.ease,
                        child: Text(
                          project.name,
                          style: D3.indexTitle(context),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    if (wide) ...[
                      SizedBox(
                        width: 190,
                        child: Text(
                          project.category.toUpperCase(),
                          style: D3.label,
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 28),
                      SizedBox(
                        width: 56,
                        child: Text(
                          project.year ?? '',
                          style: D3.label,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                    const SizedBox(width: 20),
                    AnimatedRotation(
                      turns: open ? 0.125 : 0,
                      duration: D3.fast,
                      child: Icon(
                        open ? Icons.add_rounded : Icons.add_rounded,
                        size: 20,
                        color: lit ? D3.accent : D3.inkFaint,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedCrossFade(
                firstChild: const SizedBox(width: double.infinity),
                secondChild: _Expanded(project: project),
                crossFadeState: open
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: D3.medium,
                sizeCurve: D3.ease,
                firstCurve: Curves.easeOut,
                secondCurve: Curves.easeIn,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Expanded extends StatelessWidget {
  const _Expanded({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final wide = context.screenWidth >= 900;

    final plate = _Plate(project: project);
    final details = _Details(project: project);

    return Padding(
      padding: EdgeInsets.only(bottom: wide ? 44 : 32),
      child: wide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 96),
                Expanded(flex: 4, child: plate),
                const SizedBox(width: 48),
                Expanded(flex: 6, child: details),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [plate, const SizedBox(height: 28), details],
            ),
    );
  }
}

/// The "plate": an editorial image block. With no screenshots in the project,
/// this is a composed panel in the app's own colour carrying its launcher
/// icon, captioned like a figure in a printed article.
class _Plate extends StatelessWidget {
  const _Plate({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AspectRatio(
          aspectRatio: 4 / 3,
          child: Container(
            decoration: BoxDecoration(
              color: project.accent.withValues(alpha: 0.10),
              border: Border.all(color: D3.rule),
            ),
            child: Center(
              child: project.screenshots.isNotEmpty
                  ? Image.asset(
                      project.screenshots.first,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _Icon(project: project),
                    )
                  : _Icon(project: project),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'FIG. ${project.id.toUpperCase()} — ${project.tagline}',
          style: D3.label.copyWith(fontSize: 9.5, letterSpacing: 1.4),
          maxLines: 2,
        ),
      ],
    );
  }
}

class _Icon extends StatelessWidget {
  const _Icon({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    const size = 84.0;

    final fallback = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      color: project.accent,
      child: Text(
        project.initials,
        style: const TextStyle(
          fontFamily: D3.mono,
          fontSize: 26,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );

    final url = project.iconUrl;
    if (url == null) return fallback;

    return Image.network(
      url,
      width: size,
      height: size,
      fit: BoxFit.cover,
      semanticLabel: '${project.name} app icon',
      cacheWidth: (size * MediaQuery.devicePixelRatioOf(context)).round(),
      errorBuilder: (_, _, _) => fallback,
      loadingBuilder: (context, child, progress) =>
          progress == null ? child : fallback,
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final link = project.primaryLink;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(project.summary, style: D3.lead(context).copyWith(fontSize: 16)),
        const SizedBox(height: 28),
        D3Meta(label: 'Stack', value: project.tech.join(' · ')),
        if (project.role != null) D3Meta(label: 'Role', value: project.role!),
        D3Meta(label: 'Status', value: project.status.label),
        const SizedBox(height: 18),
        Text('FEATURES', style: D3.label),
        const SizedBox(height: 12),
        for (var i = 0; i < project.features.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 7),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 34,
                  child: Text(
                    (i + 1).toString().padLeft(2, '0'),
                    style: D3.monoText.copyWith(
                      fontSize: 10.5,
                      color: D3.inkFaint,
                    ),
                  ),
                ),
                Expanded(child: Text(project.features[i], style: D3.small)),
              ],
            ),
          ),
        if (link != null) ...[
          const SizedBox(height: 26),
          D3Link(
            label: link.kind == LinkKind.github
                ? 'View source'
                : 'Open on ${link.kind.label}',
            external: true,
            onTap: () => Launcher.open(link.url),
          ),
        ],
      ],
    );
  }
}
