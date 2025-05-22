class EquipmentModel {
  final String name;
  final String? image;

  EquipmentModel({required this.name, required this.image});

  factory EquipmentModel.fromJson(Map<String, dynamic> json) {
    return EquipmentModel(name: json['name'], image: json['image'] ?? '');
  }
}
