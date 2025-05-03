import 'package:flutter/material.dart';
import 'package:meals_recipes/extention/colors.dart';
import 'package:meals_recipes/extention/extentions.dart';

Widget categoryHeader({
  required String title,
  bool isSeeAll = false,
  bool isIcon = false,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 20),
    child: Row(
      children: [
        Row(
          children: [
            Text(
              title.capitalizeByWord(),
              style: TextStyle(
                fontSize: 25,
                fontVariations: [FontVariation('wght', 700)],
              ),
            ),
            isIcon
                ? Icon(Icons.hourglass_top_rounded, color: mainColor)
                : const SizedBox(),
          ],
        ),
        const Spacer(),
        isSeeAll
            ? Row(
              children: [
                Text(
                  "See all ",
                  style: TextStyle(
                    fontSize: 16,
                    fontVariations: [FontVariation('wght', 600)],
                    color: mainColor,
                  ),
                ),
                Icon(Icons.arrow_forward_rounded, color: mainColor),
              ],
            )
            : const SizedBox(),
      ],
    ),
  );
}
