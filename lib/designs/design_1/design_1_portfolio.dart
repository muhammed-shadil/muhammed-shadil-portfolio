import 'package:flutter/material.dart';

import '../../animations/scroll_visibility.dart';
import '../../core/utils/section_controller.dart';
import 'sections/about/about_section.dart';
import 'sections/contact/contact_section.dart';
import 'sections/experience/experience_section.dart';
import 'sections/footer/footer.dart';
import 'sections/github/github_section.dart';
import 'sections/hero/hero_section.dart';
import 'sections/navbar/navbar.dart';
import 'sections/process/process_section.dart';
import 'sections/projects/projects_section.dart';
import 'sections/resume/resume_section.dart';
import 'sections/skills/skills_section.dart';
import '../../widgets/ambient_background.dart';
import '../../widgets/custom_cursor.dart';
import '../../widgets/scroll_to_top_button.dart';

/// Design 1 — the original portfolio: dark glass surfaces, violet-to-cyan
/// accents, a single scrolling page with a pushed case-study route.
///
/// Composition order matters: the ambient backdrop is painted once behind
/// everything, the page scrolls above it, and the nav plus the custom cursor
/// float on top.
class Design1Portfolio extends StatefulWidget {
  const Design1Portfolio({super.key});

  @override
  State<Design1Portfolio> createState() => _Design1PortfolioState();
}

class _Design1PortfolioState extends State<Design1Portfolio> {
  final SectionController _controller = SectionController();

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
        child: CustomCursorLayer(
          child: Scaffold(
            body: Stack(
              children: [
                // Fixed backdrop — never scrolls, repaints in isolation.
                const Positioned.fill(child: AmbientBackground()),
                NavShell(child: _page()),
                const Positioned(
                  right: 24,
                  bottom: 24,
                  child: ScrollToTopButton(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _page() {
    return Scrollbar(
      controller: _controller.scrollController,
      child: SingleChildScrollView(
        controller: _controller.scrollController,
        // Sections are all above-the-fold-adjacent and cheap once revealed, so
        // a single scroll view beats a sliver list here and keeps anchoring
        // simple and exact.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HeroSection(anchorKey: _controller.keyOf(AppSection.home)),
            AboutSection(anchorKey: _controller.keyOf(AppSection.about)),
            SkillsSection(anchorKey: _controller.keyOf(AppSection.skills)),
            ProjectsSection(anchorKey: _controller.keyOf(AppSection.projects)),
            ExperienceSection(
              anchorKey: _controller.keyOf(AppSection.experience),
            ),
            const ProcessSection(),
            const GithubSection(),
            const ResumeSection(),
            ContactSection(anchorKey: _controller.keyOf(AppSection.contact)),
            const Footer(),
          ],
        ),
      ),
    );
  }
}
