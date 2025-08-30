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
        showMenuButton: false,
      ),
      body: Column(
        children: [
          // TODO: Timer and Ball Counter Row
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 16.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '0:20',
                  style: theme.basicTextStyle.copyWith(
                    color: theme.secondaryTextColor,
                  ),
                ),
                Text(
                  '10/33',
                  style: theme.basicTextStyle.copyWith(
                    color: theme.secondaryTextColor,
                  ),
                ),
              ],
            ),
          ),
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
