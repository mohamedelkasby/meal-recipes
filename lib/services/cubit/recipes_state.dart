part of 'recipes_cubit.dart';

sealed class RecipesState {}

final class RecipesInitial extends RecipesState {}

final class RecipesLoading extends RecipesState {}

final class RecipesSuccess extends RecipesState {}

final class RecipesFauiler extends RecipesState {
  final String errorMessage;
  RecipesFauiler({required this.errorMessage});
}

final class Recipescategorysuccess extends RecipesState {}

final class SearchRecipesState extends RecipesState {
  // final String searchRecipes;
  // SearchRecipesState({required this.searchRecipes});
}
