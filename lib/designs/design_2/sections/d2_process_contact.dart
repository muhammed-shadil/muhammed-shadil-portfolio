import 'package:flutter/material.dart';

import '../../../animations/hover_region.dart';
import '../../../animations/reveal.dart';
import '../../../core/responsive/responsive.dart';
import '../../../core/utils/launcher.dart';
import '../../../core/utils/section_controller.dart';
import '../../../data/portfolio_data.dart';
import '../../../widgets/brand_icons.dart';
import '../theme/design_2_theme.dart';
import '../widgets/d2_primitives.dart';

/// "How I build" as a numbered editorial list rather than Design 1's cards.
class D2Process extends StatelessWidget {
  const D2Process({super.key});

  @override
  Widget build(BuildContext context) {
    final wide = context.screenWidth >= 900;
    const steps = PortfolioData.process;

    return D2Section(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          D2SectionHeader(
            number: '05',
            eyebrow: 'Process',
            title: 'How the work happens.',
          ),
          const SizedBox(height: 56),
          for (var i = 0; i < steps.length; i++)
            Reveal.at(
              i,
              step: const Duration(milliseconds: 90),
              child: HoverRegion(
                builder: (context, state) => AnimatedContainer(
                  duration: D2.fast,
                  padding: EdgeInsets.symmetric(
                    vertical: wide ? 30 : 24,
                    horizontal: state.isHovered ? 12 : 0,
                  ),
                  decoration: BoxDecoration(
                    color: state.isHovered
                        ? D2.ink.withValues(alpha: 0.02)
                        : Colors.transparent,
                    border: const Border(top: BorderSide(color: D2.line)),
                  ),
                  child: wide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 90,
                              child: Text(
                                steps[i].number,
                                style: D2.label.copyWith(
                                  fontSize: 11,
                                  color: state.isHovered
                                      ? D2.accent
                                      : D2.inkFaint,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 260,
                              child: Text(
                                steps[i].title,
                                style: D2.cardTitle(context),
                              ),
                            ),
                            const SizedBox(width: 32),
                            Expanded(
                              child: Text(
                                steps[i].description,
                                style: D2.bodyText,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              steps[i].number,
                              style: D2.label.copyWith(fontSize: 10.5),
                            ),
                            const SizedBox(height: 12),
                            Text(steps[i].title, style: D2.cardTitle(context)),
                            const SizedBox(height: 10),
                            Text(steps[i].description, style: D2.bodyText),
                          ],
                        ),
                ),
              ),
            ),
          Container(height: 1, color: D2.line),
        ],
      ),
    );
  }
}

/// Studio's closing call to action: an oversized statement, then the four
/// ways to reach out as rows rather than a form.
///
/// The site is statically hosted, so rather than fake a form submission this
/// hands over real, working links.
class D2Contact extends StatelessWidget {
  const D2Contact({super.key, this.anchorKey});

  final Key? anchorKey;

  @override
  Widget build(BuildContext context) {
    return D2Section(
      anchorKey: anchorKey,
      bottom: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Reveal(child: const D2Eyebrow('Contact', number: '06')),
          const SizedBox(height: 32),
          Reveal(
            delay: const Duration(milliseconds: 80),
            child: Text('Have an idea?', style: D2.hero(context)),
          ),
          Reveal(
            delay: const Duration(milliseconds: 160),
            child: Text(
              'Let\'s build it.',
              style: D2.hero(context).copyWith(color: D2.accent),
            ),
          ),
          const SizedBox(height: 36),
          Reveal(
            delay: const Duration(milliseconds: 220),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Text(PortfolioData.contactBlurb, style: D2.lead(context)),
            ),
          ),
          const SizedBox(height: 56),
          Reveal(delay: const Duration(milliseconds: 280), child: _links()),
        ],
      ),
    );
  }

  Widget _links() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ContactRow(
          label: 'Email',
          value: PortfolioData.email,
          url: PortfolioData.mailto,
          icon: const Icon(Icons.alternate_email_rounded, size: 17),
        ),
        _ContactRow(
          label: 'GitHub',
          value: '@${PortfolioData.githubHandle}',
          url: PortfolioData.githubUrl,
          icon: const BrandIcon(BrandPaths.github, size: 16),
        ),
        _ContactRow(
          label: 'LinkedIn',
          value: 'in/muhammed-shadil',
          url: PortfolioData.linkedinUrl,
          icon: const BrandIcon(BrandPaths.linkedin, size: 16),
        ),
        _ContactRow(
          label: 'Resume',
          value: 'Download PDF',
          url: PortfolioData.resumeDownloadUrl,
          icon: const Icon(Icons.description_outlined, size: 17),
          isLast: true,
        ),
      ],
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.label,
    required this.value,
    required this.url,
    required this.icon,
    this.isLast = false,
  });

  final String label;
  final String value;
  final String url;
  final Widget icon;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final compact = context.screenWidth < 620;

    return HoverRegion(
      onTap: () => Launcher.open(url),
      focusable: true,
      semanticLabel: '$label: $value',
      builder: (context, state) {
        final active = state.isActive;

        return AnimatedContainer(
          duration: D2.fast,
          curve: D2.ease,
          padding: EdgeInsets.symmetric(
            vertical: compact ? 20 : 26,
            horizontal: active ? 14 : 0,
          ),
          decoration: BoxDecoration(
            color: active ? D2.ink.withValues(alpha: 0.025) : null,
            border: Border(
              top: const BorderSide(color: D2.line),
              bottom: BorderSide(color: isLast ? D2.line : Colors.transparent),
            ),
          ),
          child: Row(
            children: [
              IconTheme(
                data: IconThemeData(
                  color: active ? D2.accent : D2.inkFaint,
                  size: 17,
                ),
                child: icon,
              ),
              const SizedBox(width: 18),
              SizedBox(
                width: compact ? 74 : 120,
                child: Text(
                  label.toUpperCase(),
                  style: D2.label.copyWith(fontSize: 10),
                ),
              ),
              Expanded(
                child: AnimatedDefaultTextStyle(
                  duration: D2.fast,
                  style: TextStyle(
                    fontFamily: D2.body,
                    fontSize: compact ? 14 : 17,
                    fontWeight: FontWeight.w600,
                    color: active ? D2.ink : D2.inkMuted,
                  ),
                  child: Text(value, overflow: TextOverflow.ellipsis),
                ),
              ),
              AnimatedSlide(
                offset: Offset(active ? 0.3 : 0, active ? -0.3 : 0),
                duration: D2.fast,
                child: Icon(
                  Icons.arrow_outward_rounded,
                  size: 16,
                  color: active ? D2.accent : D2.inkFaint,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Minimal closing footer.
class D2Footer extends StatelessWidget {
  const D2Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final compact = context.screenWidth < 700;
    final controller = SectionScope.read(context);

    final credit = Text(
      '© 2026 ${PortfolioData.name}  ·  Built with Flutter Web',
      style: D2.small.copyWith(color: D2.inkFaint, fontSize: 12.5),
    );

    final top = HoverRegion(
      onTap: () => controller.scrollToTop(reduceMotion: context.reduceMotion),
      focusable: true,
      semanticLabel: 'Back to top',
      builder: (context, state) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'BACK TO TOP',
            style: D2.label.copyWith(
              fontSize: 10,
              color: state.isActive ? D2.ink : D2.inkFaint,
            ),
          ),
          const SizedBox(width: 10),
          AnimatedSlide(
            offset: Offset(0, state.isActive ? -0.3 : 0),
            duration: D2.fast,
            child: Icon(
              Icons.arrow_upward_rounded,
              size: 15,
              color: state.isActive ? D2.accent : D2.inkFaint,
            ),
          ),
        ],
      ),
    );

    return Padding(
      padding: EdgeInsets.only(
        top: D2Section.rhythmOf(context) * 0.7,
        bottom: 48,
      ),
      child: D2Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(height: 1, color: D2.line),
            const SizedBox(height: 28),
            if (compact)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [top, const SizedBox(height: 18), credit],
              )
            else
              Row(
                children: [
                  Expanded(child: credit),
                  const SizedBox(width: 24),
                  top,
                ],
              ),
          ],
        ),
      ),
    );
  }
}
