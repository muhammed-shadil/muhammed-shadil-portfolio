import 'package:flutter/material.dart';

import '../../animations/reveal.dart';
import '../../core/responsive/responsive.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/launcher.dart';
import '../../data/portfolio_data.dart';
import '../../widgets/buttons.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/section_shell.dart';
import '../../widgets/tech_chip.dart';

/// Resume call-to-action — a single wide glass card between the process and
/// contact sections.
class ResumeSection extends StatelessWidget {
  const ResumeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final compact = context.screenWidth < 820;

    return SectionShell(
      semanticLabel: 'Resume',
      topPadding: context.sectionGap * 0.6,
      bottomPadding: context.sectionGap * 0.6,
      child: Reveal(
        child: GlassCard(
          accent: AppColors.accent,
          glowStrength: 0.35,
          padding: EdgeInsets.all(
            context.responsive(mobile: 26.0, tablet: 34.0, laptop: 44.0),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -60,
                top: -60,
                child: IgnorePointer(
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.accent.withValues(alpha: 0.22),
                          AppColors.accent.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              compact ? _stacked(context) : _row(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _copy(context)),
        const SizedBox(width: 40),
        _actions(context, expand: false),
      ],
    );
  }

  Widget _stacked(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _copy(context),
        const SizedBox(height: 30),
        _actions(context, expand: true),
      ],
    );
  }

  Widget _copy(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Eyebrow('Resume', showRule: false),
        const SizedBox(height: 18),
        Text(
          'Want the full picture?',
          style: AppText.title(
            context,
          ).copyWith(fontSize: context.responsive(mobile: 24.0, laptop: 30.0)),
        ),
        const SizedBox(height: 12),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Text(
            'Roles, dates, tools and every app I have shipped — one page, '
            'kept current.',
            style: AppText.body,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            const Icon(
              Icons.picture_as_pdf_rounded,
              size: 15,
              color: AppColors.textTertiary,
            ),
            const SizedBox(width: 8),
            Text(
              'PDF  ·  ${PortfolioData.name}',
              style: AppText.caption.copyWith(fontSize: 11.5),
            ),
          ],
        ),
      ],
    );
  }

  Widget _actions(BuildContext context, {required bool expand}) {
    final buttons = [
      PrimaryButton(
        label: 'Download resume',
        icon: Icons.download_rounded,
        expand: expand,
        onPressed: () => Launcher.open(PortfolioData.resumeDownloadUrl),
      ),
      SecondaryButton(
        label: 'View resume',
        icon: Icons.open_in_new_rounded,
        expand: expand,
        onPressed: () => Launcher.open(PortfolioData.resumeUrl),
      ),
    ];

    if (expand) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [buttons[0], const SizedBox(height: 12), buttons[1]],
      );
    }

    // Inside the wide Row the actions column has no width constraint, so it
    // gets an explicit one — `stretch` against an unbounded width is a
    // layout error, not just a visual quirk.
    return SizedBox(
      width: 232,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [buttons[0], const SizedBox(height: 12), buttons[1]],
      ),
    );
  }
}
