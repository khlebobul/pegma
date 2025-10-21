import 'package:flutter/material.dart';
import 'package:pegma/core/themes/app_theme.dart';
import 'package:pegma/core/constants/app_constants.dart';
import 'package:pegma/generated/l10n.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:math' as math;

class InteractiveTutorialDialog extends StatefulWidget {
  final VoidCallback onClose;

  const InteractiveTutorialDialog({super.key, required this.onClose});

  @override
  State<InteractiveTutorialDialog> createState() =>
      _InteractiveTutorialDialogState();
}

class _InteractiveTutorialDialogState extends State<InteractiveTutorialDialog>
    with SingleTickerProviderStateMixin {
  int _currentStep = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Tutorial board states for each step
  final List<List<List<String>>> _boardStates = [
    // Step 0: Initial board
    [
      ['-1', '1', '-1'],
      ['1', '0', '1'],
      ['-1', '1', '-1'],
    ],
    // Step 1: Select a peg
    [
      ['-1', '1', '-1'],
      ['*', '0', '1'],
      ['-1', '1', '-1'],
    ],
    // Step 2: Show possible move
    [
      ['-1', '1', '-1'],
      ['*', '0', 'possible'],
      ['-1', '1', '-1'],
    ],
    // Step 3: Move the peg (mid-animation)
    [
      ['-1', '1', '-1'],
      ['eaten', 'eaten', '1'],
      ['-1', '1', '-1'],
    ],
    // Step 4: Final state after move
    [
      ['-1', '1', '-1'],
      ['eaten', 'eaten', '1'],
      ['-1', '1', '-1'],
    ],
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _boardStates.length - 1) {
      setState(() {
        _currentStep++;
        _animationController.reset();
        _animationController.forward();
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
        _animationController.reset();
        _animationController.forward();
      });
    }
  }

  String _getStepDescription(BuildContext context) {
    final s = S.of(context);
    switch (_currentStep) {
      case 0:
        return s.tutorialStep1;
      case 1:
        return s.tutorialStep2;
      case 2:
        return s.tutorialStep3;
      case 3:
        return s.tutorialStep4;
      case 4:
        return s.tutorialStep5;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = UIThemes.of(context);
    final screenSize = MediaQuery.of(context).size;
    final dialogWidth =
        screenSize.width - (GeneralConsts.horizontalPadding * 2);
    final dialogHeight = screenSize.height * 0.65;

    return Dialog(
      backgroundColor: theme.bgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      insetPadding: const EdgeInsets.all(GeneralConsts.horizontalPadding),
      child: SizedBox(
        width: dialogWidth,
        height: dialogHeight,
        child: Padding(
          padding: const EdgeInsets.all(GeneralConsts.horizontalPadding),
          child: Column(
            children: [
              // Title centered
              Center(
                child: Text(
                  S.of(context).howToPlay,
                  style: theme.basicTextStyle.copyWith(
                    color: theme.textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Tutorial board and description
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Tutorial board
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: _buildTutorialBoard(theme),
                    ),
                    const SizedBox(height: 24),

                    // Step description
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Text(
                        _getStepDescription(context),
                        style: theme.basicTextStyle.copyWith(
                          color: theme.secondaryTextColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Step indicator
              _buildStepIndicator(theme),
              const SizedBox(height: 24),

              // Navigation arrows
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Previous arrow
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _currentStep > 0 ? _previousStep : null,
                      child: SizedBox(
                        height: 50,
                        child: Center(
                          child: SvgPicture.asset(
                            CustomIcons.back,
                            width: 28,
                            colorFilter: ColorFilter.mode(
                              _currentStep > 0
                                  ? theme.textColor
                                  : theme.secondaryTextColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Next/Done arrow or Play text
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _currentStep < _boardStates.length - 1
                          ? _nextStep
                          : widget.onClose,
                      child: SizedBox(
                        height: 50,
                        child: Center(
                          child: _currentStep < _boardStates.length - 1
                              ? Transform.scale(
                                  scaleX: -1,
                                  child: SvgPicture.asset(
                                    CustomIcons.back,
                                    width: 28,
                                    colorFilter: ColorFilter.mode(
                                      theme.textColor,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                )
                              : Text(
                                  S.of(context).play,
                                  style: theme.basicTextStyle.copyWith(
                                    color: theme.textColor,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTutorialBoard(UIThemes theme) {
    final board = _boardStates[_currentStep];
    const cellSize = 50.0;

    return SizedBox(
      width: board[0].length * cellSize,
      height: board.length * cellSize,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(board.length, (row) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(board[row].length, (col) {
              return _buildCell(theme, board[row][col], cellSize, row, col);
            }),
          );
        }),
      ),
    );
  }

  Widget _buildCell(
    UIThemes theme,
    String cellState,
    double size,
    int row,
    int col,
  ) {
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

  Widget _buildStepIndicator(UIThemes theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_boardStates.length, (index) {
        final isActive = index == _currentStep;
        final random = math.Random(index * 13);
        final rotation = random.nextDouble() * 2 * math.pi;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: Transform.rotate(
            angle: rotation,
            child: SvgPicture.asset(
              isActive ? CustomIcons.circleFilled : CustomIcons.circle,
              width: 12,
              height: 12,
              colorFilter: ColorFilter.mode(
                isActive ? theme.textColor : theme.secondaryTextColor,
                BlendMode.srcIn,
              ),
            ),
          ),
        );
      }),
    );
  }
}
