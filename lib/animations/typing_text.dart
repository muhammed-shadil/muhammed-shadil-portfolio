import 'dart:async';

import 'package:flutter/widgets.dart';

import '../core/responsive/responsive.dart';
import '../core/theme/app_colors.dart';

/// Types a word out character by character, holds, deletes it, and moves to
/// the next — the rotating job-title effect in the hero.
///
/// Under reduce-motion it renders the first word statically.
class TypingText extends StatefulWidget {
  const TypingText({
    super.key,
    required this.words,
    required this.style,
    this.typeSpeed = const Duration(milliseconds: 85),
    this.deleteSpeed = const Duration(milliseconds: 40),
    this.holdDuration = const Duration(milliseconds: 1800),
    this.cursorColor,
  });

  final List<String> words;
  final TextStyle style;
  final Duration typeSpeed;
  final Duration deleteSpeed;
  final Duration holdDuration;
  final Color? cursorColor;

  @override
  State<TypingText> createState() => _TypingTextState();
}

class _TypingTextState extends State<TypingText>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  int _wordIndex = 0;
  int _charCount = 0;
  bool _deleting = false;
  bool _started = false;

  late final AnimationController _caret = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat(reverse: true);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (!context.reduceMotion) {
      _charCount = 0;
      _schedule(const Duration(milliseconds: 600));
    } else {
      _charCount = widget.words.first.length;
      _caret.stop();
    }
  }

  void _schedule(Duration delay) {
    _timer?.cancel();
    _timer = Timer(delay, _tick);
  }

  void _tick() {
    if (!mounted) return;
    final word = widget.words[_wordIndex];

    if (_deleting) {
      if (_charCount == 0) {
        _deleting = false;
        _wordIndex = (_wordIndex + 1) % widget.words.length;
        _schedule(const Duration(milliseconds: 260));
        return;
      }
      setState(() => _charCount--);
      _schedule(widget.deleteSpeed);
      return;
    }

    if (_charCount >= word.length) {
      _deleting = true;
      _schedule(widget.holdDuration);
      return;
    }

    setState(() => _charCount++);
    _schedule(widget.typeSpeed);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _caret.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final word = widget.words[_wordIndex];
    final visible = word.substring(0, _charCount.clamp(0, word.length));

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Reserve the width of the longest word so surrounding layout never
        // reflows while typing.
        Flexible(child: Text(visible, style: widget.style, softWrap: false)),
        const SizedBox(width: 3),
        FadeTransition(
          opacity: _caret,
          child: Container(
            width: 2.5,
            height: (widget.style.fontSize ?? 18) * 1.05,
            decoration: BoxDecoration(
              color: widget.cursorColor ?? AppColors.accentAlt,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ],
    );
  }
}
