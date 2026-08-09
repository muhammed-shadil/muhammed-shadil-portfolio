import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../animations/hover_region.dart';
import '../../../core/responsive/responsive.dart';
import '../../../core/utils/launcher.dart';
import '../../../core/utils/section_controller.dart';
import '../../../data/portfolio_data.dart';
import '../../../widgets/brand_icons.dart';
import '../theme/design_2_theme.dart';
import '../widgets/d2_primitives.dart';

/// Studio's hero.
///
/// Type-led: an oversized statement on the left, a floating application window
/// on the right. Everything animates once on mount from a single controller
/// rather than on scroll, because it is above the fold.
class D2Hero extends StatefulWidget {
  const D2Hero({super.key, this.anchorKey});

  final Key? anchorKey;

  @override
  State<D2Hero> createState() => _D2HeroState();
}

class _D2HeroState extends State<D2Hero> with TickerProviderStateMixin {
  late final AnimationController _entrance = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  );

  /// Single slow clock shared by every floating element.
  late final AnimationController _drift = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 16),
  );

  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (context.reduceMotion) {
      _entrance.value = 1;
    } else {
      _entrance.forward();
      _drift.repeat();
    }
  }

  @override
  void dispose() {
    _entrance.dispose();
    _drift.dispose();
    super.dispose();
  }

  Widget _step(int order, Widget child) {
    final start = (order * 0.08).clamp(0.0, 0.72);
    final anim = CurvedAnimation(
      parent: _entrance,
      curve: Interval(start, (start + 0.4).clamp(0.0, 1.0), curve: D2.ease),
    );
    return AnimatedBuilder(
      animation: anim,
      child: child,
      builder: (context, child) => Opacity(
        opacity: anim.value,
        child: Transform.translate(
          offset: Offset(0, 24 * (1 - anim.value)),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wide = context.screenWidth >= 1060;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(key: widget.anchorKey, height: 0),
        ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: wide
                ? (context.screenHeight * 0.94).clamp(620.0, 980.0)
                : 0,
          ),
          child: Padding(
            padding: EdgeInsets.only(
              top: kD2NavHeight + (wide ? 40 : 32),
              bottom: wide ? 90 : 72,
            ),
            child: D2Container(
              child: wide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(flex: 7, child: _copy(context)),
                        const SizedBox(width: 60),
                        Expanded(flex: 6, child: _visual(context)),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _copy(context),
                        const SizedBox(height: 56),
                        _visual(context),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------------ copy
  Widget _copy(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _step(0, const D2Badge(label: PortfolioData.availability, pulse: true)),
        const SizedBox(height: 34),
        _step(1, _headline(context)),
        const SizedBox(height: 28),
        _step(
          2,
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Text(PortfolioData.heroDescription, style: D2.lead(context)),
          ),
        ),
        const SizedBox(height: 40),
        _step(3, _actions(context)),
        const SizedBox(height: 44),
        _step(4, _meta(context)),
      ],
    );
  }

  /// "I build digital experiences with Flutter." — the closing phrase carries
  /// the accent and a thick underline so the emphasis reads as editorial
  /// rather than decorative.
  ///
  /// Built as a single rich text run rather than a Row of words: at 320px the
  /// phrase is wider than the viewport, and only a single run can wrap.
  Widget _headline(BuildContext context) {
    final style = D2.hero(context);

    return Text.rich(
      TextSpan(
        children: [
          const TextSpan(text: 'I build digital experiences '),
          TextSpan(
            text: 'with Flutter.',
            style: style.copyWith(
              color: D2.accent,
              decoration: TextDecoration.underline,
              decorationColor: D2.accent.withValues(alpha: 0.32),
              decorationThickness: 2.5,
            ),
          ),
        ],
      ),
      style: style,
    );
  }

  Widget _actions(BuildContext context) {
    final controller = SectionScope.read(context);
    final reduceMotion = context.reduceMotion;

    return Wrap(
      spacing: 14,
      runSpacing: 14,
      children: [
        D2Button(
          label: 'View projects',
          onPressed: () => controller.scrollTo(
            AppSection.projects,
            reduceMotion: reduceMotion,
          ),
        ),
        D2Button(
          label: 'Contact me',
          filled: false,
          icon: Icons.mail_outline_rounded,
          onPressed: () => controller.scrollTo(
            AppSection.contact,
            reduceMotion: reduceMotion,
          ),
        ),
      ],
    );
  }

  Widget _meta(BuildContext context) {
    return Wrap(
      spacing: 26,
      runSpacing: 14,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _MetaItem(
          label: 'Based in',
          value: PortfolioData.location.split(',').first,
        ),
        _MetaItem(
          label: 'Experience',
          value: '${PortfolioData.yearsExperience} years',
        ),
        _MetaItem(label: 'Shipped', value: '10+ apps'),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SocialDot(
              url: PortfolioData.githubUrl,
              tooltip: 'GitHub',
              child: const BrandIcon(BrandPaths.github, size: 15),
            ),
            const SizedBox(width: 8),
            _SocialDot(
              url: PortfolioData.linkedinUrl,
              tooltip: 'LinkedIn',
              child: const BrandIcon(BrandPaths.linkedin, size: 15),
            ),
            const SizedBox(width: 8),
            _SocialDot(
              url: PortfolioData.mailto,
              tooltip: PortfolioData.email,
              child: const Icon(
                Icons.alternate_email_rounded,
                size: 15,
                color: D2.inkMuted,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ---------------------------------------------------------------- visual
  Widget _visual(BuildContext context) {
    return _step(
      2,
      AnimatedBuilder(
        animation: _drift,
        builder: (context, _) => _FloatingWindow(time: _drift.value),
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label.toUpperCase(), style: D2.label.copyWith(fontSize: 9.5)),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontFamily: D2.body,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: D2.ink,
          ),
        ),
      ],
    );
  }
}

class _SocialDot extends StatelessWidget {
  const _SocialDot({
    required this.url,
    required this.tooltip,
    required this.child,
  });

  final String url;
  final String tooltip;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: HoverRegion(
        onTap: () => Launcher.open(url),
        focusable: true,
        semanticLabel: tooltip,
        builder: (context, state) => AnimatedContainer(
          duration: D2.fast,
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: state.isActive
                ? D2.ink.withValues(alpha: 0.08)
                : Colors.transparent,
            border: Border.all(color: state.isActive ? D2.lineStrong : D2.line),
          ),
          child: IconTheme(
            data: IconThemeData(
              color: state.isActive ? D2.ink : D2.inkMuted,
              size: 15,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// The floating application window: a titled panel of Dart source describing
/// the developer, with technology chips docked underneath and badges orbiting
/// it. Content is generated from [PortfolioData] rather than hard-coded.
class _FloatingWindow extends StatelessWidget {
  const _FloatingWindow({required this.time});

  /// Shared 0–1 clock.
  final double time;

  static const List<(String, Color)> _syntax = [
    ('class ', Color(0xFFE39A6B)),
    ('FlutterDeveloper', Color(0xFFF3E2C7)),
    (' {', Color(0xFF8A8178)),
  ];

  @override
  Widget build(BuildContext context) {
    final float = math.sin(time * 2 * math.pi) * 6;
    final showBadges = context.screenWidth >= 1240;

    final window = Transform.translate(
      offset: Offset(0, float),
      child: Container(
        decoration: BoxDecoration(
          color: D2.surface,
          borderRadius: D2.radius,
          border: Border.all(color: D2.lineStrong),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 60,
              offset: const Offset(0, 30),
            ),
            BoxShadow(
              color: D2.accent.withValues(alpha: 0.07),
              blurRadius: 80,
              spreadRadius: -20,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [_chrome(), _code(context), _dock(context)],
        ),
      ),
    );

    if (!showBadges) return window;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        window,
        Positioned(
          top: -18,
          left: -30,
          child: _Badge(
            time: time,
            phase: 0,
            label: 'Flutter',
            color: const Color(0xFF54C5F8),
            child: const BrandIcon(BrandPaths.flutter, size: 15),
          ),
        ),
        Positioned(
          top: 118,
          right: -34,
          child: _Badge(
            time: time,
            phase: 0.35,
            label: 'Dart',
            color: const Color(0xFF6FC3E8),
            child: const BrandIcon(BrandPaths.dart, size: 15),
          ),
        ),
        Positioned(
          bottom: 46,
          left: -42,
          child: _Badge(
            time: time,
            phase: 0.68,
            label: 'Firebase',
            color: const Color(0xFFFFCA28),
            child: const BrandIcon(BrandPaths.firebase, size: 15),
          ),
        ),
      ],
    );
  }

  Widget _chrome() {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: D2.line)),
      ),
      child: Row(
        children: [
          for (var i = 0; i < 3; i++)
            Padding(
              padding: const EdgeInsets.only(right: 7),
              child: Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: D2.ink.withValues(alpha: 0.14),
                ),
              ),
            ),
          const Spacer(),
          Text(
            'flutter_developer.dart',
            style: D2.label.copyWith(fontSize: 10),
          ),
          const Spacer(),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _code(BuildContext context) {
    final compact = context.screenWidth < 560;
    final size = compact ? 11.0 : 12.5;
    const key = Color(0xFFE39A6B);
    const str = Color(0xFF9BD17F);
    const punct = Color(0xFF8A8178);
    const plain = D2.inkMuted;

    // Skills come from the data layer, so this window can never disagree with
    // the rest of the site.
    final skills = PortfolioData.skillCategories
        .expand((c) => c.skills)
        .take(4)
        .map((s) => s.name)
        .toList();

    return Padding(
      padding: EdgeInsets.fromLTRB(compact ? 14 : 22, 18, 18, 18),
      child: DefaultTextStyle(
        style: TextStyle(
          fontFamily: D2.mono,
          fontSize: size,
          height: 1.75,
          color: plain,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  for (final (text, color) in _syntax)
                    TextSpan(
                      text: text,
                      style: TextStyle(color: color),
                    ),
                ],
              ),
            ),
            Text.rich(
              TextSpan(
                children: const [
                  TextSpan(
                    text: '  final ',
                    style: TextStyle(color: key),
                  ),
                  TextSpan(text: 'name = '),
                  TextSpan(
                    text: '"${PortfolioData.name}"',
                    style: TextStyle(color: str),
                  ),
                  TextSpan(
                    text: ';',
                    style: TextStyle(color: punct),
                  ),
                ],
              ),
            ),
            const Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '  final ',
                    style: TextStyle(color: key),
                  ),
                  TextSpan(text: 'skills = ['),
                ],
              ),
            ),
            for (final skill in skills)
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: '    '),
                    TextSpan(
                      text: skill,
                      style: const TextStyle(color: str),
                    ),
                    const TextSpan(
                      text: ',',
                      style: TextStyle(color: punct),
                    ),
                  ],
                ),
              ),
            const Text('  ];', style: TextStyle(color: punct)),
            const SizedBox(height: 6),
            Text.rich(
              TextSpan(
                children: const [
                  TextSpan(
                    text: '  bool ',
                    style: TextStyle(color: key),
                  ),
                  TextSpan(text: 'get available => '),
                  TextSpan(
                    text: 'true',
                    style: TextStyle(color: key),
                  ),
                  TextSpan(
                    text: ';',
                    style: TextStyle(color: punct),
                  ),
                ],
              ),
            ),
            const Text('}', style: TextStyle(color: punct)),
          ],
        ),
      ),
    );
  }

  Widget _dock(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: D2.ink.withValues(alpha: 0.015),
        border: const Border(top: BorderSide(color: D2.line)),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(18),
          bottomRight: Radius.circular(18),
        ),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final tech in PortfolioData.techChips.take(5))
            D2Tag(tech, dense: true),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.time,
    required this.phase,
    required this.label,
    required this.color,
    required this.child,
  });

  final double time;
  final double phase;
  final String label;
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final angle = (time + phase) * 2 * math.pi;
    return Transform.translate(
      offset: Offset(math.cos(angle * 0.8) * 4, math.sin(angle) * 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
        decoration: BoxDecoration(
          color: D2.surfaceHigh,
          borderRadius: D2.pill,
          border: Border.all(color: D2.lineStrong),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.45),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconTheme(
              data: IconThemeData(color: color, size: 15),
              child: child,
            ),
            const SizedBox(width: 9),
            Text(
              label,
              style: const TextStyle(
                fontFamily: D2.body,
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: D2.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
