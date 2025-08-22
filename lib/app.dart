import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pegma/core/themes/app_theme.dart';
import 'core/router/app_router.dart';
import 'presentation/providers/settings/theme_provider.dart';
import 'presentation/providers/settings/language_provider.dart';
import 'generated/l10n.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);
    final locale = ref.watch(languageNotifierProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
      theme: UIThemes.lightTheme(),
      darkTheme: UIThemes.darkTheme(),
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      title: 'Pegma',
    );
  }
}
