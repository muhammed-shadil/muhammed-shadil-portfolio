import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
import '../core/responsive/responsive.dart';

/// Standard wrapper for a page section: anchor key, vertical rhythm and the
/// centred max-width content column.
class SectionShell extends StatelessWidget {
  const SectionShell({
    super.key,
    required this.child,
    this.anchorKey,
    this.topPadding,
    this.bottomPadding,
    this.maxWidth,
    this.semanticLabel,
  });

  final Widget child;

  /// Key used by the navigation bar to scroll this section into view.
  final Key? anchorKey;

  final double? topPadding;
  final double? bottomPadding;
  final double? maxWidth;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final gap = context.sectionGap;

    Widget content = Padding(
      padding: EdgeInsets.only(
        top: topPadding ?? gap,
        bottom: bottomPadding ?? gap,
      ),
      // Every section shares the hero's content column so the left edge of
      // the page is a single straight line at any window width.
      child: ContentContainer(
        maxWidth: maxWidth ?? AppSizes.maxContentWidth,
        child: child,
      ),
    );

    if (semanticLabel != null) {
      content = Semantics(
        container: true,
        header: false,
        label: semanticLabel,
        child: content,
      );
    }

    // The anchor sits on a zero-height box at the very top of the section so
    // `scrollTo` lands on the section's true start, not on its padded content.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(key: anchorKey, height: 0),
        content,
      ],
    );
  }
}
