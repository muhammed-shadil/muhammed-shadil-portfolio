import 'package:flutter/material.dart';

import '../../animations/scroll_visibility.dart';
import '../../core/utils/section_controller.dart';
import 'sections/d2_about.dart';
import 'sections/d2_experience.dart';
import 'sections/d2_hero.dart';
import 'sections/d2_nav.dart';
import 'sections/d2_process_contact.dart';
import 'sections/d2_projects.dart';
import 'sections/d2_skills.dart';
import 'theme/design_2_theme.dart';
import 'widgets/d2_background.dart';

/// Design 2 — "Studio".
///
/// Reads the same [PortfolioData] as every other design and shares the
/// scroll/anchor machinery, but owns its entire visual language: warm
/// monochrome, oversized Manrope, one coral accent, hairline rules instead of
/// glass, and full-width alternating project panels.
class Design2Portfolio extends StatefulWidget {
  const Design2Portfolio({super.key});

  @override
  State<Design2Portfolio> createState() => _Design2PortfolioState();
}

class _Design2PortfolioState extends State<Design2Portfolio> {
  final SectionController _controller = SectionController();
  bool _menuOpen = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SectionScope(
      controller: _controller,
      child: ScrollProvider(
        offset: _controller.offset,
        child: Scaffold(
          backgroundColor: D2.bg,
          body: Stack(
            children: [
              const Positioned.fill(child: D2Background()),
              Scrollbar(
                controller: _controller.scrollController,
                child: SingleChildScrollView(
                  controller: _controller.scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      D2Hero(anchorKey: _controller.keyOf(AppSection.home)),
                      D2About(anchorKey: _controller.keyOf(AppSection.about)),
                      D2Skills(anchorKey: _controller.keyOf(AppSection.skills)),
                      D2Projects(
                        anchorKey: _controller.keyOf(AppSection.projects),
                      ),
                      D2Experience(
                        anchorKey: _controller.keyOf(AppSection.experience),
                      ),
                      const D2Process(),
                      D2Contact(
                        anchorKey: _controller.keyOf(AppSection.contact),
                      ),
                      const D2Footer(),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: D2Nav(
                  onOpenMenu: () => setState(() => _menuOpen = true),
                ),
              ),
              if (_menuOpen)
                D2Menu(onClose: () => setState(() => _menuOpen = false)),
            ],
          ),
        ),
      ),
    );
  }
}
