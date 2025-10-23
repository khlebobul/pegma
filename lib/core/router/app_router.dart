import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pegma/presentation/screens/info/story_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/home/splash_screen.dart';
import '../../presentation/screens/game/game_screen.dart';
import '../../presentation/screens/settings/settings_screen.dart';
import '../../presentation/screens/info/about_screen.dart';
import '../../presentation/screens/home/side_menu_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String home = '/home';
  static const String game = '/game';
  static const String settings = '/settings';
  static const String about = '/about';
  static const String sideMenu = '/side-menu';
  static const String story = '/story';

  static Page<void> _slideTransition(Widget child, GoRouterState state) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  static Page<void> _slideUpTransition(Widget child, GoRouterState state) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 250),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  static Page<void> _fadeTransition(Widget child, GoRouterState state) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 200),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        pageBuilder: (context, state) =>
            _fadeTransition(const SplashScreen(), state),
      ),
      GoRoute(
        path: home,
        pageBuilder: (context, state) =>
            _fadeTransition(const HomeScreen(), state),
      ),
      GoRoute(
        path: '$game/:levelId',
        name: game,
        pageBuilder: (context, state) {
          final levelId = int.parse(state.pathParameters['levelId']!);
          return _fadeTransition(GameScreen(levelId: levelId), state);
        },
      ),
      GoRoute(
        path: settings,
        pageBuilder: (context, state) =>
            _slideTransition(const SettingsScreen(), state),
      ),
      GoRoute(
        path: about,
        pageBuilder: (context, state) =>
            _slideTransition(const AboutScreen(), state),
      ),
      GoRoute(
        path: story,
        pageBuilder: (context, state) =>
            _slideTransition(const StoryScreen(), state),
      ),
      GoRoute(
        path: sideMenu,
        pageBuilder: (context, state) =>
            _slideUpTransition(const SideMenuScreen(), state),
      ),
    ],
  );
}
