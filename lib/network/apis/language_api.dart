import 'package:http/http.dart' as http;

final class LanguageApi {
  LanguageApi._();

  static Future<http.Response?> fetchLocales() {
    final url = Uri.parse('https://libretranslate.com/languages');

    return http.get(url);
  }

  static String getLocaleFlagUrl(String countryCode) {
    return 'https://flagcdn.com/24x18/$countryCode.png';
  }
}
