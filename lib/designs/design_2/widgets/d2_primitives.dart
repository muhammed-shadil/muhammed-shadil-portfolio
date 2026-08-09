import 'package:flutter/material.dart';

import '../../../animations/hover_region.dart';
import '../../../animations/reveal.dart';
import '../theme/design_2_theme.dart';

/// Centred content column with Studio's gutters.
class D2Container extends StatelessWidget {
  const D2Container({super.key, required this.child, this.maxWidth});

  final Widget child;
  final double? maxWidth;

  static double gutterOf(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w < 480) return 20;
    if (w < 900) return 36;
    if (w < 1280) return 56;
    return 72;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: gutterOf(context)),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth ?? D2.maxWidth),
          child: child,
        ),
      ),
    );
  }
}

/// Section wrapper: anchor, vertical rhythm and content column.
class D2Section extends StatelessWidget {
  const D2Section({
    super.key,
    required this.child,
    this.anchorKey,
    this.top,
    this.bottom,
    this.maxWidth,
  });

  final Widget child;
  final Key? anchorKey;
  final double? top;
  final double? bottom;
  final double? maxWidth;

  static double rhythmOf(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w < 700) return 96;
    if (w < 1100) return 132;
    return 168;
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
          child: D2Container(maxWidth: maxWidth, child: child),
        ),
      ],
    );
  }
}

/// Numbered monospace label above a section title: `03 — SELECTED WORK`.
///
/// Studio's structural motif, echoing the numbering used on project rows.
class D2Eyebrow extends StatelessWidget {
  const D2Eyebrow(this.text, {super.key, this.number, this.color});

  final String text;
  final String? number;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final tint = color ?? D2.accent;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (number != null) ...[
          Text(number!, style: D2.label.copyWith(color: tint)),
          const SizedBox(width: 12),
          Container(width: 22, height: 1, color: D2.lineStrong),
          const SizedBox(width: 12),
        ] else ...[
          Container(width: 6, height: 6, color: tint),
          const SizedBox(width: 12),
        ],
        Flexible(
          child: Text(
            text.toUpperCase(),
            style: D2.label,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

/// Section heading block used across Studio's sections.
class D2SectionHeader extends StatelessWidget {
  const D2SectionHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    this.number,
    this.lead,
    this.trailing,
  });

  final String eyebrow;
  final String title;
  final String? number;
  final String? lead;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final narrow = MediaQuery.sizeOf(context).width < 900;

    final block = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Reveal(child: D2Eyebrow(eyebrow, number: number)),
        const SizedBox(height: 24),
        Reveal(
          delay: const Duration(milliseconds: 80),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 860),
            child: Text(title, style: D2.sectionTitle(context)),
          ),
        ),
        if (lead != null) ...[
          const SizedBox(height: 22),
          Reveal(
            delay: const Duration(milliseconds: 150),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Text(lead!, style: D2.lead(context)),
            ),
          ),
        ],
      ],
    );

    if (trailing == null) return block;
    if (narrow) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          block,
          const SizedBox(height: 28),
          Reveal(delay: const Duration(milliseconds: 200), child: trailing!),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: block),
        const SizedBox(width: 40),
        Reveal(delay: const Duration(milliseconds: 200), child: trailing!),
      ],
    );
  }
}

/// Solid ivory button — Studio's primary action.
///
/// Inverted rather than gradient-filled: on a warm near-black page a solid
/// ivory block is the loudest possible element without introducing colour.
class D2Button extends StatelessWidget {
  const D2Button({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.filled = true,
    this.expand = false,
    this.compact = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool filled;
  final bool expand;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return HoverRegion(
      onTap: onPressed,
      focusable: true,
      semanticLabel: label,
      builder: (context, state) {
        final active = state.isActive;
        final fg = filled ? D2.bg : (active ? D2.ink : D2.inkMuted);

        return AnimatedContainer(
          duration: D2.fast,
          curve: D2.ease,
          height: compact ? 42 : 54,
          width: expand ? double.infinity : null,
          padding: EdgeInsets.symmetric(horizontal: compact ? 18 : 26),
          decoration: BoxDecoration(
            color: filled
                ? (active ? D2.accent : D2.ink)
                : (active
                      ? D2.ink.withValues(alpha: 0.06)
                      : Colors.transparent),
            borderRadius: D2.pill,
            border: Border.all(
              color: filled
                  ? Colors.transparent
                  : (active ? D2.lineStrong : D2.line),
            ),
          ),
          child: Row(
            mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: fg),
                const SizedBox(width: 9),
              ],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: D2.body,
                    fontSize: compact ? 13.5 : 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.1,
                    color: fg,
                  ),
                ),
              ),
              if (icon == null) ...[
                const SizedBox(width: 10),
                AnimatedSlide(
                  offset: Offset(active ? 0.3 : 0, 0),
                  duration: D2.fast,
                  curve: D2.ease,
                  child: Icon(Icons.arrow_forward_rounded, size: 16, color: fg),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

/// Small outlined tag for technologies.
class D2Tag extends StatelessWidget {
  const D2Tag(this.label, {super.key, this.accent, this.dense = false});

  final String label;
  final Color? accent;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final tint = accent ?? D2.inkMuted;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? 8 : 11,
        vertical: dense ? 4 : 6,
      ),
      decoration: BoxDecoration(
        borderRadius: D2.radiusSm,
        border: Border.all(color: D2.line),
        color: D2.ink.withValues(alpha: 0.02),
      ),
      child: Text(
        label,
        style: D2.mono13.copyWith(fontSize: dense ? 10.5 : 11.5, color: tint),
      ),
    );
  }
}

/// Availability / status pill with an optional breathing dot.
class D2Badge extends StatelessWidget {
  const D2Badge({
    super.key,
    required this.label,
    this.color = D2.positive,
    this.pulse = false,
  });

  final String label;
  final Color color;
  final bool pulse;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: D2.pill,
        border: Border.all(color: D2.line),
        color: D2.ink.withValues(alpha: 0.025),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (pulse)
            _Pulse(color: color)
          else
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            ),
          const SizedBox(width: 10),
          // Flexible: the tracked-out label is wide, and at 320px an
          // unconstrained Text here pushes the pill past the viewport.
          Flexible(
            child: Text(
              label.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: D2.label.copyWith(color: D2.inkMuted, fontSize: 10.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _Pulse extends StatefulWidget {
  const _Pulse({required this.color});
  final Color color;

  @override
  State<_Pulse> createState() => _PulseState();
}

class _PulseState extends State<_Pulse> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2000),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 8,
      height: 8,
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) => Stack(
          alignment: Alignment.center,
          children: [
            Transform.scale(
              scale: 1 + _c.value * 1.8,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color.withValues(alpha: 0.4 * (1 - _c.value)),
                ),
              ),
            ),
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Hairline rule used to separate Studio's bands.
class D2Rule extends StatelessWidget {
  const D2Rule({super.key, this.opacity = 1});
  final double opacity;

  @override
  Widget build(BuildContext context) =>
      Container(height: 1, color: D2.line.withValues(alpha: 0.08 * opacity));
}
