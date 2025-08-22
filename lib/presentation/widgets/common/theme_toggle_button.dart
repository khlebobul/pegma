import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pegma/core/constants/app_constants.dart';
import 'package:pegma/core/themes/app_theme.dart';
import '../../providers/settings/theme_provider.dart';

class ThemeToggleButton extends ConsumerWidget {
  final bool showLabel;
  final double iconSize;

  const ThemeToggleButton({
    super.key,
    this.showLabel = false,
    this.iconSize = 24.0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = UIThemes.of(context);
    final themeMode = ref.watch(themeNotifierProvider);
    final themeNotifier = ref.watch(themeNotifierProvider.notifier);

    final isDarkMode = themeMode == ThemeMode.dark;

    return GestureDetector(
      onTap: () => themeNotifier.toggleTheme(),
      child: showLabel
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  color: theme.textColor,
                  size: iconSize,
                ),
                const SizedBox(width: 8),
                Text(
                  isDarkMode ? 'Light Mode' : 'Dark Mode',
                  style: theme.basicTextStyle.copyWith(fontSize: 16),
                ),
              ],
            )
          : Container(
              width: iconSize + 16,
              height: iconSize + 16,
              decoration: BoxDecoration(
                color: theme.highlightColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: theme.textColor,
                size: iconSize,
              ),
            ),
    );
  }
}

class AnimatedThemeToggle extends ConsumerWidget {
  const AnimatedThemeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);
    final themeNotifier = ref.watch(themeNotifierProvider.notifier);
    final isDarkMode = themeMode == ThemeMode.dark;

    return GestureDetector(
      onTap: () => themeNotifier.toggleTheme(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 68,
        height: 35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              left: isDarkMode ? 33 : 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: isDarkMode ? Colors.blue[400] : Colors.orange[400],
                ),
                child: Icon(
                  isDarkMode ? Icons.nightlight_round : Icons.wb_sunny,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FloatingThemeToggle extends ConsumerWidget {
  const FloatingThemeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = UIThemes.of(context);
    final themeMode = ref.watch(themeNotifierProvider);
    final themeNotifier = ref.watch(themeNotifierProvider.notifier);

    final isDarkMode = themeMode == ThemeMode.dark;

    return FloatingActionButton.small(
      onPressed: () => themeNotifier.toggleTheme(),
      backgroundColor: theme.highlightColor,
      child: Icon(
        isDarkMode ? Icons.light_mode : Icons.dark_mode,
        color: Colors.white,
      ),
    );
  }
}

