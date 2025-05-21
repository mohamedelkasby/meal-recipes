class IngredientModel {
  final String name;
  final String amount;
  final String unit;
  final String originalName;
  final String aisle;
  final String? image;

  IngredientModel({
    required this.name,
    required this.amount,
    required this.unit,
    required this.originalName,
    required this.aisle,
    required this.image,
  });

  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    return IngredientModel(
      name: json['name'].toString(),
      amount: json['measures']["metric"]['amount'].toString(),
      unit: json['measures']["metric"]["unitShort"].toString(),
      originalName: json['nameClean'].toString(),
      aisle: json['aisle'].toString(),
      image: json['image'].toString(),
    );
  }
}
