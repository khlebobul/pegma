import 'package:flutter/material.dart';
import 'package:pegma/core/themes/app_theme.dart';
import 'package:pegma/core/constants/app_constants.dart';
import 'package:pegma/generated/l10n.dart';
import 'package:pegma/presentation/widgets/tutorial/tutorial_board.dart';
import 'package:pegma/presentation/widgets/tutorial/tutorial_board_states.dart';
import 'package:pegma/presentation/widgets/tutorial/tutorial_navigation.dart';
import 'package:pegma/presentation/widgets/tutorial/tutorial_step_indicator.dart';

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
    if (_currentStep < TutorialBoardStates.states.length - 1) {
      setState(() {
        _currentStep++;
        _animationController.reset();
        _animationController.forward();
      });
    } else {
      widget.onClose();
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

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: TutorialBoard(
                        boardState: TutorialBoardStates.states[_currentStep],
                        theme: theme,
                      ),
                    ),
                    const SizedBox(height: 24),

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

              TutorialStepIndicator(
                totalSteps: TutorialBoardStates.states.length,
                currentStep: _currentStep,
                theme: theme,
              ),
              const SizedBox(height: 24),

              TutorialNavigation(
                currentStep: _currentStep,
                totalSteps: TutorialBoardStates.states.length,
                onPrevious: _previousStep,
                onNext: _nextStep,
                theme: theme,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
