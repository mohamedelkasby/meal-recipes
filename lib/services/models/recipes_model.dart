import 'package:meals_recipes/services/models/equipement_model.dart';
import 'package:meals_recipes/services/models/ingredient_model.dart';
import 'package:meals_recipes/services/models/steps_model.dart';
import 'dart:convert';

class RecipesModel {
  final int id;
  final String title;
  final String imageUrl;
  final String description;
  final int servings;
  final List<IngredientModel> ingredients;
  final String readyInMinutes;
  final String cookingTime;
  final List<StepsModel> steps;
  final List<EquipmentModel> equipment;
  final List<String> diets;
  final List<String> dishType;
  final bool favorite;
  final bool healthy;
  final bool isSaved;

  RecipesModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.cookingTime,
    required this.readyInMinutes,
    required this.ingredients,
    required this.steps,
    required this.servings,
    required this.diets,
    required this.dishType,
    required this.equipment,
    required this.favorite,
    required this.healthy,
    this.isSaved = false,
  });

  // Factory constructor for API data
  factory RecipesModel.fromJson(Map<String, dynamic> json) {
    List<EquipmentModel> allEquipment = [];
    if (json['analyzedInstructions'] != null &&
        json['analyzedInstructions'].isNotEmpty) {
      for (var step in json['analyzedInstructions'][0]['steps']) {
        if (step['equipment'] != null && step['equipment'].isNotEmpty) {
          for (var equipment in step['equipment']) {
            if (equipment != null) {
              allEquipment.add(EquipmentModel.fromJson(equipment));
            }
          }
        }
      }
    }

    return RecipesModel(
      id: json['id'],
      title: json['title'] ?? '',
      imageUrl: json['image'] ?? '',
      description: json['summary'] ?? '',
      readyInMinutes: (json['readyInMinutes'] ?? 0).toString(),
      cookingTime: (json['cookingMinutes'] ?? 0).toString(),
      dishType:
          json['dishTypes'] != null ? List<String>.from(json['dishTypes']) : [],
      servings: json['servings'] ?? 1,
      ingredients:
          json['extendedIngredients'] != null
              ? List<IngredientModel>.from(
                json['extendedIngredients'].map(
                  (x) => IngredientModel.fromJson(x),
                ),
              )
              : [],
      diets: json['diets'] != null ? List<String>.from(json['diets']) : [],
      steps:
          json['analyzedInstructions'] != null &&
                  json['analyzedInstructions'].isNotEmpty
              ? List<StepsModel>.from(
                json['analyzedInstructions'][0]['steps'].map(
                  (x) => StepsModel.fromJson(x),
                ),
              )
              : [],
      equipment: allEquipment,
      healthy: json['veryHealthy'] ?? false,
      favorite: json['veryPopular'] ?? false,
      isSaved: json['isSaved'] ?? false,
    );
  }

  // Factory constructor for saved data (from SharedPreferences)
  factory RecipesModel.fromJsonString(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);

    return RecipesModel.fromSavedJson(json);
  }

  factory RecipesModel.fromSavedJson(Map<String, dynamic> json) {
    return RecipesModel(
      id: json['id'],
      title: json['title'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      description: json['description'] ?? '',
      readyInMinutes: json['readyInMinutes'] ?? '0',
      cookingTime: json['cookingTime'] ?? '0',
      servings: json['servings'] ?? 1,
      ingredients:
          json['ingredients'] != null
              ? (json['ingredients'] as List)
                  .map((e) => IngredientModel.fromJson(e))
                  .toList()
              : [],
      steps:
          json['steps'] != null
              ? (json['steps'] as List)
                  .map((e) => StepsModel.fromJson(e))
                  .toList()
              : [],
      equipment:
          json['equipment'] != null
              ? (json['equipment'] as List)
                  .map((e) => EquipmentModel.fromJson(e))
                  .toList()
              : [],
      diets: json['diets'] != null ? List<String>.from(json['diets']) : [],
      dishType:
          json['dishType'] != null ? List<String>.from(json['dishType']) : [],
      favorite: json['favorite'] ?? false,
      healthy: json['healthy'] ?? false,
      isSaved: json['isSaved'] ?? false,
    );
  }

  // Convert to JSON string for SharedPreferences
  String toJsonString() {
    final Map<String, dynamic> data = {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'description': description,
      'servings': servings,
      'ingredients': ingredients.map((e) => e.toJson()).toList(),
      'readyInMinutes': readyInMinutes,
      'cookingTime': cookingTime,
      'steps': steps.map((e) => e.toJson()).toList(),
      'equipment': equipment.map((e) => e.toJson()).toList(),
      'diets': diets,
      'dishType': dishType,
      'favorite': favorite,
      'healthy': healthy,
      'isSaved': isSaved,
    };
    return jsonEncode(data);
  }

  // Convert to JSON Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'description': description,
      'servings': servings,
      'ingredients': ingredients.map((e) => e.toJson()).toList(),
      'readyInMinutes': readyInMinutes,
      'cookingTime': cookingTime,
      'steps': steps.map((e) => e.toJson()).toList(),
      'equipment': equipment.map((e) => e.toJson()).toList(),
      'diets': diets,
      'dishType': dishType,
      'favorite': favorite,
      'healthy': healthy,
      'isSaved': isSaved,
    };
  }

  // CopyWith method for creating modified copies
  RecipesModel copyWith({
    int? id,
    String? title,
    String? imageUrl,
    String? description,
    int? servings,
    List<IngredientModel>? ingredients,
    String? readyInMinutes,
    String? cookingTime,
    List<StepsModel>? steps,
    List<EquipmentModel>? equipment,
    List<String>? diets,
    List<String>? dishType,
    bool? favorite,
    bool? healthy,
    bool? isSaved,
  }) {
    return RecipesModel(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      servings: servings ?? this.servings,
      ingredients: ingredients ?? this.ingredients,
      readyInMinutes: readyInMinutes ?? this.readyInMinutes,
      cookingTime: cookingTime ?? this.cookingTime,
      steps: steps ?? this.steps,
      equipment: equipment ?? this.equipment,
      diets: diets ?? this.diets,
      dishType: dishType ?? this.dishType,
      favorite: favorite ?? this.favorite,
      healthy: healthy ?? this.healthy,
      isSaved: isSaved ?? this.isSaved,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RecipesModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
