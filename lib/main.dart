import 'package:flutter/material.dart';
import 'package:pegma/core/themes/app_theme.dart';
import 'core/router/app_router.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
      theme: UIThemes.lightTheme(),
      darkTheme: UIThemes.darkTheme(),
      // themeMode: themeMode,
    );
  }
}
