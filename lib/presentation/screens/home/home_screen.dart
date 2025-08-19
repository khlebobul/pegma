import 'package:flutter/material.dart';
import '../../widgets/common/app_bar_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'pegma',
        showBackButton: false,
        showMenuButton: true,
      ),
      body: Center(
        child: Text(
          'home screen',
          style: TextStyle(fontSize: 18, color: Colors.black87),
        ),
      ),
    );
  }
}
