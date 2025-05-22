import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meals_recipes/services/recipes_services.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  List<Map<String, dynamic>> searchResults = [];

  Future<void> searchRecipes({required String search}) async {
    emit(SearchLoading());
    try {
      searchResults = await RecipesServices().searchRecipes(query: search);
      emit(SearchSuccess());
    } on Exception catch (e) {
      emit(SearchFauiler(errorMessage: e.toString()));
    }
  }
}
