import 'package:flutter/material.dart';
import 'package:pegma/core/themes/app_theme.dart';
import 'package:pegma/presentation/widgets/game/game_board.dart';
import '../../widgets/common/app_bar_widget.dart';
import '../../widgets/game/undo_bottom_bar.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = UIThemes.of(context);
    return Scaffold(
      backgroundColor: theme.bgColor,
      appBar: CustomAppBar(
        showLeftArrowButton: true,
        showBackButton: false,
        showMenuButton: true,
      ),
      body: Column(
        children: [
          Expanded(child: Center(child: GameBoard())),
          UndoBottomBar(
            onUndoPressed: () {
              // TODO: Implement undo functionality
            },
            onRedoPressed: () {
              // TODO: Implement redo functionality
            },
            canUndo: true,
            canRedo: true,
          ),
        ],
      ),
    );
  }
}
