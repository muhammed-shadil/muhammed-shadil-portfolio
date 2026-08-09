import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/section_controller.dart';
import '../../../../widgets/buttons.dart';
import 'nav_logo.dart';
import 'nav_item.dart';
import 'mobile_menu.dart';

/// Sticky top navigation.
///
/// Transparent over the hero, then compacts and picks up a frosted background
/// once the page scrolls. Carries a hairline scroll-progress bar along its
/// bottom edge.
class Navbar extends StatelessWidget {
  const Navbar({super.key, required this.onOpenMenu});

  final VoidCallback onOpenMenu;

  @override
  Widget build(BuildContext context) {
    final controller = SectionScope.of(context);
    final scrolled = controller.isScrolled;
    final showFullNav = context.screenWidth >= 900;

    return AnimatedContainer(
      duration: AppDurations.medium,
      curve: AppCurves.standard,
      height: scrolled ? AppSizes.navHeightCompact : AppSizes.navHeight,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: scrolled ? AppColors.border : Colors.transparent,
          ),
        ),
      ),
      child: ClipRect(
        child: BackdropFilter(
          // Only frosts once there is content behind it to frost.
          filter: ImageFilter.blur(
            sigmaX: scrolled ? 18 : 0,
            sigmaY: scrolled ? 18 : 0,
          ),
          child: AnimatedContainer(
            duration: AppDurations.medium,
            color: AppColors.background.withValues(
              alpha: scrolled ? 0.72 : 0.0,
            ),
            child: Stack(
              children: [
                ContentContainer(
                  child: Row(
                    children: [
                      NavLogo(
                        onTap: () => controller.scrollToTop(
                          reduceMotion: context.reduceMotion,
                        ),
                      ),
                      const Spacer(),
                      if (showFullNav) ...[
                        // Scales the link row down rather than overflowing
                        // when the labels, the font or the zoom level are
                        // wider than expected.
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerRight,
                            child: _NavItems(controller: controller),
                          ),
                        ),
                        const SizedBox(width: 24),
                        _NavActions(controller: controller),
                      ] else
                        IconActionButton(
                          onPressed: onOpenMenu,
                          tooltip: 'Open menu',
                          icon: Icons.menu_rounded,
                          size: 42,
                        ),
                    ],
                  ),
                ),
                const Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: _ScrollProgressBar(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItems extends StatelessWidget {
  const _NavItems({required this.controller});

  final SectionController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final section in AppSection.values)
          NavItem(
            label: section.label,
            active: controller.active == section,
            onTap: () => controller.scrollTo(
              section,
              reduceMotion: context.reduceMotion,
            ),
          ),
      ],
    );
  }
}

class _NavActions extends StatelessWidget {
  const _NavActions({required this.controller});

  final SectionController controller;

  @override
  Widget build(BuildContext context) {
    // The availability badge lives in the hero, so it is deliberately not
    // repeated here — both would be on screen at once.
    return Row(
      children: [
        PrimaryButton(
          label: 'Let\'s talk',
          compact: true,
          icon: Icons.north_east_rounded,
          onPressed: () => controller.scrollTo(
            AppSection.contact,
            reduceMotion: context.reduceMotion,
          ),
        ),
      ],
    );
  }
}

/// Two-pixel gradient bar showing how far down the page the visitor is.
class _ScrollProgressBar extends StatelessWidget {
  const _ScrollProgressBar();

  @override
  Widget build(BuildContext context) {
    final controller = SectionScope.read(context);

    return ValueListenableBuilder<double>(
      valueListenable: controller.offset,
      builder: (context, offset, _) {
        final progress = controller.scrollProgress;

        return Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: progress,
            child: Container(
              height: 2,
              decoration: const BoxDecoration(
                gradient: AppColors.accentGradient,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Wraps the page content so the nav floats above it and the mobile menu can
/// take over the full viewport.
class NavShell extends StatefulWidget {
  const NavShell({super.key, required this.child});

  final Widget child;

  @override
  State<NavShell> createState() => _NavShellState();
}

class _NavShellState extends State<NavShell> {
  bool _menuOpen = false;

  void _setMenu(bool open) => setState(() => _menuOpen = open);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Navbar(onOpenMenu: () => _setMenu(true)),
        ),
        if (_menuOpen) MobileMenu(onClose: () => _setMenu(false)),
      ],
    );
  }
}
