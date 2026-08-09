import 'package:flutter/material.dart';

import '../../../models/project.dart';
import '../theme/design_2_theme.dart';

/// A composed device mockup for a project.
///
/// There are no screenshots in the repository, so rather than render an empty
/// grey placeholder this builds a deliberate composition from what is real:
/// the Play Store launcher icon, the app's own brand colour and its name.
///
/// If [Project.screenshots] is populated the first image is shown inside the
/// same frame instead — dropping real screenshots in requires no code change.
class D2ProjectMockup extends StatelessWidget {
  const D2ProjectMockup({
    super.key,
    required this.project,
    required this.hovered,
    this.height = 420,
  });

  final Project project;
  final bool hovered;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: D2.radius,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: D2.radius,
          border: Border.all(color: D2.line),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              project.accent.withValues(alpha: 0.22),
              project.accent.withValues(alpha: 0.04),
              D2.surface,
            ],
            stops: const [0, 0.55, 1],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Soft bloom behind the device, strongest on hover.
            AnimatedOpacity(
              duration: D2.medium,
              opacity: hovered ? 1 : 0.55,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      project.accent.withValues(alpha: 0.30),
                      project.accent.withValues(alpha: 0),
                    ],
                  ),
                ),
                child: const SizedBox.expand(),
              ),
            ),
            AnimatedScale(
              scale: hovered ? 1.04 : 1,
              duration: D2.medium,
              curve: D2.ease,
              child: _DeviceFrame(project: project, height: height * 0.78),
            ),
            Positioned(
              left: 20,
              top: 18,
              child: Text(
                project.category.toUpperCase(),
                style: D2.label.copyWith(
                  fontSize: 9.5,
                  color: D2.ink.withValues(alpha: 0.55),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Phone silhouette holding either a real screenshot or the app's icon.
class _DeviceFrame extends StatelessWidget {
  const _DeviceFrame({required this.project, required this.height});

  final Project project;
  final double height;

  @override
  Widget build(BuildContext context) {
    final width = height * 0.49;

    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: const Color(0xFF0B0B0A),
        borderRadius: BorderRadius.circular(width * 0.13),
        border: Border.all(color: D2.lineStrong, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.55),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(width * 0.10),
        child: project.screenshots.isNotEmpty
            ? Image.asset(
                project.screenshots.first,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _IconCanvas(project: project),
              )
            : _IconCanvas(project: project),
      ),
    );
  }
}

/// The fallback "screen": the launcher icon centred on the project's colour,
/// with its name beneath — reads as an app splash screen, which is honest
/// about being a representation rather than a real capture.
class _IconCanvas extends StatelessWidget {
  const _IconCanvas({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.lerp(project.accent, Colors.black, 0.55)!,
            Color.lerp(project.accent, Colors.black, 0.82)!,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Icon(project: project),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                project.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: D2.display,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                project.tagline,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: D2.body,
                  fontSize: 10.5,
                  height: 1.4,
                  color: Colors.white.withValues(alpha: 0.62),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Icon extends StatelessWidget {
  const _Icon({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    const size = 62.0;
    final fallback = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withValues(alpha: 0.14),
      ),
      child: Text(
        project.initials,
        style: const TextStyle(
          fontFamily: D2.display,
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
    );

    final url = project.iconUrl;
    if (url == null) return fallback;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.network(
        url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        semanticLabel: '${project.name} app icon',
        cacheWidth: (size * MediaQuery.devicePixelRatioOf(context)).round(),
        errorBuilder: (_, _, _) => fallback,
        loadingBuilder: (context, child, progress) =>
            progress == null ? child : fallback,
      ),
    );
  }
}
