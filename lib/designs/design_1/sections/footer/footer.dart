import 'package:flutter/material.dart';

import '../../../../animations/hover_region.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/launcher.dart';
import '../../../../core/utils/section_controller.dart';
import '../../../../data/portfolio_data.dart';
import '../../../../widgets/brand_icons.dart';
import '../../../../widgets/buttons.dart';
import '../navbar/nav_logo.dart';

/// Page footer: wordmark, quick links, socials and a back-to-top control.
class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final compact = context.screenWidth < 820;

    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: ContentContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (compact) _stacked(context) else _row(context),
              const SizedBox(height: 36),
              const Divider(),
              const SizedBox(height: 22),
              _bottomBar(context, compact),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 4, child: _identity(context)),
        const SizedBox(width: 40),
        Expanded(flex: 3, child: _quickLinks(context)),
        const SizedBox(width: 40),
        Expanded(flex: 3, child: _elsewhere(context)),
      ],
    );
  }

  Widget _stacked(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _identity(context),
        const SizedBox(height: 34),
        _quickLinks(context),
        const SizedBox(height: 34),
        _elsewhere(context),
      ],
    );
  }

  Widget _identity(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const NavLogo(),
        const SizedBox(height: 18),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: Text(
            'Flutter developer in ${PortfolioData.location}, building '
            'production mobile and web apps.',
            style: AppText.bodySmall.copyWith(color: AppColors.textTertiary),
          ),
        ),
        const SizedBox(height: 20),
        PrimaryButton(
          label: 'Start a conversation',
          compact: true,
          icon: Icons.mail_outline_rounded,
          onPressed: () => Launcher.open(PortfolioData.mailto),
        ),
      ],
    );
  }

  Widget _quickLinks(BuildContext context) {
    final controller = SectionScope.read(context);
    final reduceMotion = context.reduceMotion;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _heading('Navigate'),
        const SizedBox(height: 16),
        for (final section in AppSection.values)
          _FooterLink(
            label: section.label,
            onTap: () =>
                controller.scrollTo(section, reduceMotion: reduceMotion),
          ),
      ],
    );
  }

  Widget _elsewhere(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _heading('Elsewhere'),
        const SizedBox(height: 16),
        _FooterLink(
          label: 'GitHub',
          onTap: () => Launcher.open(PortfolioData.githubUrl),
          external: true,
        ),
        _FooterLink(
          label: 'LinkedIn',
          onTap: () => Launcher.open(PortfolioData.linkedinUrl),
          external: true,
        ),
        _FooterLink(
          label: 'Instagram',
          onTap: () => Launcher.open(PortfolioData.instagramUrl),
          external: true,
        ),
        _FooterLink(
          label: 'Resume (PDF)',
          onTap: () => Launcher.open(PortfolioData.resumeUrl),
          external: true,
        ),
        _FooterLink(
          label: PortfolioData.email,
          onTap: () => Launcher.open(PortfolioData.mailto),
          external: true,
        ),
      ],
    );
  }

  Widget _heading(String text) => Text(
    text.toUpperCase(),
    style: AppText.eyebrow.copyWith(
      color: AppColors.textTertiary,
      fontSize: 10.5,
      letterSpacing: 2,
    ),
  );

  Widget _bottomBar(BuildContext context, bool compact) {
    final controller = SectionScope.read(context);

    final credit = Text(
      '© 2026 ${PortfolioData.name}  ·  Built with Flutter Web',
      style: AppText.caption.copyWith(fontSize: 11.5),
    );

    // Wrap rather than Row: on a 320px screen the icon row plus the
    // back-to-top button does not fit on one line.
    final actions = Wrap(
      spacing: 8,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        IconActionButton(
          onPressed: () => Launcher.open(PortfolioData.githubUrl),
          tooltip: 'GitHub',
          size: 38,
          child: const BrandIcon(BrandPaths.github, size: 15),
        ),
        IconActionButton(
          onPressed: () => Launcher.open(PortfolioData.linkedinUrl),
          tooltip: 'LinkedIn',
          size: 38,
          child: const BrandIcon(BrandPaths.linkedin, size: 15),
        ),
        IconActionButton(
          onPressed: () => Launcher.open(PortfolioData.facebookUrl),
          tooltip: 'Facebook',
          size: 38,
          child: const BrandIcon(BrandPaths.facebook, size: 15),
        ),
        const SizedBox(width: 8),
        SecondaryButton(
          label: 'Back to top',
          icon: Icons.arrow_upward_rounded,
          compact: true,
          onPressed: () =>
              controller.scrollToTop(reduceMotion: context.reduceMotion),
        ),
      ],
    );

    if (compact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [actions, const SizedBox(height: 20), credit],
      );
    }

    // `credit` is flexible rather than fixed-width: between 820px (where this
    // row replaces the stacked layout) and roughly 1200px, the copyright line
    // plus the action cluster is wider than the content column.
    return Row(
      children: [
        Expanded(child: credit),
        const SizedBox(width: 24),
        actions,
      ],
    );
  }
}

class _FooterLink extends StatelessWidget {
  const _FooterLink({
    required this.label,
    required this.onTap,
    this.external = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool external;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: HoverRegion(
        onTap: onTap,
        focusable: true,
        semanticLabel: label,
        builder: (context, state) {
          final active = state.isActive;

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: AppDurations.fast,
                width: active ? 14 : 0,
                height: 1,
                margin: EdgeInsets.only(right: active ? 8 : 0),
                color: AppColors.accentAlt,
              ),
              Flexible(
                child: AnimatedDefaultTextStyle(
                  duration: AppDurations.fast,
                  style: AppText.bodySmall.copyWith(
                    color: active
                        ? AppColors.textPrimary
                        : AppColors.textTertiary,
                  ),
                  child: Text(label, overflow: TextOverflow.ellipsis),
                ),
              ),
              if (external) ...[
                const SizedBox(width: 6),
                Icon(
                  Icons.arrow_outward_rounded,
                  size: 11,
                  color: active
                      ? AppColors.accentAlt
                      : AppColors.textTertiary.withValues(alpha: 0.5),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
