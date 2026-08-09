import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../animations/hover_region.dart';
import '../../../animations/reveal.dart';
import '../../../core/responsive/responsive.dart';
import '../../../data/portfolio_data.dart';
import '../../../models/content_models.dart';
import '../theme/design_2_theme.dart';
import '../widgets/d2_primitives.dart';

/// A skill paired with the category it belongs to.
///
/// The data model has no per-skill description, so hovering surfaces the
/// *category's* blurb instead of inventing copy — truthful, and it teaches the
/// visitor how the stack is organised.
class _Node {
  const _Node(this.skill, this.category);
  final Skill skill;
  final SkillCategory category;
}

/// Studio's skills section: an interactive technology ecosystem.
///
/// Desktop arranges every technology on two rings around a detail panel.
/// Below 1040px that becomes grouped columns — a ring of 34 tap targets on a
/// phone would be unusable, so the layout changes rather than merely scaling.
class D2Skills extends StatefulWidget {
  const D2Skills({super.key, this.anchorKey});

  final Key? anchorKey;

  @override
  State<D2Skills> createState() => _D2SkillsState();
}

class _D2SkillsState extends State<D2Skills> {
  _Node? _active;

  List<_Node> get _nodes => [
    for (final category in PortfolioData.skillCategories)
      for (final skill in category.skills) _Node(skill, category),
  ];

  @override
  Widget build(BuildContext context) {
    final radial = context.screenWidth >= 1040;

    return D2Section(
      anchorKey: widget.anchorKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          D2SectionHeader(
            number: '02',
            eyebrow: 'Capabilities',
            title: 'An ecosystem, not a list.',
            lead:
                'Everything here has shipped in a production application. '
                'Hover a technology to see where it sits in the stack.',
          ),
          const SizedBox(height: 64),
          Reveal(
            child: radial
                ? _RadialEcosystem(
                    nodes: _nodes,
                    active: _active,
                    onHover: (node) => setState(() => _active = node),
                  )
                : _GroupedColumns(
                    active: _active,
                    onTap: (node) =>
                        setState(() => _active = _active == node ? null : node),
                  ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------- desktop
class _RadialEcosystem extends StatelessWidget {
  const _RadialEcosystem({
    required this.nodes,
    required this.active,
    required this.onHover,
  });

  final List<_Node> nodes;
  final _Node? active;
  final ValueChanged<_Node?> onHover;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = math.min(constraints.maxWidth, 900.0);
        final centre = Offset(size / 2, size / 2);

        // Two rings: the inner one carries fewer nodes so the centre panel
        // stays readable through the gaps.
        final inner = nodes.take(nodes.length ~/ 3).toList();
        final outer = nodes.skip(nodes.length ~/ 3).toList();

        return Center(
          child: SizedBox(
            width: size,
            height: size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Guide rings, drawn once and never repainted.
                RepaintBoundary(
                  child: CustomPaint(
                    size: Size(size, size),
                    painter: _RingPainter(radii: [size * 0.27, size * 0.42]),
                  ),
                ),
                _CentrePanel(active: active),
                ..._place(inner, centre, size * 0.27),
                ..._place(outer, centre, size * 0.42),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _place(List<_Node> list, Offset centre, double radius) {
    return [
      for (var i = 0; i < list.length; i++)
        () {
          // -pi/2 starts the ring at twelve o'clock.
          final angle = -math.pi / 2 + (i / list.length) * 2 * math.pi;
          final position = Offset(
            centre.dx + math.cos(angle) * radius,
            centre.dy + math.sin(angle) * radius,
          );
          final node = list[i];

          return Positioned(
            left: position.dx,
            top: position.dy,
            child: FractionalTranslation(
              translation: const Offset(-0.5, -0.5),
              child: _SkillNode(
                node: node,
                active: active == node,
                dimmed: active != null && active != node,
                onHover: onHover,
              ),
            ),
          );
        }(),
    ];
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({required this.radii});
  final List<double> radii;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = D2.ink.withValues(alpha: 0.05);
    for (final r in radii) {
      canvas.drawCircle(size.center(Offset.zero), r, paint);
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.radii != radii;
}

class _SkillNode extends StatelessWidget {
  const _SkillNode({
    required this.node,
    required this.active,
    required this.dimmed,
    required this.onHover,
  });

  final _Node node;
  final bool active;
  final bool dimmed;
  final ValueChanged<_Node?> onHover;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => onHover(node),
      onExit: (_) => onHover(null),
      child: AnimatedOpacity(
        duration: D2.fast,
        opacity: dimmed ? 0.32 : 1,
        child: AnimatedContainer(
          duration: D2.fast,
          curve: D2.ease,
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
          transform: Matrix4.diagonal3Values(
            active ? 1.1 : 1,
            active ? 1.1 : 1,
            1,
          ),
          transformAlignment: Alignment.center,
          decoration: BoxDecoration(
            color: active
                ? node.category.accent.withValues(alpha: 0.16)
                : D2.surface,
            borderRadius: D2.pill,
            border: Border.all(
              color: active
                  ? node.category.accent.withValues(alpha: 0.8)
                  : D2.line,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: node.category.accent,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                node.skill.name,
                style: TextStyle(
                  fontFamily: D2.body,
                  fontSize: 12.5,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                  color: active ? D2.ink : D2.inkMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CentrePanel extends StatelessWidget {
  const _CentrePanel({required this.active});
  final _Node? active;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: AnimatedSwitcher(
        duration: D2.fast,
        child: active == null
            ? const _CentreIdle(key: ValueKey('idle'))
            : Column(
                key: ValueKey(active!.skill.name),
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    active!.category.title.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: D2.label.copyWith(
                      color: active!.category.accent,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    active!.skill.name,
                    textAlign: TextAlign.center,
                    style: D2.cardTitle(context),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    active!.category.blurb,
                    textAlign: TextAlign.center,
                    style: D2.small,
                  ),
                ],
              ),
      ),
    );
  }
}

class _CentreIdle extends StatelessWidget {
  const _CentreIdle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${PortfolioData.skillCategories.fold<int>(0, (sum, c) => sum + c.skills.length)}',
          style: D2.statNumber(context),
        ),
        const SizedBox(height: 10),
        Text('TECHNOLOGIES', style: D2.label.copyWith(fontSize: 10)),
        const SizedBox(height: 14),
        Text(
          'across ${PortfolioData.skillCategories.length} areas of the stack',
          textAlign: TextAlign.center,
          style: D2.small.copyWith(color: D2.inkFaint),
        ),
      ],
    );
  }
}

// ----------------------------------------------------------------- narrow
class _GroupedColumns extends StatelessWidget {
  const _GroupedColumns({required this.active, required this.onTap});

  final _Node? active;
  final ValueChanged<_Node> onTap;

  @override
  Widget build(BuildContext context) {
    final twoUp = context.screenWidth >= 700;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = twoUp
            ? (constraints.maxWidth - 24) / 2
            : constraints.maxWidth;

        return Wrap(
          spacing: 24,
          runSpacing: 32,
          children: [
            for (final category in PortfolioData.skillCategories)
              SizedBox(
                width: width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: category.accent,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            category.title,
                            style: D2.subtitle.copyWith(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(category.blurb, style: D2.small),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final skill in category.skills)
                          HoverRegion(
                            onTap: () => onTap(_Node(skill, category)),
                            builder: (context, state) => AnimatedContainer(
                              duration: D2.fast,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: D2.pill,
                                color: state.isActive
                                    ? category.accent.withValues(alpha: 0.14)
                                    : D2.surface,
                                border: Border.all(
                                  color: state.isActive
                                      ? category.accent.withValues(alpha: 0.6)
                                      : D2.line,
                                ),
                              ),
                              child: Text(
                                skill.name,
                                style: TextStyle(
                                  fontFamily: D2.body,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w500,
                                  color: state.isActive ? D2.ink : D2.inkMuted,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
