import 'package:flutter/material.dart';

import '../../animations/scroll_visibility.dart';
import '../../core/utils/section_controller.dart';
import 'sections/d3_about.dart';
import 'sections/d3_hero.dart';
import 'sections/d3_nav_contact.dart';
import 'sections/d3_terminal.dart';
import 'sections/d3_work.dart';
import 'theme/design_3_theme.dart';

/// Design 3 — "Index".
///
/// Same [PortfolioData], same scroll machinery, entirely different premise: a
/// printed editorial index on bone paper, with one inverted terminal band.
///
/// Section order differs from the other designs on purpose — the work index
/// comes early, and the terminal sits between experience and contact as a
/// change of pace rather than as a footer curiosity.
class Design3Portfolio extends StatefulWidget {
  const Design3Portfolio({super.key});

  @override
  State<Design3Portfolio> createState() => _Design3PortfolioState();
}

class _Design3PortfolioState extends State<Design3Portfolio> {
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
          backgroundColor: D3.paper,
          body: Stack(
            children: [
              Scrollbar(
                controller: _controller.scrollController,
                child: SingleChildScrollView(
                  controller: _controller.scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      D3Hero(anchorKey: _controller.keyOf(AppSection.home)),
                      D3About(anchorKey: _controller.keyOf(AppSection.about)),
                      D3Work(anchorKey: _controller.keyOf(AppSection.projects)),
                      D3Experience(
                        anchorKey: _controller.keyOf(AppSection.experience),
                      ),
                      // Index has no standalone skills section: `$ stack
                      // --list` in the terminal *is* the skills content, so
                      // the nav's Skills entry anchors here.
                      D3Terminal(
                        anchorKey: _controller.keyOf(AppSection.skills),
                      ),
                      D3Contact(
                        anchorKey: _controller.keyOf(AppSection.contact),
                      ),
                      const D3Footer(),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: D3Nav(
                  onOpenMenu: () => setState(() => _menuOpen = true),
                ),
              ),
              if (_menuOpen)
                D3Menu(onClose: () => setState(() => _menuOpen = false)),
            ],
          ),
        ),
      ),
    );
  }
}
