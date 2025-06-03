import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meals_recipes/services/models/recipes_model.dart';
import 'package:meals_recipes/services/recipes_services.dart';

part 'recipes_state.dart';

class RecipesCubit extends Cubit<RecipesState> {
  RecipesCubit() : super(RecipesInitial()) {
    getAllRecipes();
    getRandomRecipes();
  }

  List<RecipesModel> allRecipes = [];
  List<String> categories = [];
  List<Map<String, dynamic>> searchResults = [];
  String _unitType = "metric";
  String get unitType => _unitType;
  bool get ismetric => _unitType == 'metric';
  bool get isUS => _unitType == 'us';

  Future<void> unitToggleButton() async {
    try {
      _unitType = _unitType == 'metric' ? 'us' : 'metric';

      emit(UnitTypeChanged(_unitType));
    } catch (e) {
      emit(RecipesFauiler(errorMessage: e.toString()));
    }
  }

  List<RecipesModel> randomRecipes = [
    RecipesModel(
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
    ),
  ];

  Future<void> getAllRecipes() async {
    emit(RecipesLoading());
    try {
      allRecipes = await RecipesServices().fetchAllRecipes(type: _unitType);
      emit(RecipesSuccess());
    } on Exception catch (e) {
      emit(RecipesFauiler(errorMessage: e.toString()));
    }
  }

  Future<void> getCategoryRecipes() async {
    for (var element in allRecipes) {
      categories.addAll(element.dishType);
    }
    categories = categories.toSet().toList();
    emit(Recipescategorysuccess());
    // print(categories);
  }

  Future<void> getRandomRecipes() async {
    emit(RecipesLoading());
    try {
      randomRecipes = await RecipesServices().fetchRandomRecipes(
        type: "metric",
      );
      emit(RecipesSuccess());
      // print(randomRecipe);
    } on Exception catch (e) {
      emit(RecipesFauiler(errorMessage: e.toString()));
    }
  }
}
