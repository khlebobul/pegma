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
          _AnimatedButton(
            onTap: canGoBack ? onPrevious : null,
            child: SvgPicture.asset(
              CustomIcons.back,
              width: 28,
              colorFilter: ColorFilter.mode(
                canGoBack ? theme.textColor : theme.secondaryTextColor,
                BlendMode.srcIn,
              ),
            ),
          ),
          _AnimatedButton(
            onTap: onNext,
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
        ],
      ),
    );
  }
}

class _AnimatedButton extends StatefulWidget {
  final VoidCallback? onTap;
  final Widget child;

  const _AnimatedButton({required this.onTap, required this.child});

  @override
  State<_AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<_AnimatedButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: widget.onTap != null
          ? (_) => setState(() => _isPressed = true)
          : null,
      onTapUp: widget.onTap != null
          ? (_) => setState(() => _isPressed = false)
          : null,
      onTapCancel: widget.onTap != null
          ? () => setState(() => _isPressed = false)
          : null,
      onTap: widget.onTap,
      child: SizedBox(
        height: 50,
        child: Center(
          child: AnimatedScale(
            duration: const Duration(milliseconds: 100),
            scale: _isPressed ? 0.9 : 1.0,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
