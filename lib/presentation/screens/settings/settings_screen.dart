import 'package:flutter/material.dart';
import 'package:pegma/core/constants/app_constants.dart';
import 'package:pegma/core/themes/app_theme.dart';
import 'package:pegma/core/utils/useful_methods.dart';
import '../../widgets/common/app_bar_widget.dart';
import '../../widgets/common/custom_toggle.dart';
import '../../widgets/common/action_button.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkTheme = false;
  bool isStopwatchEnabled = true;
  String selectedLanguage = 'english';

  @override
  Widget build(BuildContext context) {
    final theme = UIThemes.of(context);

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
            _buildLanguageOptions(theme),

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
                setState(() {
                  isDarkTheme = value;
                });
              }, theme),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: GeneralConsts.generalPadding,
              ),
              child: _buildToggleOption('stopwatch', isStopwatchEnabled, (
                value,
              ) {
                setState(() {
                  isStopwatchEnabled = value;
                });
              }, theme),
            ),
            const Spacer(),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: GeneralConsts.generalPadding,
              ),

              child: _buildFooterActions(theme),
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

  Widget _buildLanguageOptions(UIThemes theme) {
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
          return _buildLanguageOption(languages[index], theme);
        },
      ),
    );
  }

  Widget _buildLanguageOption(String language, UIThemes theme) {
    final isSelected = selectedLanguage == language;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedLanguage = language;
        });
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

  Widget _buildFooterActions(UIThemes theme) {
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
