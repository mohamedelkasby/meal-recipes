import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meals_recipes/services/models/recipes_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'bookmark_state.dart';

class BookmarkCubit extends Cubit<BookmarkState> {
  BookmarkCubit() : super(BookmarkInitial()) {
    _initializeSavedRecipes();
  }

  List<RecipesModel> _savedRecipes = [];
  bool _isInitialized = false;

  List<RecipesModel> get savedRecipes => List.unmodifiable(_savedRecipes);

  bool isRecipeSaved(RecipesModel recipe) {
    return _savedRecipes.any((savedRecipe) => savedRecipe.id == recipe.id);
  }

  // Initialize saved recipes when cubit is created
  Future<void> _initializeSavedRecipes() async {
    if (!_isInitialized) {
      await loadSavedState();
      _isInitialized = true;
    }
  }

  Future<void> loadSavedState() async {
    try {
      // Don't emit loading if we already have data to prevent UI flickering
      if (_savedRecipes.isEmpty) {
        emit(Bookmarkloading());
      }

      final prefs = await SharedPreferences.getInstance();

      // Debug: Print what's actually stored
      print('Loading saved recipes from SharedPreferences...');
      List<String> savedModelsList = prefs.getStringList("saved_model") ?? [];
      print('Found ${savedModelsList.length} saved recipes');

      if (savedModelsList.isEmpty) {
        _savedRecipes = [];
        emit(BookmarkEmpty(isEmpty: true));
        print('No saved recipes found');
      } else {
        // Parse each saved recipe with error handling
        List<RecipesModel> loadedRecipes = [];
        for (String jsonString in savedModelsList) {
          try {
            RecipesModel recipe = RecipesModel.fromJsonString(jsonString);
            loadedRecipes.add(recipe);
            print('Successfully loaded recipe: ${recipe.title}');
          } catch (e) {
            print('Error parsing recipe JSON: $e');
            print('Problematic JSON: $jsonString');
            // Continue with other recipes even if one fails
          }
        }

        _savedRecipes = loadedRecipes;
        if (_savedRecipes.isNotEmpty) {
          emit(BookmarkLoaded(recipes: _savedRecipes));
          print('Loaded ${_savedRecipes.length} recipes successfully');
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
        print('Removed recipe: ${dataModel.title}');
        emit(BookmarkDeleted(isDeleted: true));
      } else {
        // Add the recipe with isSaved = true
        RecipesModel recipeToSave = dataModel.copyWith(isSaved: true);
        _savedRecipes.add(recipeToSave);
        print('Added recipe: ${dataModel.title}');
        emit(BookmarkSaved(isSaved: true));
      }

      // Save to SharedPreferences with error handling
      try {
        List<String> jsonStringList =
            _savedRecipes.map((recipe) => recipe.toJsonString()).toList();

        bool success = await prefs.setStringList("saved_model", jsonStringList);
        print('Saved to SharedPreferences: $success');
        print('Total saved recipes: ${_savedRecipes.length}');

        // Verify the save by reading it back
        List<String>? verification = prefs.getStringList("saved_model");
        print(
          'Verification - recipes in storage: ${verification?.length ?? 0}',
        );
      } catch (saveError) {
        print('Error saving to SharedPreferences: $saveError');
        // Revert the in-memory change if save failed
        if (wasAlreadySaved) {
          _savedRecipes.add(dataModel);
        } else {
          _savedRecipes.removeWhere((recipe) => recipe.id == dataModel.id);
        }
        emit(BookmarkError(error: 'Failed to save bookmark: $saveError'));
        return;
      }

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

  Future<void> removeRecipe(RecipesModel recipe) async {
    try {
      _savedRecipes.removeWhere((r) => r.id == recipe.id);

      final prefs = await SharedPreferences.getInstance();
      List<String> jsonStringList =
          _savedRecipes.map((recipe) => recipe.toJsonString()).toList();

      await prefs.setStringList("saved_model", jsonStringList);
      print('Removed recipe: ${recipe.title}');

      if (_savedRecipes.isEmpty) {
        emit(BookmarkEmpty(isEmpty: true));
      } else {
        emit(BookmarkLoaded(recipes: List.from(_savedRecipes)));
      }
    } catch (e) {
      print('Error removing recipe: $e');
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
      print('Cleared all saved recipes');
    } catch (e) {
      print('Error clearing saved recipes: $e');
    }
  }

  // Method to get count of saved recipes
  int get savedCount => _savedRecipes.length;
}
