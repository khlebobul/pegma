import 'package:flutter/material.dart';
import 'package:pegma/core/themes/app_theme.dart';
import '../../widgets/common/app_bar_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = UIThemes.of(context);
    return Scaffold(
      backgroundColor: theme.bgColor,
      appBar: CustomAppBar(
        title: 'pegma',
        showBackButton: false,
        showMenuButton: true,
      ),
      body: Center(child: Text('home screen')),
    );
  }
}
