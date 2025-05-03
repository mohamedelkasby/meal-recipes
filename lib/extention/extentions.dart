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
