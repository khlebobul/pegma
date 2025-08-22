import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'language_provider.g.dart';

@riverpod
class LanguageNotifier extends _$LanguageNotifier {
  @override
  Locale build() {
    return const Locale('en', 'US');
  }

  void setLanguage(Locale locale) {
    state = locale;
  }

  void setEnglish() {
    state = const Locale('en', 'US');
  }

  void setRussian() {
    state = const Locale('ru', 'RU');
  }

  bool get isEnglish => state.languageCode == 'en';
  bool get isRussian => state.languageCode == 'ru';
}
