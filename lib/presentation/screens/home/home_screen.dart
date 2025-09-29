import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pegma/core/constants/app_constants.dart';
import 'package:pegma/core/router/app_router.dart';
import 'package:pegma/core/themes/app_theme.dart';
import 'package:pegma/presentation/providers/levels_provider.dart';
import '../../widgets/common/app_bar_widget.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = UIThemes.of(context);
    final levelsAsyncValue = ref.watch(levelsProvider);
    final levels = levelsAsyncValue.valueOrNull ?? [];

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
        itemCount: levels.length,
        itemBuilder: (context, index) {
          final number = levels[index];
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              context.push('${AppRouter.game}/$number');
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
