import 'package:flutter/material.dart';
import '../../widgets/common/app_bar_widget.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'back',
        showBackButton: false,
        showMenuButton: true,
      ),
      body: Center(
        child: Text(
          'game screen',
          style: TextStyle(fontSize: 18, color: Colors.black87),
        ),
      ),
    );
  }
}
