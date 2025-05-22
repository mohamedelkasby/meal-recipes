part of 'search_cubit.dart';

sealed class SearchState {}

final class SearchInitial extends SearchState {}

final class SearchLoading extends SearchState {}

final class SearchSuccess extends SearchState {}

final class CloseSearch extends SearchState {}

final class SearchFauiler extends SearchState {
  final String errorMessage;
  SearchFauiler({required this.errorMessage});
}
