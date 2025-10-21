import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pegma/core/constants/app_constants.dart';
import 'package:pegma/core/themes/app_theme.dart';
import 'dart:math' as math;

class TutorialStepIndicator extends StatelessWidget {
  final int totalSteps;
  final int currentStep;
  final UIThemes theme;

  const TutorialStepIndicator({
    super.key,
    required this.totalSteps,
    required this.currentStep,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        final isActive = index == currentStep;
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
