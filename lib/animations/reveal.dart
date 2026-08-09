import 'package:flutter/widgets.dart';

import '../core/constants/app_constants.dart';
import '../core/responsive/responsive.dart';
import 'scroll_visibility.dart';

/// Fades and slides its child in the first time it enters the viewport.
///
/// Honours the OS reduce-motion setting: when set, the child is rendered
/// immediately with no transform and no opacity animation.
class Reveal extends StatelessWidget {
  const Reveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = AppDurations.reveal,
    this.offset = const Offset(0, 40),
    this.scaleFrom = 1.0,
    this.threshold = 0.9,
  });

  /// Convenience for staggering a list: `Reveal.at(index, child: ...)`.
  Reveal.at(
    int index, {
    super.key,
    required this.child,
    Duration step = const Duration(milliseconds: 80),
    Duration base = Duration.zero,
    this.duration = AppDurations.reveal,
    this.offset = const Offset(0, 40),
    this.scaleFrom = 1.0,
    this.threshold = 0.9,
    int maxStagger = 8,
  }) : delay = base + step * (index.clamp(0, maxStagger));

  final Widget child;
  final Duration delay;
  final Duration duration;

  /// Distance the child travels while fading in.
  final Offset offset;

  /// Optional scale-up. 1.0 disables it.
  final double scaleFrom;

  final double threshold;

  @override
  Widget build(BuildContext context) {
    if (context.reduceMotion) return child;

    return OnVisible(
      threshold: threshold,
      builder: (context, visible) => _RevealTransition(
        visible: visible,
        delay: delay,
        duration: duration,
        offset: offset,
        scaleFrom: scaleFrom,
        child: child,
      ),
    );
  }
}

class _RevealTransition extends StatefulWidget {
  const _RevealTransition({
    required this.visible,
    required this.delay,
    required this.duration,
    required this.offset,
    required this.scaleFrom,
    required this.child,
  });

  final bool visible;
  final Duration delay;
  final Duration duration;
  final Offset offset;
  final double scaleFrom;
  final Widget child;

  @override
  State<_RevealTransition> createState() => _RevealTransitionState();
}

class _RevealTransitionState extends State<_RevealTransition>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );

  late final Animation<double> _eased = CurvedAnimation(
    parent: _controller,
    curve: AppCurves.emphasized,
  );

  @override
  void initState() {
    super.initState();
    if (widget.visible) _play();
  }

  @override
  void didUpdateWidget(_RevealTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible && !oldWidget.visible) _play();
  }

  Future<void> _play() async {
    if (widget.delay > Duration.zero) {
      await Future<void>.delayed(widget.delay);
      if (!mounted) return;
    }
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _eased,
      child: widget.child,
      builder: (context, child) {
        final t = _eased.value;
        final dx = widget.offset.dx * (1 - t);
        final dy = widget.offset.dy * (1 - t);
        final scale = widget.scaleFrom + (1 - widget.scaleFrom) * t;

        Widget result = Opacity(opacity: t.clamp(0.0, 1.0), child: child);
        if (scale != 1.0) {
          result = Transform.scale(scale: scale, child: result);
        }
        return Transform.translate(offset: Offset(dx, dy), child: result);
      },
    );
  }
}
