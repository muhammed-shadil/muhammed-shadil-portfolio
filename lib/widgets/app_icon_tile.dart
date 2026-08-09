import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
import '../core/theme/app_typography.dart';
import '../models/project.dart';

/// A project's launcher icon inside a coloured halo.
///
/// Store icons are loaded from Google's CDN. If that request is blocked or the
/// project has no public listing, the tile falls back to a gradient monogram —
/// so a missing image never leaves a hole in the grid.
class AppIconTile extends StatelessWidget {
  const AppIconTile({
    super.key,
    required this.project,
    this.size = 64,
    this.glow = 0,
  });

  final Project project;
  final double size;

  /// 0–1; drives the strength of the coloured halo behind the icon.
  final double glow;

  @override
  Widget build(BuildContext context) {
    final radius = size * 0.26;
    final t = glow.clamp(0.0, 1.0);

    return AnimatedContainer(
      duration: AppDurations.fast,
      curve: AppCurves.standard,
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            project.accent.withValues(alpha: 0.30 + 0.20 * t),
            project.accent.withValues(alpha: 0.08 + 0.10 * t),
          ],
        ),
        border: Border.all(
          color: project.accent.withValues(alpha: 0.30 + 0.35 * t),
        ),
        boxShadow: [
          BoxShadow(
            color: project.accent.withValues(alpha: 0.18 + 0.32 * t),
            blurRadius: 20 + 22 * t,
            spreadRadius: -6,
            offset: Offset(0, 8 + 4 * t),
          ),
        ],
      ),
      padding: EdgeInsets.all(size * 0.14),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius * 0.7),
        child: _IconContent(project: project, size: size),
      ),
    );
  }
}

class _IconContent extends StatelessWidget {
  const _IconContent({required this.project, required this.size});

  final Project project;
  final double size;

  @override
  Widget build(BuildContext context) {
    final fallback = _Monogram(project: project, size: size);
    final url = project.iconUrl;
    if (url == null) return fallback;

    return Image.network(
      url,
      fit: BoxFit.cover,
      semanticLabel: '${project.name} app icon',
      // Cache at roughly the rendered resolution rather than the source 512px.
      cacheWidth: (size * MediaQuery.devicePixelRatioOf(context)).round(),
      errorBuilder: (context, error, stack) => fallback,
      loadingBuilder: (context, child, progress) =>
          progress == null ? child : fallback,
    );
  }
}

class _Monogram extends StatelessWidget {
  const _Monogram({required this.project, required this.size});

  final Project project;
  final double size;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            project.accent.withValues(alpha: 0.9),
            project.accent.withValues(alpha: 0.45),
          ],
        ),
      ),
      child: Center(
        child: Text(
          project.initials,
          style: AppText.subtitle.copyWith(
            fontSize: size * 0.30,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
