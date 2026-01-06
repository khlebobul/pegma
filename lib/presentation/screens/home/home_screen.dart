import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pegma/core/constants/app_constants.dart';
import 'package:pegma/core/router/app_router.dart';
import 'package:pegma/core/themes/app_theme.dart';
import 'package:pegma/presentation/providers/levels_provider.dart';
import 'package:pegma/presentation/providers/completed_levels_provider.dart';
import 'package:upgrader/upgrader.dart';
import '../../widgets/common/app_bar_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isNavigating = false;

  @override
  Widget build(BuildContext context) {
    final theme = UIThemes.of(context);
    final levelsAsyncValue = ref.watch(levelsProvider);
    final levels = levelsAsyncValue.value ?? [];
    final completedLevels = ref.watch(completedLevelsProvider).value ?? [];

    Widget content = Scaffold(
      backgroundColor: theme.bgColor,
      appBar: CustomAppBar(
        title: GeneralConsts.appName,
        showBackButton: false,
        showMenuButton: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(
              GeneralConsts.horizontalPadding,
              0,
              GeneralConsts.horizontalPadding,
              50,
            ),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 120,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              childAspectRatio: 1.0,
            ),
            itemCount: levels.length,
            itemBuilder: (context, index) {
              final assetLevelId = levels[index];
              final displayNumber = index;
              final isCompleted = completedLevels.contains(assetLevelId);

              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  if (_isNavigating) return;
                  setState(() => _isNavigating = true);
                  await context.push('${AppRouter.game}/$assetLevelId');
                  if (mounted) {
                    setState(() => _isNavigating = false);
                  }
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Center(
                      child: Text(
                        '$displayNumber',
                        style: theme.menuTextStyle.copyWith(
                          color: theme.textColor,
                        ),
                      ),
                    ),
                    if (isCompleted)
                      Positioned(
                        top: 6,
                        child: SvgPicture.asset(
                          CustomIcons.star,
                          height: 15,
                          colorFilter: ColorFilter.mode(
                            theme.textColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );

    final upgradeAlert = UpgradeAlert(
      showReleaseNotes: false,
      dialogStyle: Platform.isIOS
          ? UpgradeDialogStyle.cupertino
          : UpgradeDialogStyle.material,
      cupertinoButtonTextStyle: const TextStyle(
        color: CupertinoColors.activeBlue,
        fontSize: 17,
      ),
      upgrader: Upgrader(
        debugLogging: true,
        debugDisplayAlways: true,
      ),
      child: content,
    );

    if (!Platform.isIOS) {
      return Theme(
        data: Theme.of(context).brightness == Brightness.dark
            ? ThemeData.dark(useMaterial3: true)
            : ThemeData.light(useMaterial3: true),
        child: upgradeAlert,
      );
    }

    return upgradeAlert;
  }
}
