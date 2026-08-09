import 'package:flutter/material.dart';

/// Card grid with equal-height rows and optional multi-column spans.
///
/// `Wrap` is the obvious choice for a responsive grid, but it sizes every
/// child to its own content, so a row of cards ends up ragged — and a child
/// asking for `height: double.infinity` inside it is an outright layout error
/// because a Wrap gives its children unbounded height.
///
/// This packs children into explicit rows instead. Each row is an
/// [IntrinsicHeight] with `CrossAxisAlignment.stretch`, so every card in a row
/// matches the tallest one, and widths are computed exactly rather than
/// approximated with flex.
class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    super.key,
    required this.children,
    required this.columns,
    this.spans,
    this.spacing = 20,
    this.runSpacing = 20,
    this.equalHeight = true,
  }) : assert(
         spans == null || spans.length == children.length,
         'spans must line up with children',
       );

  final List<Widget> children;

  /// Columns at the current breakpoint. Callers resolve this responsively.
  final int columns;

  /// How many columns each child occupies. Defaults to 1 for every child.
  /// Values are clamped to [columns] so a 2-span card still fits a 1-column
  /// phone layout.
  final List<int>? spans;

  final double spacing;
  final double runSpacing;

  /// Set false for rows whose children should keep their natural heights.
  final bool equalHeight;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final unit = (constraints.maxWidth - spacing * (columns - 1)) / columns;

        final rows = _packRows();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var r = 0; r < rows.length; r++)
              Padding(
                padding: EdgeInsets.only(
                  bottom: r == rows.length - 1 ? 0 : runSpacing,
                ),
                child: _buildRow(rows[r], unit),
              ),
          ],
        );
      },
    );
  }

  /// Greedily fills rows up to [columns] units wide.
  List<List<_Cell>> _packRows() {
    final rows = <List<_Cell>>[];
    var current = <_Cell>[];
    var used = 0;

    for (var i = 0; i < children.length; i++) {
      final span = (spans?[i] ?? 1).clamp(1, columns);

      if (used + span > columns && current.isNotEmpty) {
        rows.add(current);
        current = <_Cell>[];
        used = 0;
      }

      current.add(_Cell(child: children[i], span: span));
      used += span;

      if (used >= columns) {
        rows.add(current);
        current = <_Cell>[];
        used = 0;
      }
    }

    if (current.isNotEmpty) rows.add(current);
    return rows;
  }

  Widget _buildRow(List<_Cell> row, double unit) {
    double widthFor(int span) => unit * span + spacing * (span - 1);

    // Children carry explicit widths, so the row takes only the space it
    // needs and a partly-filled final row stays left-aligned rather than
    // spreading its cards across the full width.
    final rowWidget = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: equalHeight
          ? CrossAxisAlignment.stretch
          : CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < row.length; i++) ...[
          if (i > 0) SizedBox(width: spacing),
          SizedBox(width: widthFor(row[i].span), child: row[i].child),
        ],
      ],
    );

    return Align(
      alignment: Alignment.centerLeft,
      child: equalHeight ? IntrinsicHeight(child: rowWidget) : rowWidget,
    );
  }
}

class _Cell {
  const _Cell({required this.child, required this.span});

  final Widget child;
  final int span;
}
