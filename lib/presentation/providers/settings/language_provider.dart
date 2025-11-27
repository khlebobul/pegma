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
  Future<Locale> build() async {
    return await _loadLanguage();
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

  Future<Locale> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguageCode = prefs.getString(_languageKey);

    if (savedLanguageCode != null) {
      // использовать сохранённый язык
      switch (savedLanguageCode) {
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
    } else {
      // использовать язык системы, если не сохранён
      return _getSystemLocale();
    }
  }

  Future<void> _saveLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }

  Future<void> setLanguage(Locale locale) async {
    await _saveLanguage(locale.languageCode);
    ref.invalidateSelf();
    await future;
  }

  Future<void> setEnglish() async {
    await _saveLanguage('en');
    ref.invalidateSelf();
    await future;
  }

  Future<void> setRussian() async {
    await _saveLanguage('ru');
    ref.invalidateSelf();
    await future;
  }

  Future<void> setSpanish() async {
    await _saveLanguage('es');
    ref.invalidateSelf();
    await future;
  }

  Future<void> setItalian() async {
    await _saveLanguage('it');
    ref.invalidateSelf();
    await future;
  }

  Future<void> setFrench() async {
    await _saveLanguage('fr');
    ref.invalidateSelf();
    await future;
  }

  Future<void> setGerman() async {
    await _saveLanguage('de');
    ref.invalidateSelf();
    await future;
  }

  bool isEnglish() => state.hasValue && state.value?.languageCode == 'en';
  bool isRussian() => state.hasValue && state.value?.languageCode == 'ru';
  bool isSpanish() => state.hasValue && state.value?.languageCode == 'es';
  bool isItalian() => state.hasValue && state.value?.languageCode == 'it';
  bool isFrench() => state.hasValue && state.value?.languageCode == 'fr';
  bool isGerman() => state.hasValue && state.value?.languageCode == 'de';

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
