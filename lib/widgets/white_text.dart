import 'package:flutter/material.dart';

Text whiteText(
  String text, {
  required double size,
  required double weight,
  align = TextAlign.start,
}) {
  return Text(
    text,
    textAlign: align,
    style: TextStyle(
      color: Colors.white,

      fontSize: size,
      fontVariations: [FontVariation('wght', weight)],
    ),
  );
}
