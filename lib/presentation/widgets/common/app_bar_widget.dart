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
  final bool isGameScreen;
  final String? timer;
  final String? moves;

  const CustomAppBar({
    super.key,
    this.title = '',
    this.showBackButton = false,
    this.showMenuButton = true,
    this.showLeftArrowButton = false,
    this.isGameScreen = false,
    this.timer,
    this.moves,
  });

  @override
  Widget build(BuildContext context) {
    final theme = UIThemes.of(context);

    if (isGameScreen) {
      return AppBar(
        backgroundColor: theme.bgColor,
        elevation: 0,
        centerTitle: true,
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
                      width: 30,
                      colorFilter: ColorFilter.mode(
                        theme.textColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              )
            : null,
        title: timer != null
            ? Text(
                timer!,
                style: theme.basicTextStyle.copyWith(
                  color: theme.secondaryTextColor,
                ),
              )
            : null,
        titleSpacing: 16,
        automaticallyImplyLeading: false,
        actions: [
          if (moves != null)
            Padding(
              padding: const EdgeInsets.only(
                right: GeneralConsts.horizontalPadding,
              ),
              child: Center(
                child: Text(
                  moves!,
                  style: theme.basicTextStyle.copyWith(
                    color: theme.secondaryTextColor,
                  ),
                ),
              ),
            ),
        ],
      );
    }

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
                    width: 15,
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
          _buildActionButton(
            context: context,
            theme: theme,
            asset: CustomIcons.close,
            onTap: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(AppRouter.home);
              }
            },
          )
        else if (showMenuButton)
          _buildActionButton(
            context: context,
            theme: theme,
            asset: CustomIcons.burgerMenu,
            onTap: () => context.push(AppRouter.sideMenu),
          ),
      ],
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required UIThemes theme,
    required String asset,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: GeneralConsts.horizontalPadding),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          child: SvgPicture.asset(
            asset,
            width: 20,
            colorFilter: ColorFilter.mode(theme.textColor, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
