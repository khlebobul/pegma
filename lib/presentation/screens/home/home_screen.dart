import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pegma/core/constants/app_constants.dart';
import 'package:pegma/core/router/app_router.dart';
import 'package:pegma/core/themes/app_theme.dart';
import '../../widgets/common/app_bar_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = UIThemes.of(context);
    return Scaffold(
      backgroundColor: theme.bgColor,
      appBar: CustomAppBar(
        title: GeneralConsts.appName,
        showBackButton: false,
        showMenuButton: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: GeneralConsts.horizontalPadding,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 1.0,
        ),
        itemCount: 40,
        itemBuilder: (context, index) {
          final number = index + 1;
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              context.go(AppRouter.game);
            },
            child: Center(
              child: Text(number.toString(), style: theme.menuTextStyle),
            ),
          );
        },
      ),
    );
  }
}
