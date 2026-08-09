import 'package:flutter/material.dart';

import '../../../animations/hover_region.dart';
import '../../../animations/reveal.dart';
import '../theme/design_3_theme.dart';

/// Index's content column. Wider and less padded than the other designs —
/// editorial layouts want the type to reach closer to the trim edge.
class D3Container extends StatelessWidget {
  const D3Container({super.key, required this.child, this.maxWidth});

  final Widget child;
  final double? maxWidth;

  static double gutterOf(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w < 480) return 18;
    if (w < 900) return 28;
    if (w < 1280) return 44;
    return 56;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: gutterOf(context)),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth ?? D3.maxWidth),
          child: child,
        ),
      ),
    );
  }
}

class D3Section extends StatelessWidget {
  const D3Section({
    super.key,
    required this.child,
    this.anchorKey,
    this.top,
    this.bottom,
  });

  final Widget child;
  final Key? anchorKey;
  final double? top;
  final double? bottom;

  static double rhythmOf(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w < 700) return 84;
    if (w < 1100) return 112;
    return 140;
  }

  @override
  Widget build(BuildContext context) {
    final gap = rhythmOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(key: anchorKey, height: 0),
        Padding(
          padding: EdgeInsets.only(top: top ?? gap, bottom: bottom ?? gap),
          child: D3Container(child: child),
        ),
      ],
    );
  }
}

/// A full-bleed hairline — Index separates everything with rules, never with
/// borders or cards.
class D3Rule extends StatelessWidget {
  const D3Rule({super.key, this.strong = false});
  final bool strong;

  @override
  Widget build(BuildContext context) =>
      Container(height: 1, color: strong ? D3.ruleStrong : D3.rule);
}

/// Section marker: `§ 02 — SELECTED WORK` above a rule.
class D3SectionMark extends StatelessWidget {
  const D3SectionMark({super.key, required this.number, required this.label});

  final String number;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Reveal(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const D3Rule(strong: true),
          Padding(
            padding: const EdgeInsets.only(top: 14, bottom: 4),
            child: Row(
              children: [
                Text(number, style: D3.label.copyWith(color: D3.accent)),
                const SizedBox(width: 18),
                Expanded(
                  child: Text(
                    label.toUpperCase(),
                    style: D3.label,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Text link with a rule that draws in from the left on hover.
class D3Link extends StatelessWidget {
  const D3Link({
    super.key,
    required this.label,
    required this.onTap,
    this.style,
    this.external = false,
  });

  final String label;
  final VoidCallback? onTap;
  final TextStyle? style;
  final bool external;

  @override
  Widget build(BuildContext context) {
    return HoverRegion(
      onTap: onTap,
      focusable: true,
      semanticLabel: label,
      builder: (context, state) {
        final active = state.isActive;
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedDefaultTextStyle(
                  duration: D3.fast,
                  style: (style ?? D3.bodyText).copyWith(
                    color: active ? D3.accent : D3.ink,
                    fontWeight: FontWeight.w500,
                  ),
                  child: Text(label),
                ),
                if (external) ...[
                  const SizedBox(width: 6),
                  AnimatedSlide(
                    offset: Offset(active ? 0.25 : 0, active ? -0.25 : 0),
                    duration: D3.fast,
                    child: Icon(
                      Icons.arrow_outward_rounded,
                      size: 13,
                      color: active ? D3.accent : D3.inkFaint,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 3),
            AnimatedContainer(
              duration: D3.fast,
              curve: D3.ease,
              height: 1,
              width: active ? 100 : 0,
              color: D3.accent,
            ),
          ],
        );
      },
    );
  }
}

/// Index's button: a hard-edged rectangle, no radius anywhere in this design.
class D3Button extends StatelessWidget {
  const D3Button({
    super.key,
    required this.label,
    required this.onPressed,
    this.filled = true,
    this.icon,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool filled;
  final IconData? icon;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    return HoverRegion(
      onTap: onPressed,
      focusable: true,
      semanticLabel: label,
      builder: (context, state) {
        final active = state.isActive;
        final bg = filled
            ? (active ? D3.accent : D3.ink)
            : (active ? D3.ink : Colors.transparent);
        final fg = filled || active ? D3.paper : D3.ink;

        return AnimatedContainer(
          duration: D3.fast,
          curve: D3.ease,
          height: 52,
          width: expand ? double.infinity : null,
          padding: const EdgeInsets.symmetric(horizontal: 26),
          decoration: BoxDecoration(
            color: bg,
            border: Border.all(color: D3.ink, width: 1),
          ),
          child: Row(
            mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: fg),
                const SizedBox(width: 10),
              ],
              Flexible(
                child: Text(
                  label.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: D3.mono,
                    fontSize: 12,
                    letterSpacing: 1.6,
                    fontWeight: FontWeight.w500,
                    color: fg,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Metadata pair rendered as a labelled monospace row.
class D3Meta extends StatelessWidget {
  const D3Meta({
    super.key,
    required this.label,
    required this.value,
    this.width = 96,
  });

  final String label;
  final String value;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: width,
            child: Text(label.toUpperCase(), style: D3.label),
          ),
          Expanded(
            child: Text(value, style: D3.monoText.copyWith(color: D3.ink)),
          ),
        ],
      ),
    );
  }
}
