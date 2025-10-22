import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pegma/core/constants/app_constants.dart';
import 'package:pegma/core/themes/app_theme.dart';
import 'dart:math' as math;

class TutorialBoard extends StatelessWidget {
  final List<List<String>> boardState;
  final UIThemes theme;

  const TutorialBoard({
    super.key,
    required this.boardState,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    const cellSize = 50.0;

    return SizedBox(
      width: boardState[0].length * cellSize,
      height: boardState.length * cellSize,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(boardState.length, (row) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(boardState[row].length, (col) {
              return _buildCell(boardState[row][col], cellSize, row, col);
            }),
          );
        }),
      ),
    );
  }

  Widget _buildCell(String cellState, double size, int row, int col) {
    final random = math.Random(row * 7 + col * 11);
    final rotation = random.nextDouble() * 2 * math.pi;

    String? icon;
    Color? color;
    bool isPossibleMove = cellState == 'possible';

    switch (cellState) {
      case '-1': // No cell
        return SizedBox(width: size, height: size);
      case '0': // Empty hole
        icon = CustomIcons.circle;
        color = theme.secondaryTextColor;
        break;
      case '1': // Normal peg
        icon = CustomIcons.circleFilled;
        color = theme.textColor;
        break;
      case '*': // Selected peg
        icon = CustomIcons.circleFilled;
        color = theme.highlightColor;
        break;
      case 'possible': // Possible move (highlighted empty hole)
        icon = CustomIcons.circle;
        color = theme.highlightColor;
        break;
      case 'eaten': // Removed peg
        icon = CustomIcons.circle;
        color = theme.secondaryTextColor;
        break;
      default:
        return SizedBox(width: size, height: size);
    }

    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: Transform.rotate(
          angle: rotation,
          child: AnimatedScale(
            duration: const Duration(milliseconds: 150),
            scale: isPossibleMove ? 1.1 : 1.0,
            child: SvgPicture.asset(
              icon,
              width: size * 0.8,
              height: size * 0.8,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
          ),
        ),
      ),
    );
  }
}
