import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meals_recipes/services/models/recipes_model.dart';
import 'package:meals_recipes/services/recipes_services.dart';

part 'recipes_state.dart';

class RecipesCubit extends Cubit<RecipesState> {
  RecipesCubit() : super(RecipesInitial()) {
    getAllRecipes();
  }

  List<RecipesModel> allRecipes = [];
  List<String> categories = [];

  Future<void> getAllRecipes() async {
    emit(RecipesLoading());
    try {
      allRecipes = await RecipesServices().fetchAllRecipes();
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
    print(categories);
  }
}
