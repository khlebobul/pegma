import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pegma/core/constants/app_constants.dart';
import 'package:pegma/core/themes/app_theme.dart';
import 'package:pegma/core/utils/useful_methods.dart';
import '../../widgets/common/app_bar_widget.dart';
import '../../widgets/common/custom_toggle.dart';
import '../../widgets/common/action_button.dart';
import '../../providers/settings/theme_provider.dart';
import '../../providers/settings/language_provider.dart';
import '../../providers/settings/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = UIThemes.of(context);
    final themeNotifier = ref.watch(themeNotifierProvider.notifier);
    final themeMode = ref.watch(themeNotifierProvider);

    final currentLocale = ref.watch(languageNotifierProvider);
    final settings = ref.watch(settingsNotifierProvider);
    final settingsNotifier = ref.watch(settingsNotifierProvider.notifier);

    final isDarkTheme = themeMode == ThemeMode.dark;
    final selectedLanguage = currentLocale.languageCode == 'en'
        ? 'english'
        : 'russian';

    return Scaffold(
      backgroundColor: theme.bgColor,
      appBar: CustomAppBar(
        title: GeneralConsts.appName,
        showBackButton: true,
        showMenuButton: false,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: GeneralConsts.generalPadding,
              ),
              child: _buildSectionTitle('language', theme),
            ),
            const SizedBox(height: 16),
            _buildLanguageOptions(theme, ref, selectedLanguage),

            const SizedBox(height: 40),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: GeneralConsts.generalPadding,
              ),
              child: _buildSectionTitle('others', theme),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: GeneralConsts.generalPadding,
              ),
              child: _buildToggleOption('dark theme', isDarkTheme, (value) {
                themeNotifier.toggleTheme();
              }, theme),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: GeneralConsts.generalPadding,
              ),
              child: _buildToggleOption('stopwatch', settings.soundEnabled, (
                value,
              ) {
                settingsNotifier.toggleSound();
              }, theme),
            ),
            const Spacer(),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: GeneralConsts.generalPadding,
              ),

              child: _buildFooterActions(theme, context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, UIThemes theme) {
    return Text(
      title,
      style: theme.menuTextStyle.copyWith(color: theme.secondaryTextColor),
    );
  }

  Widget _buildLanguageOptions(
    UIThemes theme,
    WidgetRef ref,
    String selectedLanguage,
  ) {
    final languages = ['english', 'russian', 'more lang'];

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: GeneralConsts.generalPadding,
        ),
        itemCount: languages.length,
        separatorBuilder: (context, index) => const SizedBox(width: 24),
        itemBuilder: (context, index) {
          return _buildLanguageOption(
            languages[index],
            theme,
            ref,
            selectedLanguage,
          );
        },
      ),
    );
  }

  Widget _buildLanguageOption(
    String language,
    UIThemes theme,
    WidgetRef ref,
    String selectedLanguage,
  ) {
    final isSelected = selectedLanguage == language;

    return GestureDetector(
      onTap: () {
        if (language == 'english') {
          ref.read(languageNotifierProvider.notifier).setEnglish();
        } else if (language == 'russian') {
          ref.read(languageNotifierProvider.notifier).setRussian();
        }
      },
      child: Text(
        language,
        style: theme.basicTextStyle.copyWith(
          color: isSelected ? theme.textColor : theme.secondaryTextColor,
        ),
      ),
    );
  }

  Widget _buildToggleOption(
    String title,
    bool value,
    ValueChanged<bool> onChanged,
    UIThemes theme,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: theme.basicTextStyle),
        CustomToggle(value: value, onChanged: onChanged),
      ],
    );
  }

  Widget _buildFooterActions(UIThemes theme, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ActionButton(
          title: 'report bug',
          onTap: () => sendEmail(context, GeneralConsts.email, 'report bug'),
          padding: const EdgeInsets.only(bottom: 16),
        ),
        ActionButton(
          title: 'request feature',
          onTap: () =>
              sendEmail(context, GeneralConsts.email, 'request feature'),
          padding: const EdgeInsets.only(bottom: 16),
        ),
        ActionButton(
          title: 'share feedback',
          onTap: () =>
              sendEmail(context, GeneralConsts.email, 'share feedback'),
        ),
      ],
    );
  }
}
