import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'language_provider.g.dart';

@riverpod
class LanguageNotifier extends _$LanguageNotifier {
  static const String _languageKey = 'language_code';

  @override
  Locale build() {
    _loadLanguage();
    return const Locale('en', 'US');
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageKey) ?? 'en';

    switch (languageCode) {
      case 'ru':
        state = const Locale('ru', 'RU');
        break;
      case 'en':
      default:
        state = const Locale('en', 'US');
        break;
    }
  }

  Future<void> _saveLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }

  Future<void> setLanguage(Locale locale) async {
    state = locale;
    await _saveLanguage(locale.languageCode);
  }

  Future<void> setEnglish() async {
    const locale = Locale('en', 'US');
    state = locale;
    await _saveLanguage('en');
  }

  Future<void> setRussian() async {
    const locale = Locale('ru', 'RU');
    state = locale;
    await _saveLanguage('ru');
  }

  bool get isEnglish => state.languageCode == 'en';
  bool get isRussian => state.languageCode == 'ru';
}
