import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pegma/core/constants/app_constants.dart';
import 'package:pegma/core/themes/app_theme.dart';
import '../../../core/router/app_router.dart';

class SideMenuScreen extends StatelessWidget {
  const SideMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = UIThemes.of(context);
    return Scaffold(
      backgroundColor: theme.bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AboutConstants.appName,
                    style: theme.basicTextStyle.copyWith(
                      color: theme.secondaryTextColor,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: SvgPicture.asset(
                      CustomIcons.close,
                      width: 20,
                      colorFilter: ColorFilter.mode(
                        theme.textColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                children: [
                  _MenuListItem(
                    title: 'settings',
                    onTap: () {
                      context.go(AppRouter.settings);
                    },
                  ),
                  _MenuListItem(
                    title: 'rules',
                    onTap: () {
                      context.go(AppRouter.rules);
                    },
                  ),
                  _MenuListItem(
                    title: 'story',
                    onTap: () {
                      context.go(AppRouter.story);
                    },
                  ),
                  _MenuListItem(
                    title: 'about',
                    onTap: () {
                      context.go(AppRouter.about);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuListItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _MenuListItem({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = UIThemes.of(context);
    return ListTile(
      title: Text(title, style: theme.menuTextStyle),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 8.0,
      ),
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
    );
  }
}
