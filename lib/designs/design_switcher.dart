import 'package:flutter/material.dart';

import '../core/config/portfolio_config.dart';
import 'design_registry.dart';

/// Floating development-only control for flipping between designs live.
///
/// Gated on [PortfolioConfig.showDesignSwitcher], which is `kDebugMode` — a
/// compile-time constant. In a release build the `if` is provably false, so
/// Dart's tree shaker removes this entire widget and everything it references
/// from the bundle. Visitors cannot reach it and it costs nothing.
class DesignSwitcherOverlay extends StatelessWidget {
  const DesignSwitcherOverlay({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!PortfolioConfig.showDesignSwitcher) return child;

    return Stack(
      children: [
        child,
        const Positioned(left: 20, bottom: 20, child: _SwitcherPanel()),
      ],
    );
  }
}

class _SwitcherPanel extends StatefulWidget {
  const _SwitcherPanel();

  @override
  State<_SwitcherPanel> createState() => _SwitcherPanelState();
}

class _SwitcherPanelState extends State<_SwitcherPanel> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    // Deliberately not themed from the active design — the control must stay
    // legible whichever palette is on screen, and must never be mistaken for
    // part of the portfolio.
    return Material(
      color: Colors.transparent,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        alignment: Alignment.bottomLeft,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xE6101014),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0x1FFFFFFF)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x66000000),
                blurRadius: 24,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: _open ? _expanded() : _collapsed(),
        ),
      ),
    );
  }

  Widget _collapsed() {
    return _IconButton(
      tooltip: 'Switch design (debug only)',
      onTap: () => setState(() => _open = true),
      child: const Icon(Icons.palette_outlined, size: 18, color: Colors.white),
    );
  }

  Widget _expanded() {
    return ValueListenableBuilder<PortfolioDesign>(
      valueListenable: DesignController.current,
      builder: (context, active, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 2, 6, 8),
              child: Row(
                children: [
                  const Text(
                    'DESIGN',
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 10,
                      letterSpacing: 2,
                      color: Color(0xFF8A8A99),
                    ),
                  ),
                  const SizedBox(width: 28),
                  _IconButton(
                    tooltip: 'Collapse',
                    size: 22,
                    onTap: () => setState(() => _open = false),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 13,
                      color: Color(0xFF8A8A99),
                    ),
                  ),
                ],
              ),
            ),
            for (final design in designOrder)
              _DesignRow(
                meta: designMetaOf(design),
                selected: design == active,
                onTap: () => DesignController.select(design),
              ),
            const Padding(
              padding: EdgeInsets.fromLTRB(6, 8, 6, 2),
              child: Text(
                'debug build only',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 9,
                  color: Color(0xFF55555F),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _DesignRow extends StatefulWidget {
  const _DesignRow({
    required this.meta,
    required this.selected,
    required this.onTap,
  });

  final DesignMeta meta;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_DesignRow> createState() => _DesignRowState();
}

class _DesignRowState extends State<_DesignRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.selected || _hovered;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 208,
          margin: const EdgeInsets.only(bottom: 4),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          decoration: BoxDecoration(
            color: widget.selected
                ? const Color(0x1AFFFFFF)
                : active
                ? const Color(0x0DFFFFFF)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
            border: Border.all(
              color: widget.selected
                  ? widget.meta.swatch.withValues(alpha: 0.55)
                  : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.meta.swatch,
                  boxShadow: widget.selected
                      ? [
                          BoxShadow(
                            color: widget.meta.swatch.withValues(alpha: 0.7),
                            blurRadius: 8,
                          ),
                        ]
                      : null,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.meta.label,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: active ? Colors.white : const Color(0xFFB9B9C6),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.meta.tagline,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        color: Color(0xFF74747F),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (widget.selected)
                const Icon(Icons.check_rounded, size: 14, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({
    required this.child,
    required this.onTap,
    required this.tooltip,
    this.size = 34,
  });

  final Widget child;
  final VoidCallback onTap;
  final String tooltip;
  final double size;

  @override
  Widget build(BuildContext context) {
    // Semantics rather than a Tooltip: this overlay is installed by
    // MaterialApp.builder, which sits *above* the Navigator, so there is no
    // Overlay ancestor for a tooltip to float in and building one throws.
    return Semantics(
      label: tooltip,
      button: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: SizedBox.square(
            dimension: size,
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}
