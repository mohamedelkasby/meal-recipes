import 'package:flutter/material.dart';
import 'package:meals_recipes/models/translatable_text.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final TextStyle? style;

  const ExpandableText({super.key, required this.text, this.style});

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Check if text exceeds 5 lines
        final textPainter = TextPainter(
          text: TextSpan(text: widget.text, style: widget.style),
          maxLines: 5,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout(maxWidth: constraints.maxWidth);
        final needsReadMore = textPainter.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TranslatableText(
              widget.text,
              style: widget.style,
              maxLines: _isExpanded ? null : 5,
              overflow: _isExpanded ? null : TextOverflow.ellipsis,
            ),
            if (needsReadMore)
              GestureDetector(
                onTap: () => setState(() => _isExpanded = !_isExpanded),
                child: TranslatableText(
                  _isExpanded ? 'Read Less' : 'Read More',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
