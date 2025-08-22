import 'package:flutter/material.dart';
import 'package:pegma/core/constants/app_constants.dart';
import 'package:pegma/core/themes/app_theme.dart';
import '../../widgets/common/app_bar_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = UIThemes.of(context);
    return Scaffold(
      backgroundColor: theme.bgColor,
      appBar: CustomAppBar(
        title: AboutConstants.appName,
        showBackButton: true,
        showMenuButton: false,
      ),
      body: Center(child: Text('settings screen')),
    );
  }
}
