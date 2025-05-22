import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meals_recipes/services/recipes_services.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  List<Map<String, dynamic>> searchResults = [];

  void clearSearchResults() {
    searchResults = [];
    emit(CloseSearch());
  }

  void steadySearchResults() {
    emit(SearchLoading());
  }

  Future<void> searchRecipes({required String search}) async {
    emit(SearchLoading());
    try {
      if (search.isEmpty || search == '') {
        emit(CloseSearch());
        return;
      }
      searchResults = await RecipesServices().searchRecipes(query: search);
      emit(SearchSuccess());
    } on Exception catch (e) {
      emit(SearchFauiler(errorMessage: e.toString()));
    }
  }
}
