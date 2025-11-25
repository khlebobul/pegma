import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'language_provider.g.dart';

@riverpod
class LanguageNotifier extends _$LanguageNotifier {
  static const String _languageKey = 'language_code';

  static const List<String> supportedLanguages = [
    'en',
    'ru',
    'es',
    'it',
    'fr',
    'de',
  ];

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
        case 'es':
          return const Locale('es', 'ES');
        case 'it':
          return const Locale('it', 'IT');
        case 'fr':
          return const Locale('fr', 'FR');
        case 'de':
          return const Locale('de', 'DE');
        case 'en':
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
      // использовать сохранённый язык
      switch (savedLanguageCode) {
        case 'ru':
          state = const Locale('ru', 'RU');
          break;
        case 'es':
          state = const Locale('es', 'ES');
          break;
        case 'it':
          state = const Locale('it', 'IT');
          break;
        case 'fr':
          state = const Locale('fr', 'FR');
          break;
        case 'de':
          state = const Locale('de', 'DE');
          break;
        case 'en':
        default:
          state = const Locale('en', 'US');
          break;
      }
    } else {
      // использовать язык системы, если не сохранён
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

  Future<void> setSpanish() async {
    const locale = Locale('es', 'ES');
    state = locale;
    await _saveLanguage('es');
  }

  Future<void> setItalian() async {
    const locale = Locale('it', 'IT');
    state = locale;
    await _saveLanguage('it');
  }

  Future<void> setFrench() async {
    const locale = Locale('fr', 'FR');
    state = locale;
    await _saveLanguage('fr');
  }

  Future<void> setGerman() async {
    const locale = Locale('de', 'DE');
    state = locale;
    await _saveLanguage('de');
  }

  bool get isEnglish => state.languageCode == 'en';
  bool get isRussian => state.languageCode == 'ru';
  bool get isSpanish => state.languageCode == 'es';
  bool get isItalian => state.languageCode == 'it';
  bool get isFrench => state.languageCode == 'fr';
  bool get isGerman => state.languageCode == 'de';

  static bool isLanguageSupported(String languageCode) {
    return supportedLanguages.contains(languageCode);
  }

  static List<Locale> getSupportedLocales() {
    return supportedLanguages.map((code) {
      switch (code) {
        case 'ru':
          return const Locale('ru', 'RU');
        case 'es':
          return const Locale('es', 'ES');
        case 'it':
          return const Locale('it', 'IT');
        case 'fr':
          return const Locale('fr', 'FR');
        case 'de':
          return const Locale('de', 'DE');
        case 'en':
        default:
          return const Locale('en', 'US');
      }
    }).toList();
  }
}
