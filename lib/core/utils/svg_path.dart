import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui';

/// Minimal SVG path-data parser.
///
/// Exists so brand logos can be stored as their canonical path strings without
/// pulling in a full SVG rendering package for what amounts to eight glyphs.
/// Supports the complete path grammar used by icon sets: M/L/H/V/C/S/Q/T/A/Z
/// in both absolute and relative form, implicit repeated parameter sets, and
/// implicit line-to after a move-to.
abstract final class SvgPath {
  /// Parses [data] and returns a [Path] in the coordinate space of the
  /// original `viewBox`.
  static Path parse(String data) {
    final path = Path();
    final tokens = _Tokenizer(data);

    var current = Offset.zero;
    var start = Offset.zero;

    // Last control point, used to reflect for S/T continuations.
    Offset? lastCubicControl;
    Offset? lastQuadControl;

    String? command;

    while (true) {
      final next = tokens.peekCommand();
      if (next != null) {
        command = next;
        tokens.consumeCommand();
      } else if (command == null) {
        break;
      } else if (!tokens.hasNumber) {
        break;
      } else if (command == 'M') {
        // An implicit repeat after a move-to is a line-to.
        command = 'L';
      } else if (command == 'm') {
        command = 'l';
      }

      final relative = command == command.toLowerCase();
      final origin = relative ? current : Offset.zero;

      switch (command.toUpperCase()) {
        case 'M':
          current = origin + tokens.offset();
          start = current;
          path.moveTo(current.dx, current.dy);
          lastCubicControl = lastQuadControl = null;

        case 'L':
          current = origin + tokens.offset();
          path.lineTo(current.dx, current.dy);
          lastCubicControl = lastQuadControl = null;

        case 'H':
          current = Offset(origin.dx + tokens.number(), current.dy);
          path.lineTo(current.dx, current.dy);
          lastCubicControl = lastQuadControl = null;

        case 'V':
          current = Offset(current.dx, origin.dy + tokens.number());
          path.lineTo(current.dx, current.dy);
          lastCubicControl = lastQuadControl = null;

        case 'C':
          final c1 = origin + tokens.offset();
          final c2 = origin + tokens.offset();
          final end = origin + tokens.offset();
          path.cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, end.dx, end.dy);
          lastCubicControl = c2;
          lastQuadControl = null;
          current = end;

        case 'S':
          // Reflect the previous cubic's second control point across `current`.
          final c1 = lastCubicControl == null
              ? current
              : current * 2 - lastCubicControl;
          final c2 = origin + tokens.offset();
          final end = origin + tokens.offset();
          path.cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, end.dx, end.dy);
          lastCubicControl = c2;
          lastQuadControl = null;
          current = end;

        case 'Q':
          final c = origin + tokens.offset();
          final end = origin + tokens.offset();
          path.quadraticBezierTo(c.dx, c.dy, end.dx, end.dy);
          lastQuadControl = c;
          lastCubicControl = null;
          current = end;

        case 'T':
          final c = lastQuadControl == null
              ? current
              : current * 2 - lastQuadControl;
          final end = origin + tokens.offset();
          path.quadraticBezierTo(c.dx, c.dy, end.dx, end.dy);
          lastQuadControl = c;
          lastCubicControl = null;
          current = end;

        case 'A':
          final rx = tokens.number();
          final ry = tokens.number();
          final rotation = tokens.number();
          final largeArc = tokens.flag();
          final sweep = tokens.flag();
          final end = origin + tokens.offset();
          _arcTo(path, current, end, rx, ry, rotation, largeArc, sweep);
          lastCubicControl = lastQuadControl = null;
          current = end;

        case 'Z':
          path.close();
          current = start;
          lastCubicControl = lastQuadControl = null;

        default:
          // Unknown command — bail rather than loop forever.
          return path;
      }
    }

    return path;
  }

  /// Converts an SVG endpoint-parameterised arc into centre form and appends
  /// it to [path]. Follows the implementation notes in the SVG 1.1 spec,
  /// appendix F.6.
  static void _arcTo(
    Path path,
    Offset from,
    Offset to,
    double rx,
    double ry,
    double rotationDegrees,
    bool largeArc,
    bool sweep,
  ) {
    if (rx == 0 || ry == 0) {
      path.lineTo(to.dx, to.dy);
      return;
    }

    rx = rx.abs();
    ry = ry.abs();

    final phi = rotationDegrees * math.pi / 180;
    final cosPhi = math.cos(phi);
    final sinPhi = math.sin(phi);

    final dx2 = (from.dx - to.dx) / 2;
    final dy2 = (from.dy - to.dy) / 2;

    final x1p = cosPhi * dx2 + sinPhi * dy2;
    final y1p = -sinPhi * dx2 + cosPhi * dy2;

    // Scale the radii up if they are too small to span the endpoints.
    final lambda = (x1p * x1p) / (rx * rx) + (y1p * y1p) / (ry * ry);
    if (lambda > 1) {
      final scale = math.sqrt(lambda);
      rx *= scale;
      ry *= scale;
    }

    final sign = largeArc != sweep ? 1.0 : -1.0;
    final numerator =
        rx * rx * ry * ry - rx * rx * y1p * y1p - ry * ry * x1p * x1p;
    final denominator = rx * rx * y1p * y1p + ry * ry * x1p * x1p;
    final coefficient = sign * math.sqrt(math.max(0, numerator) / denominator);

    final cxp = coefficient * rx * y1p / ry;
    final cyp = -coefficient * ry * x1p / rx;

    final cx = cosPhi * cxp - sinPhi * cyp + (from.dx + to.dx) / 2;
    final cy = sinPhi * cxp + cosPhi * cyp + (from.dy + to.dy) / 2;

    double angle(double ux, double uy, double vx, double vy) {
      final dot = ux * vx + uy * vy;
      final len = math.sqrt(ux * ux + uy * uy) * math.sqrt(vx * vx + vy * vy);
      var value = math.acos((dot / len).clamp(-1.0, 1.0));
      if (ux * vy - uy * vx < 0) value = -value;
      return value;
    }

    final startAngle = angle(1, 0, (x1p - cxp) / rx, (y1p - cyp) / ry);
    var sweepAngle = angle(
      (x1p - cxp) / rx,
      (y1p - cyp) / ry,
      (-x1p - cxp) / rx,
      (-y1p - cyp) / ry,
    );

    if (!sweep && sweepAngle > 0) {
      sweepAngle -= 2 * math.pi;
    } else if (sweep && sweepAngle < 0) {
      sweepAngle += 2 * math.pi;
    }

    // `arcTo` cannot express the x-axis rotation, so rotate the whole path
    // around the ellipse centre instead.
    final oval = Rect.fromCenter(
      center: Offset(cx, cy),
      width: rx * 2,
      height: ry * 2,
    );

    if (phi == 0) {
      path.arcTo(oval, startAngle, sweepAngle, false);
      return;
    }

    final sub = Path()..arcTo(oval, startAngle, sweepAngle, false);
    path.addPath(
      sub.transform(_rotationAround(Offset(cx, cy), phi)),
      Offset.zero,
    );
  }

  /// Column-major 4x4 matrix rotating by [radians] about [center].
  static Float64List _rotationAround(Offset center, double radians) {
    final c = math.cos(radians);
    final s = math.sin(radians);
    final tx = center.dx - c * center.dx + s * center.dy;
    final ty = center.dy - s * center.dx - c * center.dy;
    return Float64List.fromList([
      c, s, 0, 0, //
      -s, c, 0, 0, //
      0, 0, 1, 0, //
      tx, ty, 0, 1,
    ]);
  }

  /// Scales a path parsed from a `viewBox` of [sourceSize] to fit [targetSize].
  static Path fit(Path path, double sourceSize, double targetSize) {
    final scale = targetSize / sourceSize;
    return path.transform(
      Float64List.fromList([
        scale, 0, 0, 0, //
        0, scale, 0, 0, //
        0, 0, 1, 0, //
        0, 0, 0, 1,
      ]),
    );
  }
}

/// Walks a path-data string producing commands, numbers and arc flags.
class _Tokenizer {
  _Tokenizer(this._data);

  final String _data;
  int _index = 0;

  void _skipSeparators() {
    while (_index < _data.length) {
      final c = _data.codeUnitAt(_index);
      // space, tab, CR, LF, comma
      if (c == 0x20 || c == 0x09 || c == 0x0D || c == 0x0A || c == 0x2C) {
        _index++;
      } else {
        break;
      }
    }
  }

  static bool _isCommand(int c) {
    if (c >= 0x41 && c <= 0x5A) return c != 0x45; // A-Z except E (exponent)
    if (c >= 0x61 && c <= 0x7A) return c != 0x65; // a-z except e
    return false;
  }

  String? peekCommand() {
    _skipSeparators();
    if (_index >= _data.length) return null;
    final c = _data.codeUnitAt(_index);
    return _isCommand(c) ? _data[_index] : null;
  }

  void consumeCommand() => _index++;

  bool get hasNumber {
    _skipSeparators();
    if (_index >= _data.length) return false;
    final c = _data.codeUnitAt(_index);
    return (c >= 0x30 && c <= 0x39) || c == 0x2D || c == 0x2B || c == 0x2E;
  }

  double number() {
    _skipSeparators();
    final startIndex = _index;
    var seenDigit = false;
    var seenDot = false;
    var seenExponent = false;

    if (_index < _data.length) {
      final c = _data.codeUnitAt(_index);
      if (c == 0x2D || c == 0x2B) _index++; // leading sign
    }

    while (_index < _data.length) {
      final c = _data.codeUnitAt(_index);

      if (c >= 0x30 && c <= 0x39) {
        seenDigit = true;
        _index++;
      } else if (c == 0x2E && !seenDot && !seenExponent) {
        // A SECOND '.' starts a new number: path data legally packs
        // "11.385.6.113" to mean 11.385, 0.6, 0.113. Stop here.
        seenDot = true;
        _index++;
      } else if ((c == 0x45 || c == 0x65) && seenDigit && !seenExponent) {
        // Exponent — consume it along with an optional sign, but only if a
        // digit actually follows, otherwise this 'e' belongs to something
        // else entirely.
        final next = _index + 1 < _data.length
            ? _data.codeUnitAt(_index + 1)
            : 0;
        final afterSign = _index + 2 < _data.length
            ? _data.codeUnitAt(_index + 2)
            : 0;
        final signedDigit =
            (next == 0x2D || next == 0x2B) &&
            afterSign >= 0x30 &&
            afterSign <= 0x39;
        if (!(next >= 0x30 && next <= 0x39) && !signedDigit) break;

        seenExponent = true;
        _index++;
        if (next == 0x2D || next == 0x2B) _index++;
      } else {
        break;
      }
    }

    return double.parse(_data.substring(startIndex, _index));
  }

  Offset offset() => Offset(number(), number());

  /// Arc flags are single characters and may be packed without separators
  /// ("1 0" can legally appear as "10").
  bool flag() {
    _skipSeparators();
    final c = _data[_index];
    _index++;
    return c == '1';
  }
}
