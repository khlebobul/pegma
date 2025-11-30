import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pegma/core/constants/app_constants.dart';
import 'package:pegma/core/themes/app_theme.dart';

class PegLoadingIndicator extends StatefulWidget {
  const PegLoadingIndicator({super.key});

  @override
  State<PegLoadingIndicator> createState() => _PegLoadingIndicatorState();
}

class _PegLoadingIndicatorState extends State<PegLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = UIThemes.of(context);

    return SizedBox(
      width: 120,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildPeg(0, theme),
          const SizedBox(width: 20),
          _buildPeg(1, theme),
          const SizedBox(width: 20),
          _buildPeg(2, theme),
        ],
      ),
    );
  }

  Widget _buildPeg(int index, UIThemes theme) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final progress = _animation.value;
        final phase = (progress - index / 3.0) % 1.0;

        double activeProgress = 0.0;
        if (phase < 1.0 / 3.0) {
          activeProgress = phase * 3.0;
        } else {
          activeProgress = 0.0;
        }

        final liftHeight = _calculateLiftHeight(activeProgress);
        final color = activeProgress > 0.0
            ? theme.highlightColor
            : theme.textColor;

        return Transform.translate(
          offset: Offset(0, -liftHeight),
          child: SvgPicture.asset(
            CustomIcons.circleFilled,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
        );
      },
    );
  }

  double _calculateLiftHeight(double progress) {
    if (progress <= 0.0 || progress >= 1.0) return 0.0;
    return 12 * (1 - (progress * 2 - 1).abs());
  }
}
