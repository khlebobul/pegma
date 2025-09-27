import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'language_provider.g.dart';

@riverpod
class LanguageNotifier extends _$LanguageNotifier {
  static const String _languageKey = 'language_code';

  static const List<String> supportedLanguages = ['en', 'ru'];

  @override
  Locale build() {
    _loadLanguage();
    return _getSystemLocale();
  }

  Locale _getSystemLocale() {
    final systemLocale = ui.PlatformDispatcher.instance.locale;
    final systemLanguageCode = systemLocale.languageCode;

    if (supportedLanguages.contains(systemLanguageCode)) {
      switch (systemLanguageCode) {
        case 'ru':
          return const Locale('ru', 'RU');
        case 'en':
          return const Locale('en', 'US');
        default:
          return const Locale('en', 'US');
      }
    }

    return const Locale('en', 'US');
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguageCode = prefs.getString(_languageKey);

    if (savedLanguageCode != null) {
      // Use saved language
      switch (savedLanguageCode) {
        case 'ru':
          state = const Locale('ru', 'RU');
          break;
        case 'en':
        default:
          state = const Locale('en', 'US');
          break;
      }
    } else {
      // Use system locale if no saved language
      state = _getSystemLocale();
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

  static bool isLanguageSupported(String languageCode) {
    return supportedLanguages.contains(languageCode);
  }

  static List<Locale> getSupportedLocales() {
    return supportedLanguages.map((code) {
      switch (code) {
        case 'ru':
          return const Locale('ru', 'RU');
        case 'en':
        default:
          return const Locale('en', 'US');
      }
    }).toList();
  }
}
