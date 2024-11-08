import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/_shared/data/locale_language.dart';
import 'package:public_chat/utils/bloc_extensions.dart';
import 'package:public_chat/utils/locale_support.dart';

class LocaleCubit extends Cubit<LocaleLanguage?> {
  LocaleCubit() : super(null);

  void init(BuildContext context) {
    setLocale(
        LocaleLanguage.fromLanguage(languageCode: context.locale.localeName));
  }

  void setLocale(LocaleLanguage locale) => emitSafely(locale);
}
