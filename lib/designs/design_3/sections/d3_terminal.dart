import 'dart:async';

import 'package:flutter/material.dart';

import '../../../animations/scroll_visibility.dart';
import '../../../core/responsive/responsive.dart';
import '../../../data/portfolio_data.dart';
import '../theme/design_3_theme.dart';
import '../widgets/d3_primitives.dart';

/// One line of terminal output.
class _Line {
  const _Line(this.spans) : blank = false;
  const _Line.blank() : spans = const [], blank = true;

  final List<(String, Color)> spans;

  /// Blank lines render as vertical space rather than an empty text run.
  final bool blank;
}

/// The inverted band.
///
/// Index is a light design; this is the only place it goes dark, so the switch
/// reads as a deliberate change of register — from printed page to machine.
/// Every value is pulled from [PortfolioData], so the terminal cannot claim
/// anything the rest of the site does not.
class D3Terminal extends StatefulWidget {
  const D3Terminal({super.key, this.anchorKey});

  /// Index has no standalone skills section — `$ stack --list` below is the
  /// skills content, so the navigation's Skills entry anchors to this band.
  final Key? anchorKey;

  @override
  State<D3Terminal> createState() => _D3TerminalState();
}

class _D3TerminalState extends State<D3Terminal> {
  Timer? _timer;
  int _visible = 0;
  bool _started = false;

  static const Color _p = D3.termGreen; // prompt
  static const Color _c = D3.termAmber; // command
  static const Color _v = D3.termInk; // value
  static const Color _f = D3.termFaint; // comment
  static const Color _b = D3.termBlue; // key

  late final List<_Line> _lines = _build();

  List<_Line> _build() {
    final stack = PortfolioData.techChips.take(6).toList();

    return [
      const _Line([(r'$ ', _p), ('whoami', _c)]),
      const _Line([(PortfolioData.name, _v)]),
      const _Line.blank(),
      const _Line([(r'$ ', _p), ('cat role.txt', _c)]),
      const _Line([(PortfolioData.role, _v)]),
      _Line([
        ('${PortfolioData.yearsExperience} years · ', _f),
        (PortfolioData.location, _f),
      ]),
      const _Line.blank(),
      const _Line([(r'$ ', _p), ('stack --list', _c)]),
      for (final tech in stack) _Line([('  ▸ ', _f), (tech, _v)]),
      const _Line.blank(),
      const _Line([(r'$ ', _p), ('ls projects/ | wc -l', _c)]),
      _Line([('${PortfolioData.projects.length}', _v)]),
      const _Line.blank(),
      const _Line([(r'$ ', _p), ('env | grep STATUS', _c)]),
      const _Line([
        ('AVAILABLE_FOR_OPPORTUNITIES', _b),
        ('=', _f),
        ('true', _p),
      ]),
      const _Line([('CONTACT', _b), ('=', _f), (PortfolioData.email, _v)]),
      const _Line.blank(),
      const _Line([(r'$ ', _p), ('', _c)]),
    ];
  }

  void _start() {
    if (_started) return;
    _started = true;

    if (context.reduceMotion) {
      setState(() => _visible = _lines.length);
      return;
    }
    // Lines appear one at a time — cheaper than per-character typing and it
    // reads as a session replaying rather than being typed live.
    _timer = Timer.periodic(const Duration(milliseconds: 90), (timer) {
      if (!mounted || _visible >= _lines.length) {
        timer.cancel();
        return;
      }
      setState(() => _visible++);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final compact = context.screenWidth < 700;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(key: widget.anchorKey, height: 0),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: D3Section.rhythmOf(context) * 0.5,
          ),
          child: D3Container(
            child: OnVisible(
              threshold: 0.8,
              builder: (context, visible) {
                if (visible) {
                  // Kick the replay off the frame after it becomes visible.
                  WidgetsBinding.instance.addPostFrameCallback((_) => _start());
                }

                return Container(
                  width: double.infinity,
                  color: D3.termBg,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _chrome(compact),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          compact ? 18 : 32,
                          compact ? 20 : 28,
                          compact ? 18 : 32,
                          compact ? 24 : 34,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (var i = 0; i < _lines.length; i++)
                              _TerminalLine(
                                line: _lines[i],
                                visible: i < _visible,
                                caret:
                                    i == _visible - 1 &&
                                    _visible == _lines.length,
                                compact: compact,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _chrome(bool compact) {
    return Container(
      height: 42,
      padding: EdgeInsets.symmetric(horizontal: compact ? 16 : 20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0x1AD9D4C8))),
      ),
      child: Row(
        children: [
          Text(
            '— zsh',
            style: D3.monoText.copyWith(color: D3.termFaint, fontSize: 11),
          ),
          const Spacer(),
          if (!compact)
            Text(
              '${PortfolioData.githubHandle}@portfolio',
              style: D3.monoText.copyWith(color: D3.termFaint, fontSize: 11),
            ),
        ],
      ),
    );
  }
}

class _TerminalLine extends StatelessWidget {
  const _TerminalLine({
    required this.line,
    required this.visible,
    required this.caret,
    required this.compact,
  });

  final _Line line;
  final bool visible;
  final bool caret;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (line.blank) return const SizedBox(height: 12);

    return AnimatedOpacity(
      opacity: visible ? 1 : 0,
      duration: const Duration(milliseconds: 160),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 3),
        child: Text.rich(
          TextSpan(
            children: [
              for (final (text, color) in line.spans)
                TextSpan(
                  text: text,
                  style: TextStyle(color: color),
                ),
              if (caret)
                const TextSpan(
                  text: '█',
                  style: TextStyle(color: D3.termGreen),
                ),
            ],
          ),
          style: TextStyle(
            fontFamily: D3.mono,
            fontSize: compact ? 11.5 : 13,
            height: 1.65,
          ),
        ),
      ),
    );
  }
}
