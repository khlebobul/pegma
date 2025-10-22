import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pegma/core/constants/app_constants.dart';
import 'package:pegma/core/themes/app_theme.dart';
import 'package:pegma/generated/l10n.dart';

class TutorialNavigation extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final UIThemes theme;

  const TutorialNavigation({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.onPrevious,
    required this.onNext,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final isLastStep = currentStep >= totalSteps - 1;
    final canGoBack = currentStep > 0;

    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: canGoBack ? onPrevious : null,
            child: SizedBox(
              height: 50,
              child: Center(
                child: SvgPicture.asset(
                  CustomIcons.back,
                  width: 28,
                  colorFilter: ColorFilter.mode(
                    canGoBack ? theme.textColor : theme.secondaryTextColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onNext,
            child: SizedBox(
              height: 50,
              child: Center(
                child: isLastStep
                    ? Text(
                        S.of(context).play,
                        style: theme.basicTextStyle.copyWith(
                          color: theme.textColor,
                        ),
                      )
                    : Transform.scale(
                        scaleX: -1,
                        child: SvgPicture.asset(
                          CustomIcons.back,
                          width: 28,
                          colorFilter: ColorFilter.mode(
                            theme.textColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
