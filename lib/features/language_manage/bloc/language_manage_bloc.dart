import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/_shared/data/locale_language.dart';
import 'package:public_chat/network/services/language_services.dart';
import 'package:public_chat/utils/bloc_extensions.dart';

part 'language_manage_event.dart';
part 'language_manage_state.dart';

final class LanguageManageBloc
    extends Bloc<LanguageManageEvent, LanguageManageState> {
  final searchTextController = TextEditingController();
  Timer? queryTimer;

  LanguageManageBloc() : super(const LanguageManageState()) {
    on<LanguageManageInit>(_onInit);
    on<LanguageManageSearchTextChanged>(_onSearchTextChanged);
    on<LanguageManageSearch>(_onSearch);
    on<LanguageManageClearSearchText>(_onClearSearchText);
  }

  @override
  Future<void> close() {
    queryTimer?.cancel();

    return super.close();
  }

  void _onInit(
      LanguageManageInit event, Emitter<LanguageManageState> emit) async {
    try {
      var languages = await LanguageServices.fetchLocales();

      if (event.supportedLocales.isNotEmpty) {
        final supportCode = event.supportedLocales.map((e) => e.languageCode);

        final prioritizedLanguages = <LocaleLanguage>[];
        final nonPrioritizedLanguages = <LocaleLanguage>[];

        for (final language in languages) {
          supportCode.contains(language.languageCode)
              ? prioritizedLanguages.add(language)
              : nonPrioritizedLanguages.add(language);
        }

        languages = [...prioritizedLanguages, ...nonPrioritizedLanguages];
      }

      emitSafely(state.copyWith(
          selectedLanguageCode: event.selectedLanguageCode,
          status: LanguageFetchStatus.success,
          languages: languages,
          languagesFiltered: languages,
          errorMessage: ''));
    } catch (e) {
      emitSafely(state.copyWith(
          selectedLanguageCode: event.selectedLanguageCode,
          status: LanguageFetchStatus.failed,
          errorMessage: e.toString()));
    }
  }

  void _onSearchTextChanged(LanguageManageSearchTextChanged event,
      Emitter<LanguageManageState> emit) {
    emitSafely(
        state.copyWith(searchText: event.searchText.trim().toLowerCase()));

    queryTimer?.cancel();
    queryTimer = Timer(
      const Duration(milliseconds: 500),
      () {
        add(LanguageManageSearch());
      },
    );
  }

  void _onClearSearchText(
      LanguageManageClearSearchText event, Emitter<LanguageManageState> emit) {
    queryTimer?.cancel();
    searchTextController.clear();
    emitSafely(
        state.copyWith(languagesFiltered: state.languages, searchText: ''));
  }

  void _onSearch(
      LanguageManageSearch event, Emitter<LanguageManageState> emit) {
    bool isContainText(List<String?> keys, String query) {
      var isContain = false;

      for (final key in keys) {
        if (key != null) isContain = key.toLowerCase().contains(query);
        if (isContain) break;
      }

      return isContain;
    }

    final languageFiltered = <LocaleLanguage>[];

    for (final language in state.languages) {
      if (isContainText([
        language.name,
        language.navigateName,
        language.languageCode,
        language.countryCode
      ], state.searchText)) {
        languageFiltered.add(language);
      }
    }

    emitSafely(state.copyWith(languagesFiltered: languageFiltered));
  }
}
