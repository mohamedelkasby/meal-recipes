import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meals_recipes/models/translatable_text.dart';

Row textWithIcon({
  required Icon icon,
  required String text,
  String svgImg = "",
}) {
  List<String> textOnly = text.split(" ");

  return Row(
    children: [
      svgImg == ""
          ? icon
          : SvgPicture.asset(
            svgImg,
            colorFilter: ColorFilter.mode(Colors.grey, BlendMode.srcIn),
          ),

      const SizedBox(width: 5),
      Text(
        "${textOnly.first} ",
        style: const TextStyle(fontSize: 17, color: Colors.grey),
      ),
      TranslatableText(
        textOnly.last,
        style: const TextStyle(fontSize: 17, color: Colors.grey),
      ),
    ],
  );
}
