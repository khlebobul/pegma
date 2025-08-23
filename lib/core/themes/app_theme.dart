import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pegma/core/themes/app_colors.dart';

class UIThemes {
  final Brightness brightness;

  UIThemes({this.brightness = Brightness.light});

  // Light mode
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'Pegma',
      scaffoldBackgroundColor: LightModeColors.background,
      dividerColor: Colors.transparent,
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        centerTitle: true,
        backgroundColor: LightModeColors.background,
        elevation: 0,
      ),
      colorScheme: const ColorScheme.light(
        primary: Colors.transparent,
        surface: LightModeColors.background,
      ),
    );
  }

  // Dark mode
  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Pegma',
      scaffoldBackgroundColor: DarkModeColors.background,
      dividerColor: Colors.transparent,
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        centerTitle: true,
        backgroundColor: DarkModeColors.background,
        elevation: 0,
      ),
      colorScheme: const ColorScheme.dark(
        primary: Colors.transparent,
        surface: DarkModeColors.background,
      ),
    );
  }

  static UIThemes of(BuildContext context) {
    return UIThemes(brightness: Theme.of(context).brightness);
  }

  bool get isDarkTheme => brightness == Brightness.dark;

  // text styles
  // main menu
  TextStyle get menuTextStyle => TextStyle(
    fontSize: 25,
    fontFamily: 'Pegma',
    color: textColor,
    fontWeight: FontWeight.bold,
    wordSpacing: 5,
  );

  // basic text
  TextStyle get basicTextStyle => TextStyle(
    fontSize: 20,
    fontFamily: 'Pegma',
    color: textColor,
    fontWeight: FontWeight.bold,
    wordSpacing: 10,
  );

  // Colors
  Color get bgColor =>
      isDarkTheme ? DarkModeColors.background : LightModeColors.background;
  Color get textColor =>
      isDarkTheme ? DarkModeColors.text : LightModeColors.text;
  Color get secondaryTextColor => isDarkTheme
      ? DarkModeColors.secondaryText
      : LightModeColors.secondaryText;
  Color get highlightColor => isDarkTheme
      ? DarkModeColors.highlightColor
      : LightModeColors.highlightColor;
}
