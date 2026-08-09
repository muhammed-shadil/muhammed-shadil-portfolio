import 'package:flutter/material.dart';

import '../theme/design_2_theme.dart';

/// Studio's backdrop.
///
/// Deliberately static: no ticker, no particles, no orbiting glow fields.
/// Design 1's animated atmosphere is part of its identity; Studio's identity
/// is stillness and paper-like flatness, so the backdrop is a single painted
/// frame that never repaints. It also means this design costs zero frames per
/// second when the page is idle.
class D2Background extends StatelessWidget {
  const D2Background({super.key});

  @override
  Widget build(BuildContext context) {
    return const RepaintBoundary(
      child: CustomPaint(size: Size.infinite, painter: _D2BackgroundPainter()),
    );
  }
}

class _D2BackgroundPainter extends CustomPainter {
  const _D2BackgroundPainter();

  /// Column guides, echoing the editorial grid the layout sits on.
  static const int _columns = 6;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = D2.bg);

    // A single warm wash in the top-left, where the hero headline sits.
    final wash = Paint()
      ..shader =
          RadialGradient(
            colors: [
              D2.accent.withValues(alpha: 0.055),
              D2.accent.withValues(alpha: 0),
            ],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.18, size.height * 0.10),
              radius: size.longestSide * 0.55,
            ),
          );
    canvas.drawRect(Offset.zero & size, wash);

    // Vertical guides only, and only on wide viewports — on a phone they
    // would be noise rather than structure.
    if (size.width >= 1040) {
      final gutter = size.width < 1280 ? 56.0 : 72.0;
      final usable = (size.width - gutter * 2).clamp(0.0, D2.maxWidth);
      final left = (size.width - usable) / 2;
      final step = usable / _columns;

      final line = Paint()
        ..strokeWidth = 1
        ..color = D2.ink.withValues(alpha: 0.022);

      for (var i = 0; i <= _columns; i++) {
        final x = left + step * i;
        canvas.drawLine(Offset(x, 0), Offset(x, size.height), line);
      }
    }
  }

  @override
  bool shouldRepaint(_D2BackgroundPainter oldDelegate) => false;
}
