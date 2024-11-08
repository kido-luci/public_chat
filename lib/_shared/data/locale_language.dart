import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:public_chat/network/apis/language_api.dart';

final class LocaleLanguage extends Equatable {
  final String languageCode;
  final String? countryCode;
  final String name;
  final String? navigateName;

  static const _mappingLanguages = {
    'vi': LocaleLanguage(
        languageCode: 'vi',
        countryCode: 'vn',
        name: 'Vietnamese',
        navigateName: 'Tiếng Việt'),
    'en': LocaleLanguage(
        languageCode: 'en',
        countryCode: 'us',
        name: 'English',
        navigateName: 'English'),
  };

  const LocaleLanguage({
    required this.languageCode,
    required this.countryCode,
    required this.name,
    required this.navigateName,
  });

  factory LocaleLanguage.fromLanguage({
    required String languageCode,
    String? countryCode,
    String? name,
    String? navigateName,
  }) {
    final mappingLanguage = _mappingLanguages[languageCode];

    return LocaleLanguage(
      languageCode: languageCode,
      countryCode: countryCode ?? mappingLanguage?.countryCode,
      name: name ?? mappingLanguage?.name ?? 'N/A',
      navigateName: navigateName ?? mappingLanguage?.navigateName,
    );
  }

  factory LocaleLanguage.fromJson(Map json) => LocaleLanguage.fromLanguage(
      languageCode: json['code'], name: json['name']);

  Locale get locale => Locale(languageCode, countryCode);

  String get flagUrl =>
      LanguageApi.getLocaleFlagUrl(locale.countryCode ?? locale.languageCode);

  @override
  List<Object?> get props => [languageCode, countryCode];
}
