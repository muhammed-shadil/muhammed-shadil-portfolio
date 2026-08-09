import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../widgets/glass_card.dart';

/// Token classes for the little syntax highlighter below.
enum _Token { keyword, type, string, property, punctuation, comment, plain }

extension on _Token {
  Color get color => switch (this) {
    _Token.keyword => const Color(0xFFC792EA),
    _Token.type => const Color(0xFF82AAFF),
    _Token.string => const Color(0xFFC3E88D),
    _Token.property => const Color(0xFF7FDBCA),
    _Token.punctuation => const Color(0xFF89929E),
    _Token.comment => const Color(0xFF5C6773),
    _Token.plain => AppColors.textSecondary,
  };
}

typedef _Span = (String text, _Token token);

/// Glassmorphic editor window that types out a Dart class describing the
/// developer, then holds. The hero's visual anchor.
class CodeTerminal extends StatefulWidget {
  const CodeTerminal({super.key});

  @override
  State<CodeTerminal> createState() => _CodeTerminalState();
}

class _CodeTerminalState extends State<CodeTerminal> {
  /// The source, pre-tokenised. Written by hand rather than parsed — it is one
  /// fixed snippet, and a real Dart lexer would be a lot of code for no gain.
  static const List<List<_Span>> _lines = [
    [
      ('class ', _Token.keyword),
      ('Developer', _Token.type),
      (' {', _Token.punctuation),
    ],
    [
      ('  final ', _Token.keyword),
      ('String', _Token.type),
      (' name = ', _Token.plain),
      ('"Muhammed Shadil"', _Token.string),
      (';', _Token.punctuation),
    ],
    [
      ('  final ', _Token.keyword),
      ('String', _Token.type),
      (' stack = ', _Token.plain),
      ('"Flutter"', _Token.string),
      (';', _Token.punctuation),
    ],
    [
      ('  final ', _Token.keyword),
      ('List', _Token.type),
      ('<', _Token.punctuation),
      ('String', _Token.type),
      ('> ships = [', _Token.plain),
    ],
    [
      ('    ', _Token.plain),
      ('"Play Store"', _Token.string),
      (', ', _Token.punctuation),
      ('"App Store"', _Token.string),
      (',', _Token.punctuation),
    ],
    [('  ];', _Token.punctuation)],
    [('', _Token.plain)],
    [
      ('  ', _Token.plain),
      ('Future', _Token.type),
      ('<', _Token.punctuation),
      ('void', _Token.keyword),
      ('> ', _Token.punctuation),
      ('build', _Token.property),
      ('(', _Token.punctuation),
      ('Idea', _Token.type),
      (' idea) ', _Token.plain),
      ('async', _Token.keyword),
      (' {', _Token.punctuation),
    ],
    [
      ('    ', _Token.plain),
      ('await', _Token.keyword),
      (' design.', _Token.plain),
      ('refine', _Token.property),
      ('(idea);', _Token.punctuation),
    ],
    [
      ('    ', _Token.plain),
      ('return', _Token.keyword),
      (' ship.', _Token.plain),
      ('toProduction', _Token.property),
      ('();', _Token.punctuation),
    ],
    [('  }', _Token.punctuation)],
    [('}', _Token.punctuation)],
  ];

  Timer? _timer;
  int _visibleLines = 0;
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;

    if (context.reduceMotion) {
      _visibleLines = _lines.length;
      return;
    }
    // Reveal one line at a time — cheaper than per-character typing and reads
    // as code being written rather than pasted.
    _timer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      if (!mounted || _visibleLines >= _lines.length) {
        timer.cancel();
        return;
      }
      setState(() => _visibleLines++);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final compact = context.screenWidth < 520;

    return GlassCard(
      padding: EdgeInsets.zero,
      borderRadius: AppRadii.lgAll,
      blur: 12,
      glowStrength: 0.35,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _chrome(compact),
          Padding(
            padding: EdgeInsets.fromLTRB(compact ? 12 : 20, 16, 16, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < _lines.length; i++)
                  _CodeLine(
                    number: i + 1,
                    spans: _lines[i],
                    visible: i < _visibleLines,
                    showCaret:
                        i == _visibleLines - 1 && _visibleLines < _lines.length,
                    compact: compact,
                  ),
              ],
            ),
          ),
          _statusBar(compact),
        ],
      ),
    );
  }

  Widget _chrome(bool compact) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        border: const Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          for (final color in const [
            Color(0xFFFF5F57),
            Color(0xFFFEBC2E),
            Color(0xFF28C840),
          ])
            Padding(
              padding: const EdgeInsets.only(right: 7),
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withValues(alpha: 0.85),
                ),
              ),
            ),
          const SizedBox(width: 10),
          if (!compact)
            Expanded(
              child: Center(
                child: Text(
                  'developer.dart',
                  style: AppText.chip.copyWith(
                    color: AppColors.textTertiary,
                    fontSize: 11.5,
                  ),
                ),
              ),
            )
          else
            const Spacer(),
          Icon(
            Icons.circle,
            size: 7,
            color: AppColors.accentAlt.withValues(alpha: 0.8),
          ),
          const SizedBox(width: 6),
          Text(
            'saved',
            style: AppText.chip.copyWith(
              color: AppColors.textTertiary,
              fontSize: 10.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBar(bool compact) {
    const items = ['Flutter', 'Dart', 'Firebase', 'REST API'];

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 12 : 18,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.025),
        border: const Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          for (final item in items)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 5,
                  height: 5,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.accentGradient,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  item,
                  style: AppText.chip.copyWith(
                    fontSize: 10.5,
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(width: 6),
              ],
            ),
        ],
      ),
    );
  }
}

class _CodeLine extends StatelessWidget {
  const _CodeLine({
    required this.number,
    required this.spans,
    required this.visible,
    required this.showCaret,
    required this.compact,
  });

  final int number;
  final List<_Span> spans;
  final bool visible;
  final bool showCaret;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final fontSize = compact ? 11.0 : 12.5;

    return AnimatedOpacity(
      opacity: visible ? 1 : 0,
      duration: AppDurations.fast,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 1.5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: compact ? 20 : 26,
              child: Text(
                '$number',
                style: AppText.code.copyWith(
                  fontSize: fontSize - 1,
                  color: AppColors.textTertiary.withValues(alpha: 0.55),
                ),
              ),
            ),
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    for (final (text, token) in spans)
                      TextSpan(
                        text: text,
                        style: TextStyle(color: token.color),
                      ),
                    if (showCaret)
                      const TextSpan(
                        text: '▌',
                        style: TextStyle(color: AppColors.accentAlt),
                      ),
                  ],
                ),
                style: AppText.code.copyWith(fontSize: fontSize, height: 1.6),
                softWrap: false,
                overflow: TextOverflow.clip,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
