import 'package:flutter/material.dart';

import '../../animations/hover_region.dart';
import '../../animations/typing_text.dart';
import '../../core/constants/app_constants.dart';
import '../../core/responsive/responsive.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/launcher.dart';
import '../../core/utils/section_controller.dart';
import '../../data/portfolio_data.dart';
import '../../widgets/brand_icons.dart';
import '../../widgets/buttons.dart';
import '../../widgets/gradient_text.dart';
import '../../widgets/tech_chip.dart';
import 'code_terminal.dart';
import 'floating_tech.dart';

/// First screen. Everything above the fold animates on mount rather than on
/// scroll, staggered from a single controller.
class HeroSection extends StatefulWidget {
  const HeroSection({super.key, this.anchorKey});

  final Key? anchorKey;

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with TickerProviderStateMixin {
  /// Drives the one-shot entrance stagger.
  late final AnimationController _entrance = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  );

  /// Continuous clock shared by every floating element.
  late final AnimationController _ambient = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 14),
  );

  Offset _pointer = Offset.zero;
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
      _ambient.repeat();
    }
  }

  @override
  void dispose() {
    _entrance.dispose();
    _ambient.dispose();
    super.dispose();
  }

  /// Fade + rise for the [order]-th element in the entrance sequence.
  Widget _staggered(int order, Widget child) {
    final start = (order * 0.075).clamp(0.0, 0.7);
    final animation = CurvedAnimation(
      parent: _entrance,
      curve: Interval(
        start,
        (start + 0.42).clamp(0.0, 1.0),
        curve: AppCurves.emphasized,
      ),
    );

    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, child) => Opacity(
        opacity: animation.value,
        child: Transform.translate(
          offset: Offset(0, 26 * (1 - animation.value)),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = context.screenWidth >= 1000;
    final topInset =
        AppSizes.navHeight +
        context.responsive(mobile: 48.0, tablet: 64.0, laptop: 72.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(key: widget.anchorKey, height: 0),
        ConstrainedBox(
          // Fills the first screen on desktop without forcing a scroll-jail
          // on short laptop windows.
          constraints: BoxConstraints(
            minHeight: isWide
                ? (context.screenHeight * 0.92).clamp(600.0, 900.0)
                : 0,
          ),
          child: Padding(
            padding: EdgeInsets.only(
              top: topInset,
              bottom: context.responsive(mobile: 72.0, laptop: 96.0),
            ),
            child: ContentContainer(
              child: isWide ? _wideLayout(context) : _narrowLayout(context),
            ),
          ),
        ),
      ],
    );
  }

  Widget _wideLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 6, child: _copy(context)),
        const SizedBox(width: 56),
        Expanded(flex: 5, child: _visual(context)),
      ],
    );
  }

  Widget _narrowLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _copy(context),
        SizedBox(height: context.responsive(mobile: 56.0, tablet: 72.0)),
        _visual(context),
      ],
    );
  }

  // ---------------------------------------------------------------- copy
  Widget _copy(BuildContext context) {
    final headlineStyle = AppText.display(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _staggered(
          0,
          const StatusBadge(
            label: PortfolioData.availability,
            color: Color(0xFF4ADE80),
            pulse: true,
          ),
        ),
        const SizedBox(height: 26),
        _staggered(1, const Eyebrow('Flutter Developer', showRule: false)),
        const SizedBox(height: 18),
        _staggered(
          2,
          Text(
            'Hi, I\'m ${PortfolioData.name}.',
            style: AppText.lead(context).copyWith(
              fontFamily: AppFonts.display,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(height: 14),
        _staggered(
          3,
          HighlightedHeadline(
            text: PortfolioData.heroHeadline,
            highlight: PortfolioData.heroHighlight,
            style: headlineStyle,
          ),
        ),
        const SizedBox(height: 20),
        _staggered(
          4,
          Row(
            children: [
              Container(
                width: 2,
                height: 22,
                margin: const EdgeInsets.only(right: 12),
                decoration: const BoxDecoration(
                  gradient: AppColors.accentGradient,
                ),
              ),
              Flexible(
                child: TypingText(
                  words: PortfolioData.heroRoles,
                  style: AppText.lead(context).copyWith(
                    fontFamily: AppFonts.mono,
                    fontSize: 15,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 26),
        _staggered(
          5,
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Text(
              PortfolioData.heroDescription,
              style: AppText.lead(context),
            ),
          ),
        ),
        const SizedBox(height: 38),
        _staggered(6, _actions(context)),
        const SizedBox(height: 34),
        _staggered(7, _socials(context)),
      ],
    );
  }

  Widget _actions(BuildContext context) {
    final controller = SectionScope.read(context);
    final reduceMotion = context.reduceMotion;

    return Wrap(
      spacing: 14,
      runSpacing: 14,
      children: [
        PrimaryButton(
          label: 'View my work',
          onPressed: () => controller.scrollTo(
            AppSection.projects,
            reduceMotion: reduceMotion,
          ),
        ),
        SecondaryButton(
          label: 'Let\'s connect',
          icon: Icons.mail_outline_rounded,
          onPressed: () => controller.scrollTo(
            AppSection.contact,
            reduceMotion: reduceMotion,
          ),
        ),
      ],
    );
  }

  Widget _socials(BuildContext context) {
    return Row(
      children: [
        IconActionButton(
          onPressed: () => Launcher.open(PortfolioData.githubUrl),
          tooltip: 'GitHub — ${PortfolioData.githubHandle}',
          size: 42,
          child: const BrandIcon(BrandPaths.github, semanticLabel: 'GitHub'),
        ),
        const SizedBox(width: 10),
        IconActionButton(
          onPressed: () => Launcher.open(PortfolioData.linkedinUrl),
          tooltip: 'LinkedIn',
          size: 42,
          accent: const Color(0xFF0A66C2),
          child: const BrandIcon(
            BrandPaths.linkedin,
            semanticLabel: 'LinkedIn',
          ),
        ),
        const SizedBox(width: 10),
        IconActionButton(
          onPressed: () => Launcher.open(PortfolioData.mailto),
          tooltip: PortfolioData.email,
          size: 42,
          accent: AppColors.accentAlt,
          icon: Icons.alternate_email_rounded,
        ),
        const SizedBox(width: 20),
        Container(width: 1, height: 26, color: AppColors.border),
        const SizedBox(width: 20),
        Flexible(
          child: Text(
            PortfolioData.location,
            style: AppText.caption,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // -------------------------------------------------------------- visual
  Widget _visual(BuildContext context) {
    return _staggered(
      4,
      HoverRegion(
        builder: (context, state) {
          // Pointer drives a gentle parallax across the floating badges.
          _pointer = state.normalized;

          return AnimatedBuilder(
            animation: _ambient,
            builder: (context, _) => FloatingTechCluster(
              time: _ambient.value,
              pointer: context.reduceMotion ? Offset.zero : _pointer,
              child: const CodeTerminal(),
            ),
          );
        },
      ),
    );
  }
}
