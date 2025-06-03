import 'package:meals_recipes/services/models/recipes_model.dart';

class AllRecipesAtOnesModel {
  final List<RecipesModel> recipes;

  AllRecipesAtOnesModel({required this.recipes});

  factory AllRecipesAtOnesModel.fromJson(dynamic json, {required String type}) {
    List<RecipesModel> allRecipes = [];

    for (var recipe in json) {
      allRecipes.add(RecipesModel.fromJson(recipe, type: type));
    }
    return AllRecipesAtOnesModel(recipes: allRecipes);
  }
}
