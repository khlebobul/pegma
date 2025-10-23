import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pegma/core/constants/app_constants.dart';
import 'package:pegma/core/themes/app_theme.dart';
import 'package:pegma/generated/l10n.dart';
import '../../../core/router/app_router.dart';
import '../../providers/first_launch_provider.dart';
import '../../widgets/common/app_bar_widget.dart';

class SideMenuScreen extends ConsumerWidget {
  const SideMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = UIThemes.of(context);
    return Scaffold(
      backgroundColor: theme.bgColor,
      appBar: const CustomAppBar(
        title: GeneralConsts.appName,
        showBackButton: true,
        showMenuButton: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
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
                      ref.read(firstLaunchProvider).showTutorialDialog(context);
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
