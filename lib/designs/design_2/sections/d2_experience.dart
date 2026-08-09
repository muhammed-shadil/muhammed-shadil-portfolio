import 'package:flutter/material.dart';

import '../../../animations/reveal.dart';
import '../../../core/responsive/responsive.dart';
import '../../../data/portfolio_data.dart';
import '../../../models/content_models.dart';
import '../theme/design_2_theme.dart';
import '../widgets/d2_primitives.dart';

/// Studio's timeline: a single hairline spine with year markers.
///
/// Everything is expanded — Design 1 makes each role a collapsible card, but
/// Studio's editorial voice wants the whole story readable in one pass.
class D2Experience extends StatelessWidget {
  const D2Experience({super.key, this.anchorKey});

  final Key? anchorKey;

  @override
  Widget build(BuildContext context) {
    const items = PortfolioData.experience;

    return D2Section(
      anchorKey: anchorKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          D2SectionHeader(
            number: '04',
            eyebrow: 'Experience',
            title: 'The path so far.',
          ),
          const SizedBox(height: 64),
          for (var i = 0; i < items.length; i++)
            Reveal.at(
              i,
              step: const Duration(milliseconds: 120),
              child: _Entry(item: items[i], isLast: i == items.length - 1),
            ),
          const SizedBox(height: 56),
          Reveal(child: const _EducationRow()),
        ],
      ),
    );
  }
}

class _Entry extends StatelessWidget {
  const _Entry({required this.item, required this.isLast});

  final ExperienceItem item;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final wide = context.screenWidth >= 860;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Spine
          SizedBox(
            width: wide ? 150 : 34,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (wide)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2, right: 20),
                      child: Text(
                        item.period,
                        textAlign: TextAlign.right,
                        style: D2.label.copyWith(
                          fontSize: 10,
                          letterSpacing: 1.4,
                          color: item.current ? D2.accent : D2.inkFaint,
                        ),
                      ),
                    ),
                  ),
                Column(
                  children: [
                    Container(
                      width: 11,
                      height: 11,
                      margin: const EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: item.current ? D2.accent : D2.bg,
                        border: Border.all(
                          color: item.current ? D2.accent : D2.lineStrong,
                          width: 1.5,
                        ),
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 1,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          color: D2.line,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 52),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!wide) ...[
                    Text(
                      item.period,
                      style: D2.label.copyWith(
                        fontSize: 10,
                        color: item.current ? D2.accent : D2.inkFaint,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                  Text(item.role, style: D2.cardTitle(context)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          item.company,
                          style: const TextStyle(
                            fontFamily: D2.body,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: D2.accent,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text('  ·  ${item.location}', style: D2.small),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(item.summary, style: D2.bodyText),
                  const SizedBox(height: 20),
                  for (final highlight in item.highlights)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 4,
                            height: 4,
                            margin: const EdgeInsets.only(top: 9, right: 12),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: D2.inkFaint,
                            ),
                          ),
                          Expanded(child: Text(highlight, style: D2.small)),
                        ],
                      ),
                    ),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final tech in item.tech) D2Tag(tech, dense: true),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EducationRow extends StatelessWidget {
  const _EducationRow();

  @override
  Widget build(BuildContext context) {
    final wide = context.screenWidth >= 760;

    return Container(
      padding: const EdgeInsets.only(top: 40),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: D2.line)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const D2Eyebrow('Education'),
          const SizedBox(height: 26),
          Wrap(
            spacing: 40,
            runSpacing: 24,
            children: [
              for (final item in PortfolioData.education)
                SizedBox(
                  width: wide ? 320 : double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: D2.subtitle.copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${item.institution}  ·  ${item.period}',
                        style: D2.small.copyWith(color: D2.inkFaint),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
