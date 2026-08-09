import 'package:flutter/material.dart';

import '../../../animations/animated_counter.dart';
import '../../../animations/reveal.dart';
import '../../../core/responsive/responsive.dart';
import '../../../data/portfolio_data.dart';
import '../../../models/content_models.dart';
import '../theme/design_2_theme.dart';
import '../widgets/d2_primitives.dart';

/// Studio's About: a two-column editorial spread with the statistics laid out
/// as a rule-separated row rather than the card grid Design 1 uses.
class D2About extends StatelessWidget {
  const D2About({super.key, this.anchorKey});

  final Key? anchorKey;

  @override
  Widget build(BuildContext context) {
    final wide = context.screenWidth >= 940;

    return D2Section(
      anchorKey: anchorKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          D2SectionHeader(
            number: '01',
            eyebrow: 'About',
            title: PortfolioData.aboutTitle,
          ),
          const SizedBox(height: 56),
          if (wide)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 6, child: _prose(context)),
                const SizedBox(width: 72),
                Expanded(flex: 5, child: _capabilities(context)),
              ],
            )
          else ...[
            _prose(context),
            const SizedBox(height: 48),
            _capabilities(context),
          ],
          SizedBox(height: wide ? 96 : 64),
          const _StatStrip(),
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
              padding: const EdgeInsets.only(bottom: 24),
              child: Text(
                PortfolioData.aboutParagraphs[i],
                style: D2.lead(context).copyWith(fontSize: 17, height: 1.7),
              ),
            ),
          ),
      ],
    );
  }

  Widget _capabilities(BuildContext context) {
    return Reveal(
      delay: const Duration(milliseconds: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const D2Eyebrow('What I work with'),
          const SizedBox(height: 24),
          for (var i = 0; i < PortfolioData.aboutCapabilities.length; i++)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 13),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: i == PortfolioData.aboutCapabilities.length - 1
                        ? Colors.transparent
                        : D2.line,
                  ),
                ),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 34,
                    child: Text(
                      (i + 1).toString().padLeft(2, '0'),
                      style: D2.label.copyWith(fontSize: 10),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      PortfolioData.aboutCapabilities[i],
                      style: const TextStyle(
                        fontFamily: D2.body,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: D2.ink,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Statistics as a single rule-topped strip of columns.
class _StatStrip extends StatelessWidget {
  const _StatStrip();

  @override
  Widget build(BuildContext context) {
    final w = context.screenWidth;
    final columns = w < 640 ? 2 : 4;
    const stats = PortfolioData.stats;

    return Reveal(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(height: 1, color: D2.lineStrong),
          LayoutBuilder(
            builder: (context, constraints) {
              final cellWidth = constraints.maxWidth / columns;
              return Wrap(
                children: [
                  for (var i = 0; i < stats.length; i++)
                    SizedBox(
                      width: cellWidth,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 34),
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(
                              color: (i + 1) % columns == 0
                                  ? Colors.transparent
                                  : D2.line,
                            ),
                            bottom: BorderSide(
                              color: columns == 2 && i < 2
                                  ? D2.line
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
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (stat.isNumeric)
            AnimatedCounter(
              value: stat.value,
              suffix: stat.suffix,
              prefix: stat.prefix,
              style: D2.statNumber(context),
            )
          else
            Text(
              stat.text ?? '',
              style: D2
                  .statNumber(context)
                  .copyWith(fontSize: context.screenWidth < 700 ? 28 : 38),
            ),
          const SizedBox(height: 12),
          Text(
            stat.label.toUpperCase(),
            style: D2.label.copyWith(fontSize: 9.5, letterSpacing: 1.8),
          ),
        ],
      ),
    );
  }
}
