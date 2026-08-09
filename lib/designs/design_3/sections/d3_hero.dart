import 'package:flutter/material.dart';

import '../../../core/responsive/responsive.dart';
import '../../../core/utils/launcher.dart';
import '../../../core/utils/section_controller.dart';
import '../../../data/portfolio_data.dart';
import '../theme/design_3_theme.dart';
import '../widgets/d3_primitives.dart';

/// Index's masthead.
///
/// Typography-driven and asymmetric: the name set enormous and stacked, the
/// role beneath it, and a numbered technical panel pinned to the right — the
/// contents page of a printed publication rather than a website hero.
class D3Hero extends StatefulWidget {
  const D3Hero({super.key, this.anchorKey});

  final Key? anchorKey;

  @override
  State<D3Hero> createState() => _D3HeroState();
}

class _D3HeroState extends State<D3Hero> with SingleTickerProviderStateMixin {
  late final AnimationController _entrance = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );

  bool _started = false;

  /// Disciplines listed in the technical panel, derived from the real skill
  /// categories so the panel cannot drift from the rest of the site.
  List<String> get _disciplines => PortfolioData.skillCategories
      .map((c) => c.title.split(' ').first.toUpperCase())
      .toList();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (context.reduceMotion) {
      _entrance.value = 1;
    } else {
      _entrance.forward();
    }
  }

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  Widget _step(int order, Widget child) {
    final start = (order * 0.09).clamp(0.0, 0.7);
    final anim = CurvedAnimation(
      parent: _entrance,
      curve: Interval(start, (start + 0.42).clamp(0.0, 1.0), curve: D3.ease),
    );
    return AnimatedBuilder(
      animation: anim,
      child: child,
      builder: (context, child) => Opacity(
        opacity: anim.value,
        // Rises further than the other designs — a printed page settling.
        child: Transform.translate(
          offset: Offset(0, 30 * (1 - anim.value)),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wide = context.screenWidth >= 1000;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(key: widget.anchorKey, height: 0),
        Padding(
          padding: EdgeInsets.only(
            top: kD3NavHeight + (wide ? 56 : 40),
            bottom: wide ? 72 : 56,
          ),
          child: D3Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _step(0, _topLine(context)),
                SizedBox(height: wide ? 48 : 32),
                _step(1, _name(context)),
                SizedBox(height: wide ? 40 : 28),
                _step(2, const D3Rule(strong: true)),
                SizedBox(height: wide ? 34 : 24),
                if (wide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 6, child: _step(3, _statement(context))),
                      const SizedBox(width: 64),
                      Expanded(flex: 4, child: _step(4, _panel(context))),
                    ],
                  )
                else ...[
                  _step(3, _statement(context)),
                  const SizedBox(height: 40),
                  _step(4, _panel(context)),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _topLine(BuildContext context) {
    // Below 480px there is no room for both labels and the rule between them,
    // so the location is dropped rather than squeezed to an ellipsis.
    final showLocation = context.screenWidth >= 480;

    return Row(
      children: [
        Text('PORTFOLIO', style: D3.label),
        const SizedBox(width: 20),
        const Expanded(child: D3Rule()),
        if (showLocation) ...[
          const SizedBox(width: 20),
          Flexible(
            child: Text(
              PortfolioData.location.toUpperCase(),
              style: D3.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ],
    );
  }

  /// The name, stacked and set as large as the viewport allows.
  Widget _name(BuildContext context) {
    final parts = PortfolioData.name.split(' ');
    final style = D3.megaTitle(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final part in parts)
          Text(part.toUpperCase(), style: style, maxLines: 1),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Flexible(
              child: Text(
                PortfolioData.roleShort.toUpperCase(),
                style: style.copyWith(
                  color: D3.accent,
                  fontStyle: FontStyle.italic,
                ),
                maxLines: 1,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _statement(BuildContext context) {
    final controller = SectionScope.read(context);
    final reduceMotion = context.reduceMotion;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Text(PortfolioData.heroDescription, style: D3.lead(context)),
        ),
        const SizedBox(height: 34),
        Wrap(
          spacing: 14,
          runSpacing: 14,
          children: [
            D3Button(
              label: 'Selected work',
              onPressed: () => controller.scrollTo(
                AppSection.projects,
                reduceMotion: reduceMotion,
              ),
            ),
            D3Button(
              label: 'Resume',
              filled: false,
              icon: Icons.arrow_downward_rounded,
              onPressed: () => Launcher.open(PortfolioData.resumeDownloadUrl),
            ),
          ],
        ),
      ],
    );
  }

  /// `01 / MOBILE`, `02 / WEB` … built from the real skill categories.
  Widget _panel(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('DISCIPLINES', style: D3.label),
        const SizedBox(height: 16),
        for (var i = 0; i < _disciplines.length; i++)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 11),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: D3.rule)),
            ),
            child: Row(
              children: [
                Text(
                  (i + 1).toString().padLeft(2, '0'),
                  style: D3.monoText.copyWith(color: D3.accent, fontSize: 12),
                ),
                const SizedBox(width: 14),
                Text('/', style: D3.monoText.copyWith(color: D3.inkFaint)),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    _disciplines[i],
                    style: D3.monoText.copyWith(
                      color: D3.ink,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        Container(
          padding: const EdgeInsets.only(top: 14),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: D3.rule)),
          ),
          child: Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: D3.accent,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  PortfolioData.availability.toUpperCase(),
                  style: D3.label.copyWith(color: D3.ink),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
