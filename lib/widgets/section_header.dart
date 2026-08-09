import 'package:flutter/material.dart';

import '../animations/reveal.dart';
import '../core/constants/app_constants.dart';
import '../core/responsive/responsive.dart';
import '../core/theme/app_typography.dart';
import 'gradient_text.dart';
import 'tech_chip.dart';

/// Eyebrow + heading + optional lead paragraph, revealed as a group.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    this.highlight,
    this.lead,
    this.centered = false,
    this.trailing,
  });

  final String eyebrow;
  final String title;

  /// Word inside [title] painted with the accent gradient.
  final String? highlight;

  final String? lead;
  final bool centered;

  /// Optional widget pinned to the right on wide screens (e.g. a "view all"
  /// link). Drops below the heading on handsets.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final alignment = centered
        ? CrossAxisAlignment.center
        : CrossAxisAlignment.start;
    final textAlign = centered ? TextAlign.center : TextAlign.start;

    final heading = Column(
      crossAxisAlignment: alignment,
      children: [
        Reveal(child: Eyebrow(eyebrow)),
        const SizedBox(height: 18),
        Reveal(
          delay: const Duration(milliseconds: 90),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 780),
            child: highlight == null
                ? Text(
                    title,
                    style: AppText.headline(context),
                    textAlign: textAlign,
                  )
                : HighlightedHeadline(
                    text: title,
                    highlight: highlight!,
                    style: AppText.headline(context),
                    textAlign: textAlign,
                  ),
          ),
        ),
        if (lead != null) ...[
          const SizedBox(height: 20),
          Reveal(
            delay: const Duration(milliseconds: 160),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSizes.maxProseWidth,
              ),
              child: Text(
                lead!,
                style: AppText.lead(context),
                textAlign: textAlign,
              ),
            ),
          ),
        ],
      ],
    );

    if (trailing == null) return heading;

    if (context.isHandset) {
      return Column(
        crossAxisAlignment: alignment,
        children: [
          heading,
          const SizedBox(height: 24),
          Reveal(delay: const Duration(milliseconds: 220), child: trailing!),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: heading),
        const SizedBox(width: 32),
        Reveal(delay: const Duration(milliseconds: 220), child: trailing!),
      ],
    );
  }
}
