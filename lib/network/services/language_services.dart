import 'dart:convert';

import 'package:public_chat/_shared/data/locale_language.dart';
import 'package:public_chat/network/apis/language_api.dart';

final class LanguageServices {
  LanguageServices._();

  static Future<List<LocaleLanguage>> fetchLocales() async {
    final response = await LanguageApi.fetchLocales();

    if (response != null && response.statusCode == 200) {
      final locales = <LocaleLanguage>[];

      final List<dynamic> languages = jsonDecode(response.body);

      for (final Map language in languages) {
        locales.add(LocaleLanguage.fromJson(language));
      }

      return locales;
    } else {
      throw Exception('Failed to load locales');
    }
  }
}
