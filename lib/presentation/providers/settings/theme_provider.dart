import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_provider.g.dart';

@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  static const String _themeKey = 'theme_mode';

  @override
  Future<ThemeMode> build() async {
    return await _loadTheme();
  }

  Future<ThemeMode> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeKey) ?? ThemeMode.system.index;
    return ThemeMode.values[themeIndex];
  }

  Future<void> _saveTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, mode.index);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _saveTheme(mode);
    ref.invalidateSelf();
    await future;
  }

  Future<void> toggleTheme() async {
    final currentMode = state.hasValue ? state.value : ThemeMode.system;
    ThemeMode newMode;
    switch (currentMode!) {
      case ThemeMode.light:
        newMode = ThemeMode.dark;
        break;
      case ThemeMode.dark:
        newMode = ThemeMode.light;
        break;
      case ThemeMode.system:
        newMode = ThemeMode.light;
        break;
    }
    await _saveTheme(newMode);
    ref.invalidateSelf();
    await future;
  }

  bool isDarkMode() => state.hasValue && state.value == ThemeMode.dark;
  bool isLightMode() => state.hasValue && state.value == ThemeMode.light;
  bool isSystemMode() => state.hasValue && state.value == ThemeMode.system;
}
