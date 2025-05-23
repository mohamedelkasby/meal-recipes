import 'dart:convert';

class EquipmentModel {
  final String name;
  final String? image;

  EquipmentModel({required this.name, this.image});

  factory EquipmentModel.fromJson(Map<String, dynamic> json) {
    return EquipmentModel(
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString(),
    );
  }

  // Return a proper JSON Map instead of String
  Map<String, dynamic> toJson() {
    return {"name": name, "image": image};
  }

  // Convert to JSON string for SharedPreferences
  String toJsonString() {
    return jsonEncode(toJson());
  }

  /// This method is used to remove the repeated equipment from the list
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EquipmentModel &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          image == other.image;

  @override
  int get hashCode => name.hashCode ^ (image?.hashCode ?? 0);
}
