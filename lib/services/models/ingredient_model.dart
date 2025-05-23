import 'dart:convert';

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
    this.image,
  });

  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    // Better null safety and error handling
    String getAmount() {
      try {
        if (json['measures'] != null &&
            json['measures']['metric'] != null &&
            json['measures']['metric']['amount'] != null) {
          return json['measures']['metric']['amount'].toString();
        }
        return json['amount']?.toString() ?? '0';
      } catch (e) {
        return '0';
      }
    }

    String getUnit() {
      try {
        if (json['measures'] != null &&
            json['measures']['metric'] != null &&
            json['measures']['metric']['unitShort'] != null) {
          return json['measures']['metric']['unitShort'].toString();
        }
        return json['unit']?.toString() ?? '';
      } catch (e) {
        return '';
      }
    }

    return IngredientModel(
      name: json['name']?.toString() ?? '',
      amount: getAmount(),
      unit: getUnit(),
      originalName:
          json['nameClean']?.toString() ?? json['original']?.toString() ?? '',
      aisle: json['aisle']?.toString() ?? '',
      image: json['image']?.toString(),
    );
  }

  // Return a proper JSON Map instead of String
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "amount": amount,
      "unit": unit,
      "originalName": originalName,
      "aisle": aisle,
      "image": image,
    };
  }

  // Convert to JSON string for SharedPreferences
  String toJsonString() {
    return jsonEncode(toJson());
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is IngredientModel &&
        other.name == name &&
        other.amount == amount &&
        other.unit == unit;
  }

  @override
  int get hashCode => name.hashCode ^ amount.hashCode ^ unit.hashCode;
}
