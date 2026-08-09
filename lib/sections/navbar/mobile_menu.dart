import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../animations/hover_region.dart';
import '../../core/constants/app_constants.dart';
import '../../core/responsive/responsive.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/launcher.dart';
import '../../core/utils/section_controller.dart';
import '../../data/portfolio_data.dart';
import '../../widgets/brand_icons.dart';
import '../../widgets/buttons.dart';
import '../../widgets/tech_chip.dart';
import 'nav_logo.dart';

/// Full-screen navigation overlay for handsets and small tablets.
///
/// Items stagger in, Escape closes it, and focus is trapped inside while it is
/// open so keyboard users cannot tab into the page behind.
class MobileMenu extends StatefulWidget {
  const MobileMenu({super.key, required this.onClose});

  final VoidCallback onClose;

  @override
  State<MobileMenu> createState() => _MobileMenuState();
}

class _MobileMenuState extends State<MobileMenu>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppDurations.medium,
    reverseDuration: AppDurations.fast,
  )..forward();

  late final Animation<double> _eased = CurvedAnimation(
    parent: _controller,
    curve: AppCurves.emphasized,
    reverseCurve: Curves.easeIn,
  );

  Future<void> _close() async {
    await _controller.reverse();
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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sections = AppSection.values;

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
              animation: _eased,
              builder: (context, _) {
                final t = _eased.value;

                return Opacity(
                  opacity: t.clamp(0.0, 1.0),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 22 * t, sigmaY: 22 * t),
                    child: Container(
                      color: AppColors.background.withValues(alpha: 0.94 * t),
                      child: SafeArea(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _header(context),
                            Expanded(
                              child: SingleChildScrollView(
                                padding: EdgeInsets.symmetric(
                                  horizontal: context.pageGutter,
                                  vertical: 12,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    for (var i = 0; i < sections.length; i++)
                                      _MenuRow(
                                        index: i,
                                        progress: t,
                                        section: sections[i],
                                        onTap: () => _go(sections[i]),
                                      ),
                                    const SizedBox(height: 28),
                                    PrimaryButton(
                                      label: 'Let\'s talk',
                                      expand: true,
                                      icon: Icons.mail_outline_rounded,
                                      onPressed: () => _go(AppSection.contact),
                                    ),
                                    const SizedBox(height: 12),
                                    SecondaryButton(
                                      label: 'Download resume',
                                      expand: true,
                                      icon: Icons.download_rounded,
                                      onPressed: () => Launcher.open(
                                        PortfolioData.resumeDownloadUrl,
                                      ),
                                    ),
                                    const SizedBox(height: 32),
                                    _socials(),
                                    const SizedBox(height: 24),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
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

  Widget _header(BuildContext context) {
    return SizedBox(
      height: AppSizes.navHeight,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.pageGutter),
        child: Row(
          children: [
            const NavLogo(),
            const Spacer(),
            IconActionButton(
              onPressed: _close,
              tooltip: 'Close menu',
              icon: Icons.close_rounded,
              size: 42,
            ),
          ],
        ),
      ),
    );
  }

  Widget _socials() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Eyebrow('Elsewhere'),
        const SizedBox(height: 16),
        Row(
          children: [
            IconActionButton(
              onPressed: () => Launcher.open(PortfolioData.githubUrl),
              tooltip: 'GitHub',
              child: const BrandIcon(BrandPaths.github),
            ),
            const SizedBox(width: 10),
            IconActionButton(
              onPressed: () => Launcher.open(PortfolioData.linkedinUrl),
              tooltip: 'LinkedIn',
              child: const BrandIcon(BrandPaths.linkedin),
            ),
            const SizedBox(width: 10),
            IconActionButton(
              onPressed: () => Launcher.open(PortfolioData.mailto),
              tooltip: 'Email',
              icon: Icons.alternate_email_rounded,
            ),
          ],
        ),
      ],
    );
  }
}

/// One row in the overlay: index, label, chevron — staggered by [index].
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
    // Each row starts 60ms after the one above it, expressed as a slice of
    // the parent's 0–1 progress.
    final start = (index * 0.09).clamp(0.0, 0.6);
    final local = ((progress - start) / (1 - start)).clamp(0.0, 1.0);

    return Opacity(
      opacity: local,
      child: Transform.translate(
        offset: Offset(0, 28 * (1 - local)),
        child: HoverRegion(
          onTap: onTap,
          focusable: true,
          semanticLabel: 'Go to ${section.label}',
          builder: (context, state) {
            final active = state.isActive;

            return AnimatedContainer(
              duration: AppDurations.fast,
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: [
                  Text(
                    '0${index + 1}',
                    style: AppText.chip.copyWith(
                      color: active
                          ? AppColors.accentAlt
                          : AppColors.textTertiary,
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: AnimatedDefaultTextStyle(
                      duration: AppDurations.fast,
                      style: AppText.title(context).copyWith(
                        fontSize: 24,
                        color: active
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                      ),
                      child: Text(section.label),
                    ),
                  ),
                  AnimatedSlide(
                    offset: Offset(active ? 0.25 : 0, 0),
                    duration: AppDurations.fast,
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      size: 18,
                      color: active
                          ? AppColors.accentAlt
                          : AppColors.textTertiary,
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
