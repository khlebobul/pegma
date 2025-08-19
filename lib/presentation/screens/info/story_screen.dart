import 'package:flutter/material.dart';
import '../../widgets/common/app_bar_widget.dart';

class StoryScreen extends StatelessWidget {
  const StoryScreen({super.key});

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
          'story screen',
          style: TextStyle(fontSize: 18, color: Colors.black87),
        ),
      ),
    );
  }
}
