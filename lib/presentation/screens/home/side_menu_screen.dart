import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pegma/core/constants/app_constants.dart';
import 'package:pegma/core/themes/app_theme.dart';
import 'package:pegma/generated/l10n.dart';
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
              padding: const EdgeInsets.all(GeneralConsts.verticalPadding * 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    GeneralConsts.appName,
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
                padding: const EdgeInsets.symmetric(
                  vertical: GeneralConsts.verticalPadding / 2,
                ),
                children: [
                  _MenuListItem(
                    title: S.of(context).settings,
                    onTap: () {
                      context.go(AppRouter.settings);
                    },
                  ),
                  _MenuListItem(
                    title: S.of(context).rules,
                    onTap: () {
                      context.go(AppRouter.rules);
                    },
                  ),
                  _MenuListItem(
                    title: S.of(context).story,
                    onTap: () {
                      context.go(AppRouter.story);
                    },
                  ),
                  _MenuListItem(
                    title: S.of(context).about,
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
        horizontal: GeneralConsts.horizontalPadding,
        vertical: GeneralConsts.verticalPadding,
      ),
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
    );
  }
}
