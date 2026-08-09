import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

/// Paints text with a gradient by masking a shader over it.
class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    super.key,
    required this.style,
    this.gradient = AppColors.accentGradient,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  final String text;
  final TextStyle style;
  final Gradient gradient;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      blendMode: BlendMode.srcIn,
      child: Text(
        text,
        style: style.copyWith(color: Colors.white),
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      ),
    );
  }
}

/// Renders a sentence where one word (or phrase) is painted with the accent
/// gradient and the rest stays in the normal text colour.
///
/// Used for the hero headline so the emphasis word is data, not markup.
class HighlightedHeadline extends StatelessWidget {
  const HighlightedHeadline({
    super.key,
    required this.text,
    required this.highlight,
    required this.style,
    this.gradient = AppColors.accentGradient,
    this.textAlign = TextAlign.start,
  });

  final String text;
  final String highlight;
  final TextStyle style;
  final Gradient gradient;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    final index = text.toLowerCase().indexOf(highlight.toLowerCase());

    if (highlight.isEmpty || index < 0) {
      return Text(text, style: style, textAlign: textAlign);
    }

    final before = text.substring(0, index);
    final match = text.substring(index, index + highlight.length);
    final after = text.substring(index + highlight.length);

    return Text.rich(
      TextSpan(
        children: [
          if (before.isNotEmpty) TextSpan(text: before),
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: GradientText(match, style: style, gradient: gradient),
          ),
          if (after.isNotEmpty) TextSpan(text: after),
        ],
      ),
      style: style,
      textAlign: textAlign,
    );
  }
}
