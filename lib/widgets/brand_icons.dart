import 'package:flutter/material.dart';

import '../core/utils/svg_path.dart';

/// Canonical 24×24 logo path data, rendered through [SvgPath].
///
/// Keeping the glyphs as path strings means adding a logo later is a one-line
/// change and costs no extra dependency.
abstract final class BrandPaths {
  static const String github =
      'M12 .297c-6.63 0-12 5.373-12 12 0 5.303 3.438 9.8 8.205 11.385.6.113.82-.258.82-.577 '
      '0-.285-.01-1.04-.015-2.04-3.338.724-4.042-1.61-4.042-1.61C4.422 18.07 3.633 17.7 3.633 '
      '17.7c-1.087-.744.084-.729.084-.729 1.205.084 1.838 1.236 1.838 1.236 1.07 1.835 2.809 '
      '1.305 3.495.998.108-.776.417-1.305.76-1.605-2.665-.3-5.466-1.332-5.466-5.93 '
      '0-1.31.465-2.38 1.235-3.221-.135-.303-.54-1.523.105-3.176 0 0 1.005-.322 3.3 '
      '1.23.96-.267 1.98-.399 3-.405 1.02.006 2.04.138 3 .405 2.28-1.552 3.285-1.23 '
      '3.285-1.23.645 1.653.24 2.873.12 3.176.765.84 1.23 1.911 1.23 3.221 0 4.609-2.805 '
      '5.624-5.475 5.921.42.36.81 1.096.81 2.22 0 1.606-.015 2.896-.015 3.286 0 .315.21.69.825.57C20.565 '
      '22.092 24 17.592 24 12.297c0-6.627-5.373-12-12-12';

  static const String linkedin =
      'M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 '
      '2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 '
      '4.267 5.455v6.286zM5.337 7.433c-1.144 0-2.063-.926-2.063-2.065 0-1.138.92-2.063 '
      '2.063-2.063 1.14 0 2.064.925 2.064 2.063 0 1.139-.925 2.065-2.064 2.065zm1.782 '
      '13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 '
      '24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.222 0h.003z';

  static const String instagram =
      'M12 0C8.74 0 8.333.015 7.053.072 5.775.132 4.905.333 4.14.63c-.789.306-1.459.717-2.126 '
      '1.384S.935 3.35.63 4.14C.333 4.905.131 5.775.072 7.053.012 8.333 0 8.74 0 12s.015 3.667.072 '
      '4.947c.06 1.277.261 2.148.558 2.913.306.788.717 1.459 1.384 2.126.667.666 1.336 1.079 '
      '2.126 1.384.766.296 1.636.499 2.913.558C8.333 23.988 8.74 24 12 24s3.667-.015 '
      '4.947-.072c1.277-.06 2.148-.262 2.913-.558.788-.306 1.459-.718 2.126-1.384.666-.667 '
      '1.079-1.335 1.384-2.126.296-.765.499-1.636.558-2.913.06-1.28.072-1.687.072-4.947s-.015-3.667-.072-4.947c-.06-1.277-.262-2.149-.558-2.913-.306-.789-.718-1.459-1.384-2.126C21.319 '
      '1.347 20.651.935 19.86.63c-.765-.297-1.636-.499-2.913-.558C15.667.012 15.26 0 12 '
      '0zm0 2.16c3.203 0 3.585.016 4.85.071 1.17.055 1.805.249 2.227.415.562.217.96.477 '
      '1.382.896.419.42.679.819.896 1.381.164.422.36 1.057.413 2.227.057 1.266.07 1.646.07 '
      '4.85s-.015 3.585-.074 4.85c-.061 1.17-.256 1.805-.421 2.227-.224.562-.479.96-.899 '
      '1.382-.419.419-.824.679-1.38.896-.42.164-1.065.36-2.235.413-1.274.057-1.649.07-4.859.07-3.211 '
      '0-3.586-.015-4.859-.074-1.171-.061-1.816-.256-2.236-.421-.569-.224-.96-.479-1.379-.899-.421-.419-.69-.824-.9-1.38-.165-.42-.359-1.065-.42-2.235-.045-1.26-.061-1.649-.061-4.844 '
      '0-3.196.016-3.586.061-4.861.061-1.17.255-1.814.42-2.234.21-.57.479-.96.9-1.381.419-.419.81-.689 '
      '1.379-.898.42-.166 1.051-.361 2.221-.421 1.275-.045 1.65-.06 4.859-.06l.045.03zm0 '
      '3.678a6.162 6.162 0 100 12.324 6.162 6.162 0 000-12.324zM12 16c-2.209 0-4-1.791-4-4s1.791-4 '
      '4-4 4 1.791 4 4-1.791 4-4 4zm7.846-10.405a1.441 1.441 0 01-2.88 0 1.44 1.44 0 012.88 0z';

  static const String facebook =
      'M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 '
      '11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 '
      '2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 '
      '3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z';

  static const String flutter =
      'M14.314 0L2.3 12 6 15.7 21.684.012h-7.357L14.314 0zm.014 11.072l-6.471 6.457 6.47 '
      '6.47H21.7l-6.46-6.468 6.46-6.46h-7.371z';

  static const String dart =
      'M4.105 4.105S9.158 1.58 11.684.316a3.079 3.079 0 011.481-.315c.766.047 1.677.788 '
      '1.677.788L24 9.948v10.105h-4.211V24H9.789l-9-9v-6.947l3.316-3.948zm.42.842v.001l-3.052 '
      '3.632L9.16 16.26l6.157-6.947-1.263-3.789a1.5 1.5 0 00-.63-.752 1.526 1.526 0 '
      '00-1.474-.05L4.526 4.947zm10.523 4.526L9.79 16.263h9.79V9.474h-4.741zM4.105 '
      '5.79v9.264l4.21 4.21V9.998L4.106 5.789zm5.895 11.578v5.79h9.79v-5.79H10z';

  static const String firebase =
      'M3.89 15.673L6.255.461A.542.542 0 017.27.288l2.543 4.771zm16.794 3.692l-2.25-14a.54.54 '
      '0 00-.919-.295L3.316 19.365l7.856 4.427a1.621 1.621 0 001.588 0zM14.3 7.147l-1.82-3.482a.542.542 '
      '0 00-.96 0L3.53 17.984z';
}

/// Draws a 24×24 logo path scaled to [size] and filled with [color].
class BrandIcon extends StatelessWidget {
  const BrandIcon(
    this.pathData, {
    super.key,
    this.size = 20,
    this.color,
    this.gradient,
    this.semanticLabel,
  });

  final String pathData;
  final double size;
  final Color? color;
  final Gradient? gradient;
  final String? semanticLabel;

  /// Parsed paths are cached — a logo is parsed once per session no matter how
  /// many times it appears.
  static final Map<String, Path> _cache = {};

  static Path _pathFor(String data) => _cache[data] ??= SvgPath.parse(data);

  @override
  Widget build(BuildContext context) {
    final resolved = color ?? IconTheme.of(context).color ?? Colors.white;

    return Semantics(
      label: semanticLabel,
      image: semanticLabel != null,
      child: SizedBox.square(
        dimension: size,
        child: CustomPaint(
          painter: _BrandPainter(
            path: _pathFor(pathData),
            color: resolved,
            gradient: gradient,
          ),
        ),
      ),
    );
  }
}

class _BrandPainter extends CustomPainter {
  const _BrandPainter({required this.path, required this.color, this.gradient});

  final Path path;
  final Color color;
  final Gradient? gradient;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.shortestSide / 24;
    final paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;

    if (gradient != null) {
      paint.shader = gradient!.createShader(Offset.zero & size);
    } else {
      paint.color = color;
    }

    canvas
      ..save()
      ..scale(scale)
      ..drawPath(path, paint)
      ..restore();
  }

  @override
  bool shouldRepaint(_BrandPainter old) =>
      old.path != path || old.color != color || old.gradient != gradient;
}
