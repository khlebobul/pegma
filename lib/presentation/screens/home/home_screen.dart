import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pegma/core/constants/app_constants.dart';
import 'package:pegma/core/router/app_router.dart';
import 'package:pegma/core/themes/app_theme.dart';
import 'package:pegma/presentation/providers/levels_provider.dart';
import 'package:pegma/presentation/providers/completed_levels_provider.dart';
import '../../widgets/common/app_bar_widget.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = UIThemes.of(context);
    final levelsAsyncValue = ref.watch(levelsProvider);
    final levels = levelsAsyncValue.valueOrNull ?? [];
    final completedLevels =
        ref.watch(completedLevelsProvider).valueOrNull ?? [];

    return Scaffold(
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
            padding: const EdgeInsets.symmetric(
              horizontal: GeneralConsts.horizontalPadding,
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
              final isUnlocked =
                  index == 0 ||
                  index == 1 ||
                  isCompleted ||
                  (index > 1 && completedLevels.contains(levels[index - 1]));

              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: isUnlocked
                    ? () {
                        context.push('${AppRouter.game}/$assetLevelId');
                      }
                    : null,

                // For creating new lelvels
                // () {
                //   context.push('${AppRouter.game}/$assetLevelId');
                // },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Center(
                      child: Text(
                        '$displayNumber',
                        style: theme.menuTextStyle.copyWith(
                          color: isUnlocked
                              ? theme.textColor
                              : theme.secondaryTextColor,
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
  }
}
