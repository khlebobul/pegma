import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pegma/core/constants/app_constants.dart';
import 'package:pegma/core/themes/app_theme.dart';
import 'package:pegma/presentation/providers/game_provider.dart';
import '../../../presentation/providers/game/timer_provider.dart';

class GameBoard extends ConsumerWidget {
  const GameBoard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);
    final gameNotifier = ref.read(gameProvider.notifier);
    final timerNotifier = ref.read(timerNotifierProvider.notifier);
    final theme = UIThemes.of(context);

    if (gameState.board.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(gameState.board.length, (row) {
            return Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(gameState.board[row].length, (col) {
                  final cellValue = gameState.board[row][col];
                  final isPossibleMove = gameState.possibleMoves.any(
                    (move) => move.x == row && move.y == col,
                  );
                  return Expanded(
                    child: Center(
                      child: _buildPeg(
                        cellValue: cellValue,
                        onTap: () {
                          timerNotifier.startTimer();
                          gameNotifier.onPegTap(row, col);
                        },
                        theme: theme,
                        row: row,
                        col: col,
                        isPossibleMove: isPossibleMove,
                      ),
                    ),
                  );
                }),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildPeg({
    required String cellValue,
    required VoidCallback onTap,
    required UIThemes theme,
    required int row,
    required int col,
    required bool isPossibleMove,
  }) {
    final random = math.Random(row * 7 + col * 11);
    final rotation = random.nextDouble() * 2 * math.pi;

    String? icon;
    Color? color;

    switch (cellValue) {
      case '-1':
        return const SizedBox.shrink();
      case '0':
        icon = CustomIcons.circle;
        color = isPossibleMove
            ? theme.highlightColor
            : theme.secondaryTextColor;
        break;
      case '1':
        icon = CustomIcons.circleFilled;
        color = theme.textColor;
        break;
      case '*':
        icon = CustomIcons.circleFilled;
        color = theme.highlightColor;
        break;
      case 'eaten':
        icon = CustomIcons.circle;
        color = isPossibleMove
            ? theme.highlightColor
            : theme.secondaryTextColor;
        break;
      default:
        return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 40,
        height: 40,
        child: Transform.rotate(
          angle: rotation,
          child: SvgPicture.asset(
            icon,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}
