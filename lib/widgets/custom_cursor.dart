import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show Ticker;

import '../core/responsive/responsive.dart';
import '../core/theme/app_colors.dart';

/// What the cursor should look like right now.
enum CursorMode {
  /// Default dot + ring.
  idle,

  /// Over something clickable — the ring expands and brightens.
  interactive,

  /// Over a project card — the ring grows into a labelled disc.
  view,
}

/// Process-wide cursor state.
///
/// A singleton rather than an inherited widget on purpose: hover callbacks all
/// over the tree need to write to it, and threading a controller through every
/// card would add ceremony for a single pointer that can only be in one place.
abstract final class AppCursor {
  static final ValueNotifier<Offset?> position = ValueNotifier<Offset?>(null);
  static final ValueNotifier<CursorMode> mode = ValueNotifier<CursorMode>(
    CursorMode.idle,
  );
  static final ValueNotifier<String?> label = ValueNotifier<String?>(null);

  /// True when the custom cursor layer is mounted and driving the pointer.
  /// Widgets check this before suppressing their own system cursor.
  static bool enabled = false;

  static void enter(CursorMode next, {String? withLabel}) {
    if (!enabled) return;
    mode.value = next;
    label.value = withLabel;
  }

  static void exit() {
    if (!enabled) return;
    mode.value = CursorMode.idle;
    label.value = null;
  }
}

/// Tracks the pointer and paints the dot + trailing ring above the page.
///
/// Mounted only when [ResponsiveContext.hasPointer] is true, so touch devices
/// never pay for it. The native cursor is hidden underneath, except over text
/// inputs which set their own I-beam and therefore win.
class CustomCursorLayer extends StatefulWidget {
  const CustomCursorLayer({super.key, required this.child});

  final Widget child;

  @override
  State<CustomCursorLayer> createState() => _CustomCursorLayerState();
}

class _CustomCursorLayerState extends State<CustomCursorLayer>
    with SingleTickerProviderStateMixin {
  // Created eagerly rather than as a lazy `late final`: on a touch device the
  // build method returns early and never touches the ticker, and a lazy field
  // would then be *constructed* inside dispose(), where looking up the
  // TickerMode ancestor is illegal.
  late final Ticker _ticker;

  Offset _ringPosition = Offset.zero;
  Offset _dotPosition = Offset.zero;
  double _ringScale = 1;
  bool _hasPointer = false;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
    AppCursor.position.addListener(_onPointerMoved);
    AppCursor.mode.addListener(_onModeChanged);
  }

  void _onPointerMoved() {
    final next = AppCursor.position.value;
    if (next == null) {
      if (_hasPointer) setState(() => _hasPointer = false);
      return;
    }
    if (!_hasPointer) {
      // First sighting — drop both rings on the pointer so they don't fly in
      // from the top-left corner.
      _ringPosition = next;
      _dotPosition = next;
      setState(() => _hasPointer = true);
    }
    if (!_ticker.isActive) _ticker.start();
  }

  void _onModeChanged() {
    if (!_ticker.isActive) _ticker.start();
  }

  void _onTick(Duration elapsed) {
    final target = AppCursor.position.value;
    if (target == null) return;

    final targetScale = switch (AppCursor.mode.value) {
      CursorMode.idle => 1.0,
      CursorMode.interactive => 1.9,
      CursorMode.view => 3.6,
    };

    // Exponential smoothing: the dot tracks almost exactly, the ring lags,
    // which is what reads as "weight".
    final nextRing = Offset.lerp(_ringPosition, target, 0.18)!;
    final nextDot = Offset.lerp(_dotPosition, target, 0.55)!;
    final nextScale = _ringScale + (targetScale - _ringScale) * 0.16;

    final settled =
        (nextRing - target).distance < 0.4 &&
        (nextScale - targetScale).abs() < 0.005;

    setState(() {
      _ringPosition = nextRing;
      _dotPosition = nextDot;
      _ringScale = settled ? targetScale : nextScale;
    });

    // Stop ticking once everything has caught up — an idle pointer costs
    // nothing.
    if (settled) _ticker.stop();
  }

  @override
  void dispose() {
    AppCursor.position.removeListener(_onPointerMoved);
    AppCursor.mode.removeListener(_onModeChanged);
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!context.hasPointer || context.reduceMotion) {
      AppCursor.enabled = false;
      return widget.child;
    }
    AppCursor.enabled = true;

    return MouseRegion(
      cursor: SystemMouseCursors.none,
      onHover: (event) => AppCursor.position.value = event.position,
      onExit: (_) => AppCursor.position.value = null,
      child: Stack(
        children: [
          widget.child,
          if (_hasPointer)
            Positioned.fill(
              child: IgnorePointer(
                child: RepaintBoundary(
                  child: CustomPaint(
                    painter: _CursorPainter(
                      ring: _ringPosition,
                      dot: _dotPosition,
                      scale: _ringScale,
                      mode: AppCursor.mode.value,
                    ),
                    child: AppCursor.label.value == null
                        ? null
                        : _CursorLabel(
                            position: _ringPosition,
                            text: AppCursor.label.value!,
                          ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CursorLabel extends StatelessWidget {
  const _CursorLabel({required this.position, required this.text});

  final Offset position;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: position.dx - 40,
          top: position.dy - 7,
          width: 80,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 10,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w500,
              color: Color(0xFF08080B),
            ),
          ),
        ),
      ],
    );
  }
}

class _CursorPainter extends CustomPainter {
  const _CursorPainter({
    required this.ring,
    required this.dot,
    required this.scale,
    required this.mode,
  });

  final Offset ring;
  final Offset dot;
  final double scale;
  final CursorMode mode;

  static const double _baseRingRadius = 15;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = _baseRingRadius * scale;
    final expansion = ((scale - 1) / 2.6).clamp(0.0, 1.0);

    if (mode == CursorMode.view) {
      // Fully filled disc that the label sits on top of.
      canvas.drawCircle(
        ring,
        radius,
        Paint()
          ..shader = AppColors.accentGradient.createShader(
            Rect.fromCircle(center: ring, radius: radius),
          ),
      );
    } else {
      canvas
        ..drawCircle(
          ring,
          radius,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.4
            ..color = AppColors.accentAlt.withValues(
              alpha: 0.35 + 0.35 * expansion,
            ),
        )
        // Soft fill that appears as the ring expands over a target.
        ..drawCircle(
          ring,
          radius,
          Paint()..color = AppColors.accent.withValues(alpha: 0.10 * expansion),
        );
    }

    // The dot shrinks away as the ring takes over.
    final dotRadius = 3.2 * math.max(0, 1 - expansion * 1.15);
    if (dotRadius > 0.2 && mode != CursorMode.view) {
      canvas.drawCircle(
        dot,
        dotRadius,
        Paint()..color = AppColors.textPrimary.withValues(alpha: 0.9),
      );
    }
  }

  @override
  bool shouldRepaint(_CursorPainter old) =>
      old.ring != ring ||
      old.dot != dot ||
      old.scale != scale ||
      old.mode != mode;
}
