import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:meals_recipes/const.dart';
import 'package:meals_recipes/services/models/all_recipes_at_ones_model.dart';
import 'package:meals_recipes/services/models/recipes_model.dart';

class RecipesServices {
  String baseUrl = 'https://api.spoonacular.com/recipes/';
  String apiKey = apikey;
  String allRecipesUrl =
      'https://api.jsonsilo.com/public/ced65a81-144e-4e36-b59d-c1e7b4d6fe2a';

  String randomRecipesUrl =
      'https://api.spoonacular.com/recipes/random?number=10&apiKey=$apikey';

  Future<List<RecipesModel>> fetchAllRecipes() async {
    try {
      http.Response response = await http.get(Uri.parse(allRecipesUrl));
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        AllRecipesAtOnesModel allRecipesAtOnesModel =
            AllRecipesAtOnesModel.fromJson(jsonData);
        return allRecipesAtOnesModel.recipes;
      } else {
        print('Failed to load recipes${response.statusCode}');
        return [];
      }
    } on Exception catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future<RecipesModel> fetchRecipeById({required id}) async {
    try {
      http.Response response = await http.get(
        Uri.parse("$baseUrl$id/information?apiKey=$apikey"),
      );
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        RecipesModel recipesModel = RecipesModel.fromJson(jsonData);
        return recipesModel;
      } else {
        return RecipesModel(
          id: 0,
          title: '',
          imageUrl: '',
          description: '',
          cookingTime: "0",
          readyInMinutes: "0",
          ingredients: [],
          steps: [],
          servings: 0,
          diets: [],
          dishType: [],
          equipment: [],
          favorite: false,
          healthy: false,
        );
      }
    } on Exception catch (e) {
      print('Error: $e');
      return RecipesModel(
        id: 0,
        title: '',
        imageUrl: '',
        description: '',
        cookingTime: "0",
        readyInMinutes: "0",
        ingredients: [],
        steps: [],
        servings: 0,
        diets: [],
        dishType: [],
        equipment: [],
        favorite: false,
        healthy: false,
      );
    }
  }
}
