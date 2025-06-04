import 'dart:convert';

class IngredientModel {
  final String name;
  final String usAmount;
  final String usUnit;
  final String metricAmount;
  final String metricUnit;
  final String originalName;
  final String aisle;
  final String image;

  IngredientModel({
    required this.name,
    required this.metricAmount,
    required this.metricUnit,
    required this.usAmount,
    required this.usUnit,
    required this.originalName,
    required this.aisle,
    required this.image,
  });

  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    // Better null safety and error handling
    String getUsAmount() {
      try {
        if (json['measures'] != null &&
            json['measures']["us"] != null &&
            json['measures']["us"]['amount'] != null) {
          return json['measures']["us"]['amount'].toString();
        }
        return json['amount']?.toString() ?? '0';
      } catch (e) {
        return '0';
      }
    }

    String getMetricAmount() {
      try {
        if (json['measures'] != null &&
            json['measures']["metric"] != null &&
            json['measures']["metric"]['amount'] != null) {
          return json['measures']["metric"]['amount'].toString();
        }
        return json['amount']?.toString() ?? '0';
      } catch (e) {
        print("the error is this ::::: $e ::::");
        return '0';
      }
    }

    String getUsUnit() {
      try {
        if (json['measures'] != null &&
            json['measures']["us"] != null &&
            json['measures']["us"]['unitShort'] != null) {
          return json['measures']["us"]['unitShort'].toString();
        }
        return json['unit']?.toString() ?? '';
      } catch (e) {
        return '';
      }
    }

    String getMetricUnit() {
      try {
        if (json['measures'] != null &&
            json['measures']["metric"] != null &&
            json['measures']["metric"]['unitShort'] != null) {
          return json['measures']["metric"]['unitShort'].toString();
        }
        return json['unit']?.toString() ?? '';
      } catch (e) {
        return '';
      }
    }

    return IngredientModel(
      name: json['name']?.toString() ?? '',
      metricAmount: getMetricAmount(),
      metricUnit: getMetricUnit(),
      usAmount: getUsAmount(),
      usUnit: getUsUnit(),
      originalName:
          json['nameClean']?.toString() ?? json['original']?.toString() ?? '',
      aisle: json['aisle']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
    );
  }

  // Return a proper JSON Map instead of String
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "usAmount": usAmount,
      "usUnit": usUnit,
      "metricAmount": metricAmount,
      "metricUnit": metricUnit,
      "originalName": originalName,
      "aisle": aisle,
      "image": image,
    };
  }

  // Convert to JSON string for SharedPreferences
  String toJsonString() {
    return jsonEncode(toJson());
  }

  // get the data from the SharedPreferences
  factory IngredientModel.fromSavedJson(Map<String, dynamic> json) {
    return IngredientModel(
      name: json["name"],
      metricAmount: json["metricAmount"],
      metricUnit: json["metricUnit"],
      usAmount: json["usAmount"],
      usUnit: json["usUnit"],
      originalName: json["originalName"],
      aisle: json["aisle"],
      image: json["image"],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is IngredientModel &&
        other.name == name &&
        other.metricAmount == metricAmount &&
        other.metricUnit == metricUnit;
  }

  @override
  int get hashCode =>
      name.hashCode ^ metricAmount.hashCode ^ metricUnit.hashCode;
}
