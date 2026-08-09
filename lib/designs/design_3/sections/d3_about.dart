import 'package:flutter/material.dart';

import '../../../animations/animated_counter.dart';
import '../../../animations/reveal.dart';
import '../../../core/responsive/responsive.dart';
import '../../../data/portfolio_data.dart';
import '../../../models/content_models.dart';
import '../theme/design_3_theme.dart';
import '../widgets/d3_primitives.dart';

/// Index's about: a two-column article with a serif pull-quote and a
/// statistics rail set in monospace.
class D3About extends StatelessWidget {
  const D3About({super.key, this.anchorKey});

  final Key? anchorKey;

  @override
  Widget build(BuildContext context) {
    final wide = context.screenWidth >= 900;

    return D3Section(
      anchorKey: anchorKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const D3SectionMark(number: '01', label: 'About'),
          const SizedBox(height: 40),
          if (wide)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 5, child: Reveal(child: _quote(context))),
                const SizedBox(width: 64),
                Expanded(flex: 6, child: _article(context)),
              ],
            )
          else ...[
            Reveal(child: _quote(context)),
            const SizedBox(height: 36),
            _article(context),
          ],
          const SizedBox(height: 64),
          const _StatRail(),
        ],
      ),
    );
  }

  Widget _quote(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(PortfolioData.aboutTitle, style: D3.sectionTitle(context)),
        const SizedBox(height: 28),
        Container(
          padding: const EdgeInsets.only(left: 20),
          decoration: const BoxDecoration(
            border: Border(left: BorderSide(color: D3.accent, width: 2)),
          ),
          child: Text(
            '${PortfolioData.yearsExperience} years of shipping '
            'production Flutter applications.',
            style: D3.quote(context),
          ),
        ),
      ],
    );
  }

  Widget _article(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < PortfolioData.aboutParagraphs.length; i++)
          Reveal.at(
            i,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 22),
              child: Text(
                PortfolioData.aboutParagraphs[i],
                style: D3.lead(context).copyWith(fontSize: 16),
              ),
            ),
          ),
        const SizedBox(height: 14),
        Reveal(
          delay: const Duration(milliseconds: 180),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final capability in PortfolioData.aboutCapabilities)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(border: Border.all(color: D3.rule)),
                  child: Text(
                    capability,
                    style: D3.monoText.copyWith(fontSize: 11, color: D3.ink),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatRail extends StatelessWidget {
  const _StatRail();

  @override
  Widget build(BuildContext context) {
    final columns = context.screenWidth < 640 ? 2 : 4;
    const stats = PortfolioData.stats;

    return Reveal(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const D3Rule(strong: true),
          LayoutBuilder(
            builder: (context, constraints) {
              final cell = constraints.maxWidth / columns;
              return Wrap(
                children: [
                  for (var i = 0; i < stats.length; i++)
                    SizedBox(
                      width: cell,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 26),
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(
                              color: (i + 1) % columns == 0
                                  ? Colors.transparent
                                  : D3.rule,
                            ),
                            bottom: BorderSide(
                              color: columns == 2 && i < 2
                                  ? D3.rule
                                  : Colors.transparent,
                            ),
                          ),
                        ),
                        child: _Stat(stat: stats[i]),
                      ),
                    ),
                ],
              );
            },
          ),
          const D3Rule(strong: true),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.stat});

  final StatItem stat;

  @override
  Widget build(BuildContext context) {
    final size = context.screenWidth < 700 ? 30.0 : 44.0;
    final style = TextStyle(
      fontFamily: D3.display,
      fontSize: size,
      height: 1,
      color: D3.ink,
    );

    return Padding(
      padding: const EdgeInsets.only(right: 14, left: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (stat.isNumeric)
            AnimatedCounter(
              value: stat.value,
              suffix: stat.suffix,
              prefix: stat.prefix,
              style: style,
            )
          else
            Text(stat.text ?? '', style: style.copyWith(fontSize: size * 0.7)),
          const SizedBox(height: 10),
          Text(
            stat.label.toUpperCase(),
            style: D3.label.copyWith(fontSize: 9, letterSpacing: 1.6),
          ),
        ],
      ),
    );
  }
}

/// Experience laid out horizontally on desktop — a filmstrip of roles the
/// visitor drags through — and vertically on handsets, where a horizontal
/// scroll inside a vertical page is a usability trap.
class D3Experience extends StatelessWidget {
  const D3Experience({super.key, this.anchorKey});

  final Key? anchorKey;

  @override
  Widget build(BuildContext context) {
    final horizontal = context.screenWidth >= 1000;
    const items = PortfolioData.experience;

    return D3Section(
      anchorKey: anchorKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const D3SectionMark(number: '03', label: 'Experience'),
          const SizedBox(height: 40),
          Reveal(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    'Where the\nwork happened',
                    style: D3.sectionTitle(context),
                  ),
                ),
                if (horizontal)
                  Row(
                    children: [
                      Text('DRAG', style: D3.label),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 15,
                        color: D3.inkFaint,
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: 44),
          if (horizontal)
            SizedBox(
              height: 470,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.zero,
                itemCount: items.length + 1,
                separatorBuilder: (_, _) => const SizedBox(width: 28),
                itemBuilder: (context, i) => i == items.length
                    ? const _EducationCard()
                    : SizedBox(
                        width: 460,
                        child: _RoleCard(item: items[i], index: i),
                      ),
              ),
            )
          else
            Column(
              children: [
                for (var i = 0; i < items.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Reveal.at(
                      i,
                      child: _RoleCard(item: items[i], index: i),
                    ),
                  ),
                const _EducationCard(),
              ],
            ),
        ],
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({required this.item, required this.index});

  final ExperienceItem item;
  final int index;

  Widget _highlights({required bool scrollable}) {
    final rows = [
      for (final highlight in item.highlights)
        Padding(
          padding: const EdgeInsets.only(bottom: 9),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('—', style: D3.small.copyWith(color: D3.inkFaint)),
              const SizedBox(width: 10),
              Expanded(child: Text(highlight, style: D3.small)),
            ],
          ),
        ),
    ];

    if (scrollable) {
      return ListView(padding: EdgeInsets.zero, children: rows);
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: rows);
  }

  @override
  Widget build(BuildContext context) {
    final horizontal = context.screenWidth >= 1000;

    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: item.current ? D3.paperAlt : Colors.transparent,
        border: Border.all(color: D3.ruleStrong),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                (index + 1).toString().padLeft(2, '0'),
                style: D3.monoText.copyWith(color: D3.accent),
              ),
              const Spacer(),
              if (item.current)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 4,
                  ),
                  color: D3.accent,
                  child: Text(
                    'CURRENT',
                    style: D3.label.copyWith(color: Colors.white, fontSize: 9),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Text(item.period, style: D3.label),
          const SizedBox(height: 12),
          Text(item.role, style: D3.indexTitle(context).copyWith(fontSize: 28)),
          const SizedBox(height: 8),
          Text(
            '${item.company} · ${item.location}',
            style: D3.monoText.copyWith(fontSize: 11.5),
          ),
          const SizedBox(height: 18),
          const D3Rule(),
          const SizedBox(height: 18),
          // In the horizontal filmstrip the card has a fixed height, so the
          // highlights scroll inside it. Stacked vertically the card has no
          // bounded height at all, and an Expanded/ListView there is a layout
          // error rather than a scroll region.
          if (horizontal)
            Expanded(child: _highlights(scrollable: true))
          else
            _highlights(scrollable: false),
        ],
      ),
    );
  }
}

class _EducationCard extends StatelessWidget {
  const _EducationCard();

  @override
  Widget build(BuildContext context) {
    final horizontal = context.screenWidth >= 1000;

    return SizedBox(
      width: horizontal ? 340 : double.infinity,
      child: Container(
        padding: const EdgeInsets.all(26),
        decoration: BoxDecoration(border: Border.all(color: D3.rule)),
        // In the filmstrip the card is a fixed 470px tall and this content is
        // taller than that, so it scrolls inside the card. Stacked vertically
        // there is no height limit and it simply lays out.
        child: SingleChildScrollView(
          physics: horizontal
              ? const ClampingScrollPhysics()
              : const NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('EDUCATION', style: D3.label),
              const SizedBox(height: 24),
              for (final item in PortfolioData.education) ...[
                Text(
                  item.title,
                  style: D3.indexTitle(context).copyWith(fontSize: 22),
                ),
                const SizedBox(height: 6),
                Text(
                  '${item.institution} · ${item.period}',
                  style: D3.monoText.copyWith(fontSize: 11.5),
                ),
                const SizedBox(height: 22),
              ],
              const SizedBox(height: 8),
              Text('ACHIEVEMENTS', style: D3.label),
              const SizedBox(height: 14),
              for (final achievement in PortfolioData.achievements.take(2))
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(achievement, style: D3.small),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
