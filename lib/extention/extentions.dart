extension CapitalizeFirstLetter on String {
  String capitalizeFirstLetter() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

extension CapitalizeByWord on String {
  String capitalizeByWord() {
    if (isEmpty) return this;
    if (length == 1) return toUpperCase();
    return split(' ')
        .map((element) {
          if (element.isEmpty) return element;
          if (element.length == 1) return element.toUpperCase();
          return "${element[0].toUpperCase()}${element.substring(1).toLowerCase()}";
        })
        .join(' ');
  }
}

extension NumFormatter on num {
  String get formatted {
    String str = toStringAsFixed(3);
    List<String> parts = str.split('.');
    if (parts.length > 1) {
      // Remove trailing zeros from the decimal part
      String trimmedDecimal = parts[1].replaceAll(RegExp(r'0+$'), '');
      return trimmedDecimal.isEmpty
          ? parts[0] // No decimal part needed
          : '${parts[0]}.$trimmedDecimal'; // Keep non-zero decimals
    }
    return str;
  }
}
