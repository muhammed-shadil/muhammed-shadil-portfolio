import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/responsive/responsive.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Levels 0–4, matching the buckets GitHub itself uses.
typedef ContributionWeek = List<int>;

/// Source of the activity grid.
///
/// [sample] is a deterministic, clearly-labelled placeholder — it is NOT real
/// contribution data, and the UI says so. To wire up the real thing, fetch
/// `https://api.github.com/graphql` (contributionsCollection) or any of the
/// public contribution-JSON proxies and map the response into the same
/// `List<ContributionWeek>` shape; nothing else in this file has to change.
abstract final class ContributionData {
  static const int weeks = 52;
  static const int daysPerWeek = 7;

  /// Fixed seed so the pattern is stable across reloads and deploys.
  static List<ContributionWeek> get sample {
    final random = math.Random(77);
    return List.generate(weeks, (week) {
      return List.generate(daysPerWeek, (day) {
        // Weekends are quieter, and activity ramps up over the year — enough
        // structure that it reads as a real working rhythm.
        final weekendPenalty = (day == 0 || day == 6) ? 0.45 : 1.0;
        final ramp = 0.45 + (week / weeks) * 0.55;
        final roll = random.nextDouble() * weekendPenalty * ramp;

        if (roll < 0.22) return 0;
        if (roll < 0.40) return 1;
        if (roll < 0.58) return 2;
        if (roll < 0.76) return 3;
        return 4;
      });
    });
  }
}

/// GitHub-style activity heatmap.
class ContributionGrid extends StatelessWidget {
  const ContributionGrid({super.key, this.data});

  final List<ContributionWeek>? data;

  static const List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  Color _colorFor(int level) => switch (level) {
    0 => Colors.white.withValues(alpha: 0.045),
    1 => AppColors.accent.withValues(alpha: 0.25),
    2 => AppColors.accent.withValues(alpha: 0.45),
    3 => AppColors.accent.withValues(alpha: 0.70),
    _ => AppColors.accentAlt.withValues(alpha: 0.92),
  };

  @override
  Widget build(BuildContext context) {
    final weeks = data ?? ContributionData.sample;

    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 3.0;
        // Cells size themselves to the available width, so the grid works from
        // 320px to 1920px without a horizontal scrollbar and without leaving a
        // third of the card empty on a wide monitor.
        final cell =
            ((constraints.maxWidth - gap * (weeks.length - 1)) / weeks.length)
                .clamp(4.0, 20.0);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!context.isHandset) _monthLabels(cell, gap, weeks.length),
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var w = 0; w < weeks.length; w++)
                  Padding(
                    padding: EdgeInsets.only(
                      right: w == weeks.length - 1 ? 0 : gap,
                    ),
                    child: Column(
                      children: [
                        for (var d = 0; d < weeks[w].length; d++)
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: d == weeks[w].length - 1 ? 0 : gap,
                            ),
                            child: Container(
                              width: cell,
                              height: cell,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  cell * 0.24,
                                ),
                                color: _colorFor(weeks[w][d]),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            _legend(),
          ],
        );
      },
    );
  }

  Widget _monthLabels(double cell, double gap, int weekCount) {
    final weeksPerMonth = weekCount / 12;

    return SizedBox(
      height: 14,
      child: Row(
        children: [
          for (var m = 0; m < 12; m++)
            SizedBox(
              width: weeksPerMonth * (cell + gap),
              child: Text(
                _months[m],
                style: AppText.chip.copyWith(
                  fontSize: 9.5,
                  color: AppColors.textTertiary.withValues(alpha: 0.7),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _legend() {
    return Row(
      children: [
        Text(
          'Less',
          style: AppText.chip.copyWith(
            fontSize: 10,
            color: AppColors.textTertiary,
          ),
        ),
        const SizedBox(width: 8),
        for (var level = 0; level <= 4; level++)
          Padding(
            padding: const EdgeInsets.only(right: 3),
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.5),
                color: _colorFor(level),
              ),
            ),
          ),
        const SizedBox(width: 6),
        Text(
          'More',
          style: AppText.chip.copyWith(
            fontSize: 10,
            color: AppColors.textTertiary,
          ),
        ),
      ],
    );
  }
}
