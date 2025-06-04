import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meals_recipes/services/models/recipes_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'bookmark_state.dart';

class BookmarkCubit extends Cubit<BookmarkState> {
  BookmarkCubit() : super(BookmarkInitial()) {
    initializeSavedRecipes();
  }

  List<RecipesModel> _savedRecipes = [];
  bool isInitialized = false;

  List<RecipesModel> get savedRecipes => List.unmodifiable(_savedRecipes);

  bool isRecipeSaved(RecipesModel recipe) {
    return _savedRecipes.any((savedRecipe) => savedRecipe.id == recipe.id);
  }

  // Initialize saved recipes when cubit is created
  Future<void> initializeSavedRecipes() async {
    if (!isInitialized) {
      await loadSavedState();
      isInitialized = true;
    }
  }

  Future<void> loadSavedState() async {
    try {
      // Don't emit loading if we already have data to prevent UI flickering
      if (_savedRecipes.isEmpty) {
        emit(Bookmarkloading());
      }

      final prefs = await SharedPreferences.getInstance();

      List<String> savedModelsList = prefs.getStringList("saved_model") ?? [];

      if (savedModelsList.isEmpty) {
        _savedRecipes = [];
        emit(BookmarkEmpty(isEmpty: true));
      } else {
        // Parse each saved recipe with error handling
        List<RecipesModel> loadedRecipes = [];
        for (String jsonString in savedModelsList) {
          try {
            RecipesModel recipe = RecipesModel.fromJsonString(
              jsonString,
              // type: "metric",
            );
            loadedRecipes.add(recipe);
          } catch (e) {
            print('Error parsing recipe JSON: $e');
          }
        }

        _savedRecipes = loadedRecipes;
        if (_savedRecipes.isNotEmpty) {
          emit(BookmarkLoaded(recipes: _savedRecipes));
        } else {
          emit(BookmarkEmpty(isEmpty: true));
        }
      }
    } catch (e) {
      print('Error loading saved state: $e');
      emit(BookmarkError(error: e.toString()));
    }
  }

  Future<void> toggleSave({required RecipesModel dataModel}) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      bool wasAlreadySaved = isRecipeSaved(dataModel);

      if (wasAlreadySaved) {
        // Remove the recipe
        _savedRecipes.removeWhere((recipe) => recipe.id == dataModel.id);
        emit(BookmarkDeleted(isDeleted: true));
      } else {
        // Add the recipe with isSaved = true
        RecipesModel recipeToSave = dataModel.copyWith(isSaved: true);
        _savedRecipes.add(recipeToSave);
        emit(BookmarkSaved(isSaved: true));
        try {
          List<String> jsonStringList =
              _savedRecipes.map((recipe) => recipe.toJsonString()).toList();

          await prefs.setStringList("saved_model", jsonStringList);
        } catch (saveError) {
          emit(BookmarkError(error: 'Failed to save bookmark: $saveError'));
          return;
        }
      }
      // Save to SharedPreferences with error handling

      // Emit final state
      if (_savedRecipes.isEmpty) {
        emit(BookmarkEmpty(isEmpty: true));
      } else {
        emit(BookmarkLoaded(recipes: List.from(_savedRecipes)));
      }
    } catch (e) {
      print('Error in toggleSave: $e');
      emit(BookmarkError(error: e.toString()));
    }
  }

  // Method to refresh/reload saved recipes manually
  Future<void> refreshSavedRecipes() async {
    await loadSavedState();
  }

  // Method to clear all saved recipes (for debugging)
  Future<void> clearAllSaved() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove("saved_model");
      _savedRecipes.clear();
      emit(BookmarkEmpty(isEmpty: true));
    } catch (e) {
      print('Error clearing saved recipes: $e');
    }
  }

  // Method to get count of saved recipes
  int get savedCount => _savedRecipes.length;
}
