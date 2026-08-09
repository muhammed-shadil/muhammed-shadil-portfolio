import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../animations/reveal.dart';
import '../../core/constants/app_constants.dart';
import '../../core/responsive/responsive.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/launcher.dart';
import '../../models/project.dart';
import '../../widgets/app_icon_tile.dart';
import '../../widgets/buttons.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/section_shell.dart';
import '../../widgets/tech_chip.dart';

/// Full-screen case study for a single project.
///
/// Pushed as a route rather than a dialog so the browser back button and the
/// Escape key both behave the way a visitor expects.
class ProjectDetailPage extends StatelessWidget {
  const ProjectDetailPage({super.key, required this.project});

  final Project project;

  static Route<void> route(Project project) {
    return PageRouteBuilder<void>(
      transitionDuration: AppDurations.medium,
      reverseTransitionDuration: AppDurations.fast,
      pageBuilder: (context, animation, secondary) =>
          ProjectDetailPage(project: project),
      transitionsBuilder: (context, animation, secondary, child) {
        final eased = CurvedAnimation(
          parent: animation,
          curve: AppCurves.emphasized,
          reverseCurve: Curves.easeIn,
        );
        return FadeTransition(
          opacity: eased,
          child: SlideTransition(
            position: Tween(
              begin: const Offset(0, 0.035),
              end: Offset.zero,
            ).animate(eased),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Shortcuts(
        shortcuts: const {
          SingleActivator(LogicalKeyboardKey.escape): DismissIntent(),
        },
        child: Actions(
          actions: {
            DismissIntent: CallbackAction<DismissIntent>(
              onInvoke: (_) => Navigator.of(context).maybePop(),
            ),
          },
          child: FocusScope(
            autofocus: true,
            child: Stack(
              children: [
                // Wash of the project's own colour behind the header.
                Positioned(
                  top: -260,
                  left: -120,
                  right: -120,
                  height: 700,
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            project.accent.withValues(alpha: 0.22),
                            project.accent.withValues(alpha: 0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                _body(context),
                Positioned(top: 0, left: 0, right: 0, child: _topBar(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------------ bars
  Widget _topBar(BuildContext context) {
    return Container(
      height: AppSizes.navHeight,
      color: AppColors.background.withValues(alpha: 0.85),
      child: ContentContainer(
        maxWidth: 1080,
        child: Row(
          children: [
            SecondaryButton(
              label: 'Back to work',
              icon: Icons.arrow_back_rounded,
              compact: true,
              onPressed: () => Navigator.of(context).maybePop(),
            ),
            const Spacer(),
            if (!context.isHandset)
              Text(
                project.name,
                style: AppText.chip.copyWith(color: AppColors.textTertiary),
              ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------------ body
  Widget _body(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: AppSizes.navHeight + 32),
          SectionShell(
            maxWidth: 1080,
            topPadding: 0,
            bottomPadding: 0,
            child: _header(context),
          ),
          const SizedBox(height: 56),
          SectionShell(
            maxWidth: 1080,
            topPadding: 0,
            bottomPadding: 0,
            child: _content(context),
          ),
          const SizedBox(height: 72),
          _nextCta(context),
          const SizedBox(height: 64),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    final link = project.primaryLink;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: 'project-icon-${project.id}',
              flightShuttleBuilder: (_, _, _, _, _) => AppIconTile(
                project: project,
                size: context.isHandset ? 72 : 92,
                glow: 1,
              ),
              child: AppIconTile(
                project: project,
                size: context.isHandset ? 72 : 92,
                glow: 0.8,
              ),
            ),
            const SizedBox(width: 22),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        project.category,
                        style: AppText.eyebrow.copyWith(
                          color: project.accent,
                          fontSize: 11,
                        ),
                      ),
                      if (project.year != null)
                        Text(
                          '· ${project.year}',
                          style: AppText.chip.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(project.name, style: AppText.headline(context)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 26),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Text(
            project.tagline,
            style: AppText.lead(context).copyWith(
              color: AppColors.textPrimary,
              fontSize: context.responsive(mobile: 17.0, laptop: 21.0),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Text(project.summary, style: AppText.lead(context)),
        ),
        const SizedBox(height: 30),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (link != null)
              PrimaryButton(
                label: link.kind == LinkKind.github
                    ? 'View source'
                    : 'Open on ${link.kind.label}',
                icon: link.kind.icon,
                onPressed: () => Launcher.open(link.url),
              ),
            for (final other in project.links.where((l) => l != link))
              SecondaryButton(
                label: other.kind.label,
                icon: other.kind.icon,
                onPressed: () => Launcher.open(other.url),
              ),
            StatusBadge(
              label: project.status.label,
              color: project.status == ProjectStatus.live
                  ? const Color(0xFF4ADE80)
                  : project.accent,
              pulse: project.status == ProjectStatus.live,
            ),
          ],
        ),
      ],
    );
  }

  Widget _content(BuildContext context) {
    final isWide = context.screenWidth >= 900;

    final narrative = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < project.detailBlocks.length; i++)
          Reveal.at(
            i,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 28),
              child: _NarrativeBlock(
                block: project.detailBlocks[i],
                accent: project.accent,
              ),
            ),
          ),
        if (project.features.isNotEmpty) ...[
          const SizedBox(height: 4),
          Reveal(child: _featureList(context)),
        ],
      ],
    );

    final sidebar = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Reveal(child: _metaCard(context)),
        if (project.architecture.isNotEmpty) ...[
          const SizedBox(height: 20),
          Reveal.at(
            1,
            child: _bulletCard(
              context,
              title: 'Architecture',
              icon: Icons.account_tree_rounded,
              items: project.architecture,
            ),
          ),
        ],
        if (project.results.isNotEmpty) ...[
          const SizedBox(height: 20),
          Reveal.at(
            2,
            child: _bulletCard(
              context,
              title: 'Results',
              icon: Icons.trending_up_rounded,
              items: project.results,
            ),
          ),
        ],
      ],
    );

    if (!isWide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [narrative, const SizedBox(height: 32), sidebar],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 7, child: narrative),
        const SizedBox(width: 44),
        Expanded(flex: 5, child: sidebar),
      ],
    );
  }

  Widget _featureList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Key features',
          style: AppText.title(context).copyWith(fontSize: 20),
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final feature in project.features)
              SizedBox(
                // 280 rather than 300: two columns have to fit inside the
                // narrative column, which is 7/12 of a 1080px page.
                width: context.isHandset ? double.infinity : 280,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: project.accent,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(feature, style: AppText.bodySmall)),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _metaCard(BuildContext context) {
    return GlassCard(
      accent: project.accent,
      glowStrength: 0.25,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Eyebrow('Project', showRule: false),
          const SizedBox(height: 20),
          if (project.role != null) ...[
            _metaRow('Role', project.role!),
            const SizedBox(height: 14),
          ],
          if (project.year != null) ...[
            _metaRow('Year', project.year!),
            const SizedBox(height: 14),
          ],
          _metaRow('Status', project.status.label),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 20),
          Text(
            'Built with',
            style: AppText.caption.copyWith(color: AppColors.textTertiary),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final tech in project.tech)
                TechChip(tech, accent: project.accent, filled: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metaRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 62,
          child: Text(
            label,
            style: AppText.caption.copyWith(color: AppColors.textTertiary),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppText.bodySmall.copyWith(color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }

  Widget _bulletCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<String> items,
  }) {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 17, color: project.accent),
              const SizedBox(width: 10),
              Text(title, style: AppText.subtitle.copyWith(fontSize: 15.5)),
            ],
          ),
          const SizedBox(height: 18),
          for (var i = 0; i < items.length; i++)
            Padding(
              padding: EdgeInsets.only(bottom: i == items.length - 1 ? 0 : 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: project.accent.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(items[i], style: AppText.bodySmall)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _nextCta(BuildContext context) {
    return ContentContainer(
      maxWidth: 1080,
      child: GlassCard(
        padding: EdgeInsets.symmetric(
          horizontal: context.responsive(mobile: 24.0, laptop: 40.0),
          vertical: context.responsive(mobile: 32.0, laptop: 44.0),
        ),
        accent: project.accent,
        glowStrength: 0.3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Want something like this built?',
              style: AppText.title(context),
            ),
            const SizedBox(height: 12),
            Text(
              'I take on Flutter work end to end — architecture, integration, '
              'store release.',
              style: AppText.body,
            ),
            const SizedBox(height: 26),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                PrimaryButton(
                  label: 'Get in touch',
                  icon: Icons.mail_outline_rounded,
                  onPressed: () => Launcher.open(
                    'mailto:muhammedshadil220@gmail.com'
                    '?subject=Project%20enquiry',
                  ),
                ),
                SecondaryButton(
                  label: 'Back to all work',
                  icon: Icons.grid_view_rounded,
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NarrativeBlock extends StatelessWidget {
  const _NarrativeBlock({required this.block, required this.accent});

  final DetailBlock block;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AccentTile(
              accent: accent,
              size: 34,
              radius: 10,
              child: Icon(block.icon, size: 16, color: accent),
            ),
            const SizedBox(width: 13),
            Text(
              block.title,
              style: AppText.title(context).copyWith(fontSize: 19),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Padding(
          padding: const EdgeInsets.only(left: 47),
          child: Text(block.body, style: AppText.body.copyWith(fontSize: 14.5)),
        ),
      ],
    );
  }
}
