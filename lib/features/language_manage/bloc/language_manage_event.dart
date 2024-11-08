part of 'language_manage_bloc.dart';

sealed class LanguageManageEvent extends Equatable {
  const LanguageManageEvent();

  @override
  List<Object?> get props => [];
}

final class LanguageManageInit extends LanguageManageEvent {
  final List<Locale> supportedLocales;
  final String? selectedLanguageCode;

  const LanguageManageInit({
    required this.supportedLocales,
    required this.selectedLanguageCode,
  });

  @override
  List<Object?> get props => [supportedLocales, selectedLanguageCode];
}

final class LanguageManageSearch extends LanguageManageEvent {}

final class LanguageManageClearSearchText extends LanguageManageEvent {}

final class LanguageManageSearchTextChanged extends LanguageManageEvent {
  final String searchText;

  const LanguageManageSearchTextChanged({required this.searchText});

  @override
  List<Object?> get props => [searchText];
}
