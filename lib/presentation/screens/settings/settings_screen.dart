import 'package:flutter/material.dart';
import '../../widgets/common/app_bar_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'pegma',
        showBackButton: true,
        showMenuButton: false,
      ),
      body: Center(
        child: Text(
          'settings screen',
          style: TextStyle(fontSize: 18, color: Colors.black87),
        ),
      ),
    );
  }
}
