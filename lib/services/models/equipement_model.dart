class EquipmentModel {
  final String name;
  final String imageUrl;

  EquipmentModel({required this.name, required this.imageUrl});

  factory EquipmentModel.fromJson(Map<String, dynamic> json) {
    return EquipmentModel(name: json['name'], imageUrl: json['image']);
  }
}
