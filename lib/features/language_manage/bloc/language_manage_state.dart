part of 'language_manage_bloc.dart';

final class LanguageManageState extends Equatable {
  final LanguageFetchStatus status;
  final List<LocaleLanguage> languages, languagesFiltered;
  final String errorMessage, searchText;
  final String? selectedLanguageCode;

  const LanguageManageState({
    this.status = LanguageFetchStatus.initial,
    this.languages = const [],
    this.languagesFiltered = const [],
    this.errorMessage = '',
    this.searchText = '',
    this.selectedLanguageCode,
  });

  LanguageManageState copyWith({
    LanguageFetchStatus? status,
    List<LocaleLanguage>? languages,
    List<LocaleLanguage>? languagesFiltered,
    String? errorMessage,
    String? searchText,
    String? selectedLanguageCode,
  }) =>
      LanguageManageState(
        status: status ?? this.status,
        languages: languages ?? this.languages,
        languagesFiltered: languagesFiltered ?? this.languagesFiltered,
        errorMessage: errorMessage ?? this.errorMessage,
        searchText: searchText ?? this.searchText,
        selectedLanguageCode: selectedLanguageCode ?? this.selectedLanguageCode,
      );

  @override
  List<Object?> get props => [
        status,
        languages,
        languagesFiltered,
        errorMessage,
        searchText,
        selectedLanguageCode
      ];
}

enum LanguageFetchStatus { initial, success, failed }
