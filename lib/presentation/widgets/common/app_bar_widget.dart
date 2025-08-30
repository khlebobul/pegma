import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pegma/core/constants/app_constants.dart';
import 'package:pegma/core/themes/app_theme.dart';
import '../../../core/router/app_router.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final bool showMenuButton;
  final bool showLeftArrowButton;

  const CustomAppBar({
    super.key,
    this.title = '',
    this.showBackButton = false,
    this.showMenuButton = true,
    this.showLeftArrowButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = UIThemes.of(context);
    return AppBar(
      backgroundColor: theme.bgColor,
      elevation: 0,
      centerTitle: false,
      leading: showLeftArrowButton
          ? Padding(
              padding: const EdgeInsets.only(
                left: GeneralConsts.horizontalPadding,
              ),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go(AppRouter.home);
                  }
                },
                child: Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    CustomIcons.back,
                    width: 20,
                    colorFilter: ColorFilter.mode(
                      theme.textColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            )
          : null,
      title: Text(
        title,
        style: theme.basicTextStyle.copyWith(color: theme.secondaryTextColor),
      ),
      titleSpacing: 16,
      automaticallyImplyLeading: false,
      actions: [
        if (showBackButton)
          Padding(
            padding: const EdgeInsets.only(
              right: GeneralConsts.horizontalPadding,
            ),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go(AppRouter.home);
                }
              },
              child: Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  CustomIcons.close,
                  width: 20,
                  colorFilter: ColorFilter.mode(theme.textColor, BlendMode.srcIn),
                ),
              ),
            ),
          )
        else if (showMenuButton)
          Padding(
            padding: const EdgeInsets.only(
              right: GeneralConsts.horizontalPadding,
            ),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => context.push(AppRouter.sideMenu),
              child: Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  CustomIcons.burgerMenu,
                  width: 20,
                  colorFilter: ColorFilter.mode(theme.textColor, BlendMode.srcIn),
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}