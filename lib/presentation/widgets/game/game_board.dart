import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pegma/core/constants/app_constants.dart';
import 'package:pegma/core/themes/app_theme.dart';
import 'package:pegma/presentation/providers/game_provider.dart';

class GameBoard extends ConsumerWidget {
  const GameBoard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);
    final gameNotifier = ref.read(gameProvider.notifier);
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
                  return Expanded(
                    child: Center(
                      child: _buildPeg(
                        cellValue: cellValue,
                        onTap: () => gameNotifier.onPegTap(row, col),
                        theme: theme,
                        row: row,
                        col: col,
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
  }) {
    // Generate random rotation based on position for consistency
    final random = math.Random(row * 7 + col * 11);
    final rotation = random.nextDouble() * 2 * math.pi;
    switch (cellValue) {
      case '-1': // Invalid position (не отображается)
        return const SizedBox.shrink();
      case '0': // Empty slot (пустая ячейка)
        return GestureDetector(
          onTap: onTap,

          child: const SizedBox(width: 40, height: 40),
        );
      case '1': // Normal peg (существующий шарик)
        return GestureDetector(
          onTap: onTap,
          child: SizedBox(
            width: 40,
            height: 40,
            child: Transform.rotate(
              angle: rotation,
              child: SvgPicture.asset(
                CustomIcons.circle,
                colorFilter: ColorFilter.mode(theme.textColor, BlendMode.srcIn),
              ),
            ),
          ),
        );
      case '*': // Selected peg (выбранный шарик)
        return GestureDetector(
          onTap: onTap,
          child: SizedBox(
            width: 40,
            height: 40,
            child: Transform.rotate(
              angle: rotation,
              child: SvgPicture.asset(
                CustomIcons.circle,
                colorFilter: ColorFilter.mode(
                  theme.highlightColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        );
      case 'eaten': // Eaten peg (съеденный шарик)
        return GestureDetector(
          onTap: onTap,
          child: SizedBox(
            width: 40,
            height: 40,
            child: Transform.rotate(
              angle: rotation,
              child: SvgPicture.asset(
                CustomIcons.circle,
                colorFilter: ColorFilter.mode(
                  theme.secondaryTextColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
