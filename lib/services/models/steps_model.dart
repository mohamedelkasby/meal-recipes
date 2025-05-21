class StepsModel {
  final int numStep;
  final String description;

  StepsModel({required this.description, required this.numStep});

  factory StepsModel.fromJson(Map<String, dynamic> json) {
    return StepsModel(numStep: json["number"], description: json["step"]);
  }
}
