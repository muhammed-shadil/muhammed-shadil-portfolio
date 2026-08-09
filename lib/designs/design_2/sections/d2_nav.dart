import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../animations/hover_region.dart';
import '../../../core/responsive/responsive.dart';
import '../../../core/utils/launcher.dart';
import '../../../core/utils/section_controller.dart';
import '../../../data/portfolio_data.dart';
import '../theme/design_2_theme.dart';
import '../widgets/d2_primitives.dart';

/// Studio's navigation: a slim bar with a hairline underline.
///
/// Where Design 1 uses pill-shaped nav chips with an active underline, Studio
/// uses lowercase-tracked monospace links and marks the active one with a
/// leading index number — the same numbering motif as the section eyebrows.
class D2Nav extends StatelessWidget {
  const D2Nav({super.key, required this.onOpenMenu});

  final VoidCallback onOpenMenu;

  static const double height = kD2NavHeight;
  static const double heightCompact = kD2NavHeightCompact;

  @override
  Widget build(BuildContext context) {
    final controller = SectionScope.of(context);
    final scrolled = controller.isScrolled;
    final showLinks = context.screenWidth >= 940;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: scrolled ? 20 : 0,
          sigmaY: scrolled ? 20 : 0,
        ),
        child: AnimatedContainer(
          duration: D2.medium,
          curve: D2.ease,
          height: scrolled ? heightCompact : height,
          decoration: BoxDecoration(
            color: D2.bg.withValues(alpha: scrolled ? 0.82 : 0),
            border: Border(
              bottom: BorderSide(
                color: scrolled ? D2.line : Colors.transparent,
              ),
            ),
          ),
          child: D2Container(
            child: Row(
              children: [
                _Wordmark(
                  onTap: () => controller.scrollToTop(
                    reduceMotion: context.reduceMotion,
                  ),
                ),
                const Spacer(),
                if (showLinks) ...[
                  // Scales the link row down instead of overflowing when the
                  // labels, the font or the browser zoom are wider than the
                  // breakpoint assumed.
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (var i = 0; i < AppSection.values.length; i++)
                            _NavLink(
                              index: i,
                              section: AppSection.values[i],
                              active: controller.active == AppSection.values[i],
                              onTap: () => controller.scrollTo(
                                AppSection.values[i],
                                reduceMotion: context.reduceMotion,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 22),
                  D2Button(
                    label: 'Let\'s talk',
                    compact: true,
                    onPressed: () => Launcher.open(PortfolioData.mailto),
                  ),
                ] else
                  _MenuButton(onTap: onOpenMenu),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Wordmark extends StatelessWidget {
  const _Wordmark({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final compact = context.screenWidth < 520;

    return HoverRegion(
      onTap: onTap,
      focusable: true,
      semanticLabel: '${PortfolioData.name}, back to top',
      builder: (context, state) {
        final active = state.isActive;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: D2.fast,
              width: 9,
              height: 9,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: active ? D2.accent : D2.ink,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              compact ? PortfolioData.initials : PortfolioData.name,
              style: const TextStyle(
                fontFamily: D2.display,
                fontSize: 16,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.4,
                color: D2.ink,
              ),
            ),
            if (!compact) ...[
              const SizedBox(width: 12),
              Container(width: 1, height: 14, color: D2.lineStrong),
              const SizedBox(width: 12),
              Text(
                PortfolioData.roleShort,
                style: D2.label.copyWith(fontSize: 10, letterSpacing: 1.6),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _NavLink extends StatelessWidget {
  const _NavLink({
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
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedOpacity(
                duration: D2.fast,
                opacity: active ? 1 : 0,
                child: Text(
                  '0${index + 1}',
                  style: D2.label.copyWith(
                    color: D2.accent,
                    fontSize: 9.5,
                    letterSpacing: 1,
                  ),
                ),
              ),
              AnimatedContainer(duration: D2.fast, width: active ? 8 : 0),
              AnimatedDefaultTextStyle(
                duration: D2.fast,
                style: TextStyle(
                  fontFamily: D2.body,
                  fontSize: 14,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                  color: lit ? D2.ink : D2.inkMuted,
                ),
                child: Text(section.label),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return HoverRegion(
      onTap: onTap,
      focusable: true,
      semanticLabel: 'Open menu',
      builder: (context, state) => Container(
        width: 46,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: D2.pill,
          border: Border.all(color: state.isActive ? D2.lineStrong : D2.line),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 16, height: 1.5, color: D2.ink),
            const SizedBox(height: 4),
            Container(width: 10, height: 1.5, color: D2.ink),
          ],
        ),
      ),
    );
  }
}

/// Full-screen Studio menu: oversized entries, index numbers, hairline rules.
class D2Menu extends StatefulWidget {
  const D2Menu({super.key, required this.onClose});
  final VoidCallback onClose;

  @override
  State<D2Menu> createState() => _D2MenuState();
}

class _D2MenuState extends State<D2Menu> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: D2.medium,
    reverseDuration: D2.fast,
  )..forward();

  Future<void> _close() async {
    await _c.reverse();
    if (mounted) widget.onClose();
  }

  Future<void> _go(AppSection section) async {
    final controller = SectionScope.read(context);
    final reduceMotion = context.reduceMotion;
    await _close();
    await controller.scrollTo(section, reduceMotion: reduceMotion);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

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
              onInvoke: (_) => _close(),
            ),
          },
          child: FocusScope(
            autofocus: true,
            child: AnimatedBuilder(
              animation: _c,
              builder: (context, _) {
                final t = Curves.easeOutCubic.transform(_c.value);
                return Opacity(
                  opacity: t,
                  child: Container(
                    color: D2.bg,
                    child: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: D2Nav.height,
                            child: D2Container(
                              child: Row(
                                children: [
                                  const Spacer(),
                                  HoverRegion(
                                    onTap: _close,
                                    focusable: true,
                                    semanticLabel: 'Close menu',
                                    builder: (context, s) => Container(
                                      width: 44,
                                      height: 40,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: D2.pill,
                                        border: Border.all(color: D2.line),
                                      ),
                                      child: const Icon(
                                        Icons.close_rounded,
                                        size: 18,
                                        color: D2.ink,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: D2Container(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    const SizedBox(height: 8),
                                    for (
                                      var i = 0;
                                      i < AppSection.values.length;
                                      i++
                                    )
                                      _MenuRow(
                                        index: i,
                                        progress: t,
                                        section: AppSection.values[i],
                                        onTap: () => _go(AppSection.values[i]),
                                      ),
                                    const SizedBox(height: 32),
                                    D2Button(
                                      label: 'Email me',
                                      expand: true,
                                      icon: Icons.mail_outline_rounded,
                                      onPressed: () =>
                                          Launcher.open(PortfolioData.mailto),
                                    ),
                                    const SizedBox(height: 12),
                                    D2Button(
                                      label: 'Download resume',
                                      expand: true,
                                      filled: false,
                                      icon: Icons.download_rounded,
                                      onPressed: () => Launcher.open(
                                        PortfolioData.resumeDownloadUrl,
                                      ),
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
                );
              },
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
    required this.progress,
    required this.section,
    required this.onTap,
  });

  final int index;
  final double progress;
  final AppSection section;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final start = (index * 0.08).clamp(0.0, 0.55);
    final local = ((progress - start) / (1 - start)).clamp(0.0, 1.0);

    return Opacity(
      opacity: local,
      child: Transform.translate(
        offset: Offset(0, 26 * (1 - local)),
        child: HoverRegion(
          onTap: onTap,
          focusable: true,
          semanticLabel: 'Go to ${section.label}',
          builder: (context, state) {
            final active = state.isActive;
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: D2.line)),
              ),
              child: Row(
                children: [
                  Text(
                    '0${index + 1}',
                    style: D2.label.copyWith(
                      color: active ? D2.accent : D2.inkFaint,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: AnimatedDefaultTextStyle(
                      duration: D2.fast,
                      style: TextStyle(
                        fontFamily: D2.display,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1,
                        color: active ? D2.ink : D2.inkMuted,
                      ),
                      child: Text(section.label),
                    ),
                  ),
                  AnimatedSlide(
                    offset: Offset(active ? 0.3 : 0, 0),
                    duration: D2.fast,
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      size: 18,
                      color: active ? D2.accent : D2.inkFaint,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
