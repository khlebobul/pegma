import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pegma/core/themes/app_theme.dart';
import '../../../core/router/app_router.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final bool showMenuButton;

  const CustomAppBar({
    super.key,
    this.title = '',
    this.showBackButton = false,
    this.showMenuButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = UIThemes.of(context);
    return AppBar(
      backgroundColor: theme.bgColor,
      elevation: 0,
      centerTitle: false,
      title: Text(title, style: theme.basicTextStyle),
      titleSpacing: 16,
      automaticallyImplyLeading: false,
      actions: [
        if (showBackButton)
          IconButton(
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(AppRouter.home);
              }
            },
            icon: const Icon(Icons.close, color: Colors.black87),
          )
        else if (showMenuButton)
          IconButton(
            onPressed: () => context.push(AppRouter.sideMenu),
            icon: const Icon(Icons.menu, color: Colors.black87),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
