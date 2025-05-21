import 'package:meals_recipes/services/models/equipement_model.dart';
import 'package:meals_recipes/services/models/ingredient_model.dart';
import 'package:meals_recipes/services/models/steps_model.dart';

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
  });

  factory RecipesModel.fromJson(Map<String, dynamic> json) {
    List<EquipmentModel> allEquipment = [];

    if (json['analyzedInstructions'].isNotEmpty) {
      for (var step in json['analyzedInstructions'][0]['steps']) {
        if (step['equipment'] != null && step['equipment'].isNotEmpty) {
          for (var equipment in step['equipment']) {
            // Add equipment to the list if it has valid data
            if (equipment != null) {
              allEquipment.add(EquipmentModel.fromJson(equipment));
            }
          }
        }
      }
    }

    return RecipesModel(
      id: json['id'],
      title: json['title'],
      imageUrl: json['image'],
      description: json['summary'],
      readyInMinutes: json['readyInMinutes'].toString(),
      cookingTime: json['cookingMinutes'].toString(),
      dishType: List<String>.from(json['dishTypes']),
      servings: json['servings'],
      ingredients: List<IngredientModel>.from(
        json['extendedIngredients'].map((x) => IngredientModel.fromJson(x)),
      ),
      diets: List<String>.from(json['diets']),

      steps:
          json['analyzedInstructions'].isNotEmpty
              ? List<StepsModel>.from(
                json['analyzedInstructions'][0]['steps'].map(
                  (x) => StepsModel.fromJson(x),
                ),
              )
              : [],
      equipment: allEquipment.isEmpty ? [] : allEquipment,
      healthy: json['veryHealthy'] ?? false,
      favorite: json['veryPopular'] ?? false,
    );
  }
}
