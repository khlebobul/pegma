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
              return _TutorialCell(
                key: ValueKey('$row-$col-${boardState[row][col]}'),
                cellState: boardState[row][col],
                size: cellSize,
                row: row,
                col: col,
                theme: theme,
              );
            }),
          );
        }),
      ),
    );
  }
}

class _TutorialCell extends StatefulWidget {
  final String cellState;
  final double size;
  final int row;
  final int col;
  final UIThemes theme;

  const _TutorialCell({
    super.key,
    required this.cellState,
    required this.size,
    required this.row,
    required this.col,
    required this.theme,
  });

  @override
  State<_TutorialCell> createState() => _TutorialCellState();
}

class _TutorialCellState extends State<_TutorialCell>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (_shouldPulse()) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(_TutorialCell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cellState != widget.cellState) {
      if (_shouldPulse()) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.stop();
        _pulseController.value = 0;
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  bool _shouldPulse() {
    return widget.cellState == '*' || widget.cellState == 'possible';
  }

  @override
  Widget build(BuildContext context) {
    final random = math.Random(widget.row * 7 + widget.col * 11);
    final rotation = random.nextDouble() * 2 * math.pi;

    String? icon;
    Color? color;
    double opacity = 1.0;

    switch (widget.cellState) {
      case '-1': // No cell
        return SizedBox(width: widget.size, height: widget.size);
      case '0': // Empty hole
        icon = CustomIcons.circle;
        color = widget.theme.secondaryTextColor;
        break;
      case '1': // Normal peg
        icon = CustomIcons.circleFilled;
        color = widget.theme.textColor;
        break;
      case '*': // Selected peg
        icon = CustomIcons.circleFilled;
        color = widget.theme.highlightColor;
        break;
      case 'possible': // Possible move (highlighted empty hole)
        icon = CustomIcons.circle;
        color = widget.theme.highlightColor;
        break;
      case 'eaten': // Removed peg
        icon = CustomIcons.circle;
        color = widget.theme.secondaryTextColor;
        break;
      default:
        return SizedBox(width: widget.size, height: widget.size);
    }

    Widget cell = SvgPicture.asset(
      icon,
      width: widget.size * 0.8,
      height: widget.size * 0.8,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );

    // Add pulse animation for selected and possible move cells
    if (_shouldPulse()) {
      cell = AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _pulseAnimation.value, child: child);
        },
        child: cell,
      );
    }

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Center(
        child: Transform.rotate(
          angle: rotation,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: opacity,
            child: cell,
          ),
        ),
      ),
    );
  }
}
