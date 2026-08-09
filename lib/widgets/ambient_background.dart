import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/responsive/responsive.dart';
import '../core/theme/app_colors.dart';

/// The page backdrop: a fixed gradient wash, a faint technical grid, three
/// slowly drifting glow fields and a scatter of particles.
///
/// Everything sits inside a single [RepaintBoundary] driven by one ticker, so
/// the whole backdrop costs one repaint per frame and never invalidates the
/// content layer above it. Under reduce-motion the ticker is never started and
/// the scene renders as a still image.
class AmbientBackground extends StatefulWidget {
  const AmbientBackground({super.key, this.particleCount = 34});

  final int particleCount;

  @override
  State<AmbientBackground> createState() => _AmbientBackgroundState();
}

class _AmbientBackgroundState extends State<AmbientBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    // One very long cycle; every element derives its phase from this so there
    // is exactly one ticker for the entire backdrop.
    duration: const Duration(seconds: 60),
  );

  late final List<_Particle> _particles = _buildParticles();
  bool _started = false;

  List<_Particle> _buildParticles() {
    // Fixed seed: the layout is identical on every load, which keeps the
    // first-paint appearance stable and makes visual regressions obvious.
    final random = math.Random(20260809);
    return List.generate(widget.particleCount, (_) {
      return _Particle(
        origin: Offset(random.nextDouble(), random.nextDouble()),
        radius: 0.6 + random.nextDouble() * 1.7,
        drift: Offset(
          (random.nextDouble() - 0.5) * 0.06,
          -0.04 - random.nextDouble() * 0.10,
        ),
        phase: random.nextDouble(),
        opacity: 0.12 + random.nextDouble() * 0.35,
        warm: random.nextDouble() > 0.55,
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (!context.reduceMotion) _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Blobs are scaled down on small screens so they read as atmosphere
    // rather than washing the whole viewport in colour.
    final intensity = context.responsive(
      mobile: 0.75,
      tablet: 0.9,
      laptop: 1.0,
    );

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => CustomPaint(
          size: Size.infinite,
          painter: _BackdropPainter(
            time: _controller.value,
            particles: _particles,
            intensity: intensity,
          ),
        ),
      ),
    );
  }
}

class _Particle {
  const _Particle({
    required this.origin,
    required this.radius,
    required this.drift,
    required this.phase,
    required this.opacity,
    required this.warm,
  });

  /// Start position in normalised (0–1) screen space.
  final Offset origin;
  final double radius;

  /// Movement per full cycle, in normalised units.
  final Offset drift;
  final double phase;
  final double opacity;
  final bool warm;
}

class _BackdropPainter extends CustomPainter {
  const _BackdropPainter({
    required this.time,
    required this.particles,
    required this.intensity,
  });

  final double time;
  final List<_Particle> particles;
  final double intensity;

  static const double _gridSpacing = 64;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    _paintBase(canvas, rect);
    _paintGlowFields(canvas, size);
    _paintGrid(canvas, size);
    _paintParticles(canvas, size);
    _paintVignette(canvas, rect);
  }

  void _paintBase(Canvas canvas, Rect rect) {
    canvas.drawRect(rect, Paint()..color = AppColors.background);
  }

  /// Three large radial fields orbiting on slow, mutually prime cycles so the
  /// composition never visibly repeats.
  void _paintGlowFields(Canvas canvas, Size size) {
    final t = time * 2 * math.pi;
    final diagonal = size.longestSide;

    final fields = <({Offset centre, double radius, Color color})>[
      (
        centre: Offset(
          size.width * (0.18 + 0.06 * math.sin(t)),
          size.height * (0.12 + 0.05 * math.cos(t * 0.8)),
        ),
        radius: diagonal * 0.55,
        color: AppColors.accent.withValues(alpha: 0.17 * intensity),
      ),
      (
        centre: Offset(
          size.width * (0.86 + 0.05 * math.cos(t * 0.7)),
          size.height * (0.30 + 0.07 * math.sin(t * 1.1)),
        ),
        radius: diagonal * 0.45,
        color: AppColors.accentAlt.withValues(alpha: 0.11 * intensity),
      ),
      (
        centre: Offset(
          size.width * (0.50 + 0.10 * math.sin(t * 0.55)),
          size.height * (0.88 + 0.04 * math.cos(t * 0.9)),
        ),
        radius: diagonal * 0.5,
        color: AppColors.accent.withValues(alpha: 0.10 * intensity),
      ),
    ];

    for (final field in fields) {
      final paint = Paint()
        ..shader =
            RadialGradient(
              colors: [field.color, field.color.withValues(alpha: 0)],
              stops: const [0, 1],
            ).createShader(
              Rect.fromCircle(center: field.centre, radius: field.radius),
            );
      canvas.drawCircle(field.centre, field.radius, paint);
    }
  }

  /// Faint technical grid. Fades out towards the bottom of the viewport so it
  /// never competes with text.
  void _paintGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 1
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withValues(alpha: 0.030),
          Colors.white.withValues(alpha: 0.008),
        ],
      ).createShader(Offset.zero & size);

    for (var x = 0.0; x <= size.width; x += _gridSpacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = 0.0; y <= size.height; y += _gridSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  void _paintParticles(Canvas canvas, Size size) {
    final paint = Paint()..isAntiAlias = true;

    for (final particle in particles) {
      final phase = (time + particle.phase) % 1.0;

      // Wrap into 0–1 so particles re-enter from the opposite edge instead of
      // disappearing after one cycle.
      final x = (particle.origin.dx + particle.drift.dx * phase) % 1.0;
      final y = (particle.origin.dy + particle.drift.dy * phase) % 1.0;

      // Fade in and out across the cycle so re-entry is never visible.
      final fade = math.sin(phase * math.pi).clamp(0.0, 1.0);
      final color = particle.warm ? AppColors.accentAlt : AppColors.accent;

      paint.color = color.withValues(alpha: particle.opacity * fade);
      canvas.drawCircle(
        Offset(x * size.width, y * size.height),
        particle.radius,
        paint,
      );
    }
  }

  /// Darkens the extreme edges so content always sits on the quietest part of
  /// the backdrop.
  void _paintVignette(Canvas canvas, Rect rect) {
    canvas.drawRect(
      rect,
      Paint()
        ..shader = RadialGradient(
          center: Alignment.center,
          radius: 0.95,
          colors: [
            AppColors.background.withValues(alpha: 0),
            AppColors.background.withValues(alpha: 0.55),
          ],
          stops: const [0.55, 1],
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(_BackdropPainter old) =>
      old.time != time || old.intensity != intensity;
}
