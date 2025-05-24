part of 'language_cubit.dart';

sealed class LanguageState {}

final class LanguageInitial extends LanguageState {}

final class LanguageLoading extends LanguageState {}

final class LanguageChanged extends LanguageState {
  final String language;
  LanguageChanged({required this.language});
}

final class LanguageError extends LanguageState {
  final String error;
  LanguageError({required this.error});
}
