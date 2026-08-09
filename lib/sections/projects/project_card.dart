import 'package:flutter/material.dart';

import '../../animations/hover_region.dart';
import '../../core/constants/app_constants.dart';
import '../../core/responsive/responsive.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/launcher.dart';
import '../../models/project.dart';
import '../../widgets/app_icon_tile.dart';
import '../../widgets/custom_cursor.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/tech_chip.dart';

/// A project tile.
///
/// Tinted with the app's own brand colour so the grid reads as a shelf of real
/// products rather than a set of identical boxes. Tapping anywhere opens the
/// case study; the store pill is a nested tap target that opens the listing
/// directly.
class ProjectCard extends StatelessWidget {
  const ProjectCard({
    super.key,
    required this.project,
    required this.onOpen,
    this.wide = false,
  });

  final Project project;
  final VoidCallback onOpen;

  /// Wide cards lay the icon and copy out side by side.
  final bool wide;

  @override
  Widget build(BuildContext context) {
    return HoverLift(
      onTap: onOpen,
      lift: 8,
      semanticLabel: '${project.name} — ${project.tagline}. Open case study.',
      builder: (context, state) {
        final active = state.isActive;

        return GlassCard(
          accent: project.accent,
          glowStrength: active ? 0.85 : 0,
          padding: EdgeInsets.all(
            context.responsive(mobile: 20.0, laptop: 26.0),
          ),
          child: Stack(
            children: [
              // Corner wash in the project's colour, strongest on hover.
              Positioned(
                top: -70,
                right: -70,
                child: AnimatedOpacity(
                  opacity: active ? 1 : 0.45,
                  duration: AppDurations.fast,
                  child: Container(
                    width: 190,
                    height: 190,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          project.accent.withValues(alpha: 0.30),
                          project.accent.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              wide && !context.isHandset
                  ? _wideBody(context, active)
                  : _stackedBody(context, active),
            ],
          ),
        );
      },
    );
  }

  // ------------------------------------------------------------- layouts
  Widget _stackedBody(BuildContext context, bool active) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_icon(context, active, 58), const Spacer(), _statusChip()],
        ),
        const SizedBox(height: 22),
        _titleBlock(context),
        const SizedBox(height: 14),
        Text(
          project.summary,
          style: AppText.bodySmall,
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 20),
        _techRow(maxChips: 4),
        // Equal-height rows leave slack in the shorter card; pinning the
        // footer to the bottom makes that slack read as deliberate spacing
        // rather than a gap under the text.
        const Spacer(),
        const SizedBox(height: 22),
        _footer(context, active),
      ],
    );
  }

  Widget _wideBody(BuildContext context, bool active) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _icon(context, active, 72),
            const SizedBox(height: 18),
            _statusChip(),
          ],
        ),
        const SizedBox(width: 26),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _titleBlock(context),
              const SizedBox(height: 14),
              Text(
                project.summary,
                style: AppText.body,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 20),
              _techRow(maxChips: 6),
              const Spacer(),
              const SizedBox(height: 24),
              _footer(context, active),
            ],
          ),
        ),
      ],
    );
  }

  // -------------------------------------------------------------- pieces
  Widget _icon(BuildContext context, bool active, double size) {
    return Hero(
      tag: 'project-icon-${project.id}',
      // Flutter's default hero flight uses a Material shuttle that would clip
      // the glow; render the tile itself throughout the flight instead.
      flightShuttleBuilder: (_, _, _, _, _) =>
          AppIconTile(project: project, size: size, glow: 1),
      child: AppIconTile(project: project, size: size, glow: active ? 1 : 0),
    );
  }

  Widget _statusChip() {
    final color = switch (project.status) {
      ProjectStatus.live => const Color(0xFF4ADE80),
      ProjectStatus.companyInternal => AppColors.textTertiary,
      ProjectStatus.openSource => AppColors.accentAlt,
      ProjectStatus.inProgress => AppColors.accentWarm,
    };

    return StatusBadge(
      label: project.status == ProjectStatus.live
          ? 'Live'
          : project.status.label,
      color: color,
      pulse: project.status == ProjectStatus.live,
    );
  }

  Widget _titleBlock(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                project.name,
                style: AppText.title(context),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              project.category,
              style: AppText.chip.copyWith(
                color: project.accent.withValues(alpha: 0.85),
                fontSize: 10.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          project.tagline,
          style: AppText.caption.copyWith(color: AppColors.textTertiary),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _techRow({required int maxChips}) {
    final shown = project.tech.take(maxChips).toList();
    final remaining = project.tech.length - shown.length;

    return Wrap(
      spacing: 7,
      runSpacing: 7,
      children: [
        for (final tech in shown)
          TechChip(tech, accent: project.accent, compact: true, filled: true),
        if (remaining > 0) TechChip('+$remaining more', compact: true),
      ],
    );
  }

  Widget _footer(BuildContext context, bool active) {
    final link = project.primaryLink;

    return Row(
      children: [
        AnimatedDefaultTextStyle(
          duration: AppDurations.fast,
          style: AppText.button.copyWith(
            fontSize: 13.5,
            color: active ? project.accent : AppColors.textSecondary,
          ),
          child: const Text('View case study'),
        ),
        const SizedBox(width: 7),
        AnimatedSlide(
          offset: Offset(active ? 0.3 : 0, 0),
          duration: AppDurations.fast,
          curve: AppCurves.standard,
          child: Icon(
            Icons.arrow_forward_rounded,
            size: 15,
            color: active ? project.accent : AppColors.textTertiary,
          ),
        ),
        const Spacer(),
        if (link != null)
          _StorePill(project: project, link: link, active: active),
      ],
    );
  }
}

/// Nested tap target that jumps straight to the store or repo. Fills with the
/// project's colour on hover.
class _StorePill extends StatelessWidget {
  const _StorePill({
    required this.project,
    required this.link,
    required this.active,
  });

  final Project project;
  final ProjectLink link;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return HoverRegion(
      onTap: () => Launcher.open(link.url),
      focusable: true,
      cursorMode: CursorMode.interactive,
      semanticLabel: '${project.name} on ${link.kind.label}',
      builder: (context, state) {
        final hot = state.isActive;

        return AnimatedContainer(
          duration: AppDurations.fast,
          curve: AppCurves.standard,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: AppRadii.pill,
            color: hot
                ? project.accent.withValues(alpha: 0.9)
                : project.accent.withValues(alpha: active ? 0.16 : 0.08),
            border: Border.all(
              color: project.accent.withValues(alpha: hot ? 1 : 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                link.kind.icon,
                size: 13,
                color: hot ? Colors.white : project.accent,
              ),
              const SizedBox(width: 6),
              Text(
                link.kind.label,
                style: AppText.chip.copyWith(
                  fontSize: 10.5,
                  color: hot ? Colors.white : project.accent,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
