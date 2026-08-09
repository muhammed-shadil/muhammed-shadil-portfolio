import 'package:flutter/widgets.dart';

import '../core/constants/app_constants.dart';
import '../core/responsive/responsive.dart';
import '../widgets/custom_cursor.dart';

/// Rebuilds its child with hover, press and focus state, and exposes the
/// pointer position for effects that follow the cursor.
///
/// On touch devices hover never fires, so every visual that depends on it must
/// also look correct in the resting state — that is the contract callers rely
/// on throughout this project.
class HoverRegion extends StatefulWidget {
  const HoverRegion({
    super.key,
    required this.builder,
    this.onTap,
    this.cursor,
    this.focusable = false,
    this.semanticLabel,
    this.tooltip,
    this.cursorMode = CursorMode.interactive,
    this.cursorLabel,
  });

  final Widget Function(BuildContext context, HoverState state) builder;
  final VoidCallback? onTap;

  /// Overrides the system cursor. Normally left null: when the custom cursor
  /// layer is running the native pointer is hidden, and the expanding ring is
  /// what signals interactivity.
  final MouseCursor? cursor;

  /// How the custom cursor should react while this region is hovered.
  final CursorMode cursorMode;

  /// Optional word drawn inside the cursor disc (used by project cards).
  final String? cursorLabel;

  /// When true the region joins the focus traversal order and can be
  /// activated with Enter/Space — required for anything that acts as a
  /// button but is not one.
  final bool focusable;

  final String? semanticLabel;
  final String? tooltip;

  @override
  State<HoverRegion> createState() => _HoverRegionState();
}

/// Interaction state handed to a [HoverRegion] builder.
class HoverState {
  const HoverState({
    required this.isHovered,
    required this.isPressed,
    required this.isFocused,
    required this.localPosition,
    required this.size,
  });

  final bool isHovered;
  final bool isPressed;
  final bool isFocused;

  /// Cursor position within the region, or null when not hovering.
  final Offset? localPosition;
  final Size size;

  /// True when the element should read as "active" — hovered, pressed or
  /// keyboard-focused.
  bool get isActive => isHovered || isPressed || isFocused;

  /// Cursor position normalised to -1..1 on both axes, for parallax/tilt.
  Offset get normalized {
    if (localPosition == null || size.isEmpty) return Offset.zero;
    return Offset(
      (localPosition!.dx / size.width) * 2 - 1,
      (localPosition!.dy / size.height) * 2 - 1,
    );
  }
}

class _HoverRegionState extends State<HoverRegion> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;
  Offset? _local;
  Size _size = Size.zero;

  void _setHover(bool value) {
    if (_hovered == value) return;

    // Drive the custom cursor from whichever region the pointer is inside.
    if (widget.onTap != null) {
      if (value) {
        AppCursor.enter(widget.cursorMode, withLabel: widget.cursorLabel);
      } else {
        AppCursor.exit();
      }
    }

    setState(() {
      _hovered = value;
      if (!value) _local = null;
    });
  }

  @override
  void dispose() {
    // A region can be unmounted while hovered (e.g. opening the project
    // detail route); leave the cursor in a clean state if so.
    if (_hovered && widget.onTap != null) AppCursor.exit();
    super.dispose();
  }

  void _updatePosition(Offset position) {
    // Size is read from the render object rather than a LayoutBuilder: a
    // LayoutBuilder cannot be measured for intrinsic dimensions, and these
    // regions sit inside IntrinsicHeight rows all over the site.
    final box = context.findRenderObject() as RenderBox?;

    setState(() {
      _local = position;
      if (box != null && box.hasSize) _size = box.size;
    });
  }

  @override
  Widget build(BuildContext context) {
    final enableHover = context.hasPointer;

    Widget child = widget.builder(
      context,
      HoverState(
        isHovered: _hovered,
        isPressed: _pressed,
        isFocused: _focused,
        localPosition: _local,
        size: _size,
      ),
    );

    if (widget.onTap != null) {
      child = GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        behavior: HitTestBehavior.opaque,
        child: child,
      );
    }

    if (enableHover) {
      child = MouseRegion(
        cursor:
            widget.cursor ??
            (AppCursor.enabled || widget.onTap == null
                ? MouseCursor.defer
                : SystemMouseCursors.click),
        onEnter: (_) => _setHover(true),
        onExit: (_) => _setHover(false),
        onHover: (event) => _updatePosition(event.localPosition),
        child: child,
      );
    }

    if (widget.focusable && widget.onTap != null) {
      child = FocusableActionDetector(
        onShowFocusHighlight: (value) => setState(() => _focused = value),
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              widget.onTap!.call();
              return null;
            },
          ),
        },
        child: child,
      );
    }

    if (widget.semanticLabel != null) {
      child = Semantics(
        label: widget.semanticLabel,
        button: widget.onTap != null,
        child: child,
      );
    }

    return child;
  }
}

/// Lifts and glows its child on hover. The common case, wrapped up so cards
/// don't each re-implement it.
class HoverLift extends StatelessWidget {
  const HoverLift({
    super.key,
    required this.builder,
    this.onTap,
    this.lift = 6,
    this.scale = 1.0,
    this.focusable = true,
    this.semanticLabel,
  });

  final Widget Function(BuildContext context, HoverState state) builder;
  final VoidCallback? onTap;
  final double lift;
  final double scale;
  final bool focusable;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = context.reduceMotion;

    return HoverRegion(
      onTap: onTap,
      focusable: focusable,
      semanticLabel: semanticLabel,
      builder: (context, state) {
        final active = state.isActive && !reduceMotion;
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: active ? 1 : 0),
          duration: AppDurations.fast,
          curve: AppCurves.standard,
          builder: (context, t, child) => Transform.translate(
            offset: Offset(0, -lift * t),
            child: Transform.scale(scale: 1 + (scale - 1) * t, child: child),
          ),
          child: builder(context, state),
        );
      },
    );
  }
}
