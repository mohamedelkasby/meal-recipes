import 'package:flutter/material.dart';

Widget handleImageError({
  required String urlImage,
  required Widget errorImage,
}) {
  return Image.network(
    urlImage,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[300],
        ),
        child: errorImage,
      );
    },
    loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null) {
        return child;
      }
      return SizedBox(
        child: Center(
          child: CircularProgressIndicator(
            value:
                loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
          ),
        ),
      );
    },
  );
}
