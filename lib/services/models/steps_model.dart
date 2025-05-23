import 'dart:convert';

class StepsModel {
  final int numStep;
  final String description;

  StepsModel({required this.description, required this.numStep});

  factory StepsModel.fromJson(Map<String, dynamic> json) {
    return StepsModel(
      numStep: json["number"] ?? 0,
      description: json["step"] ?? '',
    );
  }

  // Return a proper JSON Map instead of String
  Map<String, dynamic> toJson() {
    return {"number": numStep, "step": description};
  }

  // Convert to JSON string for SharedPreferences
  String toJsonString() {
    return jsonEncode(toJson());
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StepsModel &&
        other.numStep == numStep &&
        other.description == description;
  }

  @override
  int get hashCode => numStep.hashCode ^ description.hashCode;
}
