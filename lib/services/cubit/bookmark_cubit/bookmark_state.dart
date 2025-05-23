part of 'bookmark_cubit.dart';

sealed class BookmarkState {}

final class BookmarkInitial extends BookmarkState {}

final class Bookmarkloading extends BookmarkState {}

final class BookmarkLoaded extends BookmarkState {
  final List<RecipesModel> recipes;
  BookmarkLoaded({required this.recipes});
}

final class BookmarkError extends BookmarkState {
  final String error;
  BookmarkError({required this.error});
}

final class BookmarkSaved extends BookmarkState {
  final bool isSaved;
  BookmarkSaved({required this.isSaved});
}

final class BookmarkDeleted extends BookmarkState {
  final bool isDeleted;
  BookmarkDeleted({required this.isDeleted});
}

final class BookmarkEmpty extends BookmarkState {
  final bool isEmpty;
  BookmarkEmpty({required this.isEmpty});
}
