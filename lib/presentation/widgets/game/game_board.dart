import 'package:flutter/material.dart';
import 'package:pegma/core/themes/app_theme.dart';

class GameBoard extends StatelessWidget {
  const GameBoard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = UIThemes.of(context);
    return Text('game screen', style: theme.menuTextStyle);
  }
}
