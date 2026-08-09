import 'package:flutter/widgets.dart';

/// Broadcasts the page scroll offset to descendants.
///
/// One [NotificationListener] at the root of the page feeds a single
/// [ValueNotifier]; every reveal/counter widget listens to that notifier and
/// unsubscribes as soon as it has fired. This keeps scroll-linked work
/// proportional to the number of *not yet revealed* widgets rather than to
/// every animated widget on the page.
class ScrollProvider extends InheritedWidget {
  const ScrollProvider({super.key, required this.offset, required super.child});

  final ValueNotifier<double> offset;

  static ValueNotifier<double>? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ScrollProvider>()?.offset;

  @override
  bool updateShouldNotify(ScrollProvider oldWidget) =>
      oldWidget.offset != offset;
}

/// Calls [builder] with `false`, then with `true` the first time this widget
/// scrolls into the viewport.
///
/// [threshold] is the fraction of the viewport height that must be crossed
/// before the widget counts as visible — 0.85 means "trigger once the top of
/// the widget is 85% of the way up the screen", which fires slightly before
/// the element is fully on screen so the animation reads as anticipatory.
class OnVisible extends StatefulWidget {
  const OnVisible({
    super.key,
    required this.builder,
    this.threshold = 0.88,
    this.once = true,
  });

  final Widget Function(BuildContext context, bool visible) builder;
  final double threshold;
  final bool once;

  @override
  State<OnVisible> createState() => _OnVisibleState();
}

class _OnVisibleState extends State<OnVisible> {
  ValueNotifier<double>? _offset;
  bool _visible = false;
  bool _scheduled = false;

  @override
  void initState() {
    super.initState();
    // Content already on screen at first paint must reveal without waiting
    // for a scroll event.
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final next = ScrollProvider.maybeOf(context);
    if (next != _offset) {
      _offset?.removeListener(_check);
      _offset = next;
      if (!_visible) _offset?.addListener(_check);
    }
  }

  @override
  void dispose() {
    _offset?.removeListener(_check);
    super.dispose();
  }

  /// Coalesces multiple scroll ticks within one frame into a single check.
  void _check() {
    if (_scheduled) return;
    _scheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scheduled = false;
      _evaluate();
    });
  }

  void _evaluate() {
    if (!mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize || !box.attached) return;

    final viewportHeight = MediaQuery.sizeOf(context).height;
    final top = box.localToGlobal(Offset.zero).dy;
    final bottom = top + box.size.height;

    // Visible when the element's top edge has risen past the threshold line
    // and its bottom edge has not yet left the top of the screen.
    final isVisible = top < viewportHeight * widget.threshold && bottom > 0;

    if (isVisible == _visible) return;
    if (!isVisible && widget.once) return;

    setState(() => _visible = isVisible);

    if (isVisible && widget.once) {
      _offset?.removeListener(_check);
    }
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _visible);
}
