import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../animations/hover_region.dart';
import '../../../animations/reveal.dart';
import '../../../core/responsive/responsive.dart';
import '../../../core/utils/launcher.dart';
import '../../../core/utils/section_controller.dart';
import '../../../data/portfolio_data.dart';
import '../theme/design_3_theme.dart';
import '../widgets/d3_primitives.dart';

/// Index's navigation rail: a rule, an index of sections, no pills.
class D3Nav extends StatelessWidget {
  const D3Nav({super.key, required this.onOpenMenu});

  final VoidCallback onOpenMenu;

  @override
  Widget build(BuildContext context) {
    final controller = SectionScope.of(context);
    final scrolled = controller.isScrolled;
    final showLinks = context.screenWidth >= 920;

    return AnimatedContainer(
      duration: D3.medium,
      curve: D3.ease,
      height: kD3NavHeight,
      decoration: BoxDecoration(
        color: scrolled ? D3.paper : D3.paper.withValues(alpha: 0),
        border: Border(
          bottom: BorderSide(color: scrolled ? D3.ruleStrong : D3.rule),
        ),
      ),
      child: D3Container(
        child: Row(
          children: [
            // Flexible with an ellipsis: the tracked-out full name is wide,
            // and at 320px it collides with the menu trigger.
            Flexible(
              child: HoverRegion(
                onTap: () =>
                    controller.scrollToTop(reduceMotion: context.reduceMotion),
                focusable: true,
                semanticLabel: '${PortfolioData.name}, back to top',
                builder: (context, state) => Text(
                  PortfolioData.name.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: D3.label.copyWith(
                    color: state.isActive ? D3.accent : D3.ink,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
            const Spacer(),
            if (showLinks) ...[
              for (var i = 0; i < AppSection.values.length; i++)
                _NavItem(
                  index: i,
                  section: AppSection.values[i],
                  active: controller.active == AppSection.values[i],
                  onTap: () => controller.scrollTo(
                    AppSection.values[i],
                    reduceMotion: context.reduceMotion,
                  ),
                ),
            ] else
              HoverRegion(
                onTap: onOpenMenu,
                focusable: true,
                semanticLabel: 'Open menu',
                builder: (context, state) => Text(
                  'INDEX +',
                  style: D3.label.copyWith(
                    color: state.isActive ? D3.accent : D3.ink,
                    fontSize: 11,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.index,
    required this.section,
    required this.active,
    required this.onTap,
  });

  final int index;
  final AppSection section;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return HoverRegion(
      onTap: onTap,
      focusable: true,
      semanticLabel: 'Go to ${section.label}',
      builder: (context, state) {
        final lit = active || state.isActive;
        return Padding(
          padding: const EdgeInsets.only(left: 26),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '0${index + 1}',
                    style: D3.label.copyWith(
                      fontSize: 9,
                      letterSpacing: 1,
                      color: lit ? D3.accent : D3.inkFaint,
                    ),
                  ),
                  const SizedBox(width: 7),
                  AnimatedDefaultTextStyle(
                    duration: D3.fast,
                    style: D3.label.copyWith(
                      fontSize: 11,
                      color: lit ? D3.ink : D3.inkMuted,
                    ),
                    child: Text(section.label.toUpperCase()),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              AnimatedContainer(
                duration: D3.fast,
                curve: D3.ease,
                height: 1,
                width: active ? 100 : 0,
                color: D3.accent,
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Full-screen index for handsets.
class D3Menu extends StatelessWidget {
  const D3Menu({super.key, required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Shortcuts(
        shortcuts: const {
          SingleActivator(LogicalKeyboardKey.escape): DismissIntent(),
        },
        child: Actions(
          actions: {
            DismissIntent: CallbackAction<DismissIntent>(
              onInvoke: (_) {
                onClose();
                return null;
              },
            ),
          },
          child: FocusScope(
            autofocus: true,
            child: ColoredBox(
              color: D3.paper,
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: kD3NavHeight,
                      child: D3Container(
                        child: Row(
                          children: [
                            Text(
                              'INDEX',
                              style: D3.label.copyWith(fontSize: 11),
                            ),
                            const Spacer(),
                            HoverRegion(
                              onTap: onClose,
                              focusable: true,
                              semanticLabel: 'Close menu',
                              builder: (context, state) => Text(
                                'CLOSE ×',
                                style: D3.label.copyWith(
                                  fontSize: 11,
                                  color: state.isActive ? D3.accent : D3.ink,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: D3Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 12),
                              for (var i = 0; i < AppSection.values.length; i++)
                                _MenuRow(
                                  index: i,
                                  section: AppSection.values[i],
                                  onClose: onClose,
                                ),
                              const SizedBox(height: 36),
                              D3Button(
                                label: 'Email me',
                                expand: true,
                                onPressed: () =>
                                    Launcher.open(PortfolioData.mailto),
                              ),
                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({
    required this.index,
    required this.section,
    required this.onClose,
  });

  final int index;
  final AppSection section;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return HoverRegion(
      onTap: () {
        final controller = SectionScope.read(context);
        final reduceMotion = context.reduceMotion;
        onClose();
        controller.scrollTo(section, reduceMotion: reduceMotion);
      },
      focusable: true,
      semanticLabel: 'Go to ${section.label}',
      builder: (context, state) => Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: D3.rule)),
        ),
        child: Row(
          children: [
            Text(
              '0${index + 1}',
              style: D3.monoText.copyWith(color: D3.accent),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                section.label,
                style: D3.indexTitle(context).copyWith(fontSize: 30),
              ),
            ),
            Icon(
              Icons.arrow_forward_rounded,
              size: 18,
              color: state.isActive ? D3.accent : D3.inkFaint,
            ),
          ],
        ),
      ),
    );
  }
}

/// Index's closing spread: an oversized serif statement and a contact table.
class D3Contact extends StatelessWidget {
  const D3Contact({super.key, this.anchorKey});

  final Key? anchorKey;

  @override
  Widget build(BuildContext context) {
    final wide = context.screenWidth >= 900;

    return D3Section(
      anchorKey: anchorKey,
      bottom: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const D3SectionMark(number: '05', label: 'Contact'),
          const SizedBox(height: 44),
          Reveal(child: Text('Have an idea?', style: D3.sectionTitle(context))),
          Reveal(
            delay: const Duration(milliseconds: 90),
            child: Text(
              'Let\'s build it.',
              style: D3
                  .sectionTitle(context)
                  .copyWith(color: D3.accent, fontStyle: FontStyle.italic),
            ),
          ),
          const SizedBox(height: 32),
          Reveal(
            delay: const Duration(milliseconds: 160),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Text(PortfolioData.contactBlurb, style: D3.lead(context)),
            ),
          ),
          const SizedBox(height: 52),
          Reveal(
            delay: const Duration(milliseconds: 220),
            child: _table(context, wide),
          ),
        ],
      ),
    );
  }

  Widget _table(BuildContext context, bool wide) {
    final rows = <(String, String, String)>[
      ('Email', PortfolioData.email, PortfolioData.mailto),
      ('GitHub', '@${PortfolioData.githubHandle}', PortfolioData.githubUrl),
      ('LinkedIn', 'in/muhammed-shadil', PortfolioData.linkedinUrl),
      ('Resume', 'Download PDF', PortfolioData.resumeDownloadUrl),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const D3Rule(strong: true),
        for (final (label, value, url) in rows)
          HoverRegion(
            onTap: () => Launcher.open(url),
            focusable: true,
            semanticLabel: '$label: $value',
            builder: (context, state) {
              final active = state.isActive;
              return AnimatedContainer(
                duration: D3.fast,
                padding: EdgeInsets.symmetric(
                  vertical: wide ? 24 : 18,
                  horizontal: active ? 12 : 0,
                ),
                color: active ? D3.paperAlt : Colors.transparent,
                child: Row(
                  children: [
                    SizedBox(
                      width: wide ? 180 : 92,
                      child: Text(label.toUpperCase(), style: D3.label),
                    ),
                    Expanded(
                      child: AnimatedDefaultTextStyle(
                        duration: D3.fast,
                        style: TextStyle(
                          fontFamily: D3.display,
                          fontSize: wide ? 28 : 20,
                          color: active ? D3.accent : D3.ink,
                        ),
                        child: Text(value, overflow: TextOverflow.ellipsis),
                      ),
                    ),
                    AnimatedSlide(
                      offset: Offset(active ? 0.3 : 0, active ? -0.3 : 0),
                      duration: D3.fast,
                      child: Icon(
                        Icons.arrow_outward_rounded,
                        size: 16,
                        color: active ? D3.accent : D3.inkFaint,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        const D3Rule(strong: true),
      ],
    );
  }
}

/// Colophon.
class D3Footer extends StatelessWidget {
  const D3Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final compact = context.screenWidth < 700;
    final controller = SectionScope.read(context);

    final credit = Text(
      '© 2026 ${PortfolioData.name} · Set in Instrument Serif & JetBrains '
      'Mono · Built with Flutter Web',
      style: D3.monoText.copyWith(fontSize: 11, color: D3.inkFaint),
    );

    final top = HoverRegion(
      onTap: () => controller.scrollToTop(reduceMotion: context.reduceMotion),
      focusable: true,
      semanticLabel: 'Back to top',
      builder: (context, state) => Text(
        '↑ TOP',
        style: D3.label.copyWith(
          fontSize: 10.5,
          color: state.isActive ? D3.accent : D3.ink,
        ),
      ),
    );

    return Padding(
      padding: EdgeInsets.only(
        top: D3Section.rhythmOf(context) * 0.6,
        bottom: 40,
      ),
      child: D3Container(
        child: compact
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [top, const SizedBox(height: 16), credit],
              )
            : Row(
                children: [
                  Expanded(child: credit),
                  const SizedBox(width: 24),
                  top,
                ],
              ),
      ),
    );
  }
}
