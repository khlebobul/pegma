import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pegma/core/constants/app_constants.dart';
import 'package:pegma/core/themes/app_theme.dart';
import 'package:pegma/core/router/app_router.dart';
import 'package:pegma/presentation/widgets/splash_screen/rotating_text.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        context.go(AppRouter.home);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = UIThemes.of(context);

    return Scaffold(
      backgroundColor: theme.bgColor,
      body: Center(
        child: RotatingCircleText(
          text: '  ${GeneralConsts.appName}   ${GeneralConsts.madeBy}',
          radius: 120,
          textStyle: theme.menuTextStyle,
          rotationDuration: const Duration(seconds: 12),
        ),
      ),
    );
  }
}
