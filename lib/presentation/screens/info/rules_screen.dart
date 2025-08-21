import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pegma/core/constants/app_constants.dart';
import 'package:pegma/core/themes/app_theme.dart';
import '../../widgets/common/app_bar_widget.dart';

class RulesScreen extends StatelessWidget {
  const RulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = UIThemes.of(context);

    return Scaffold(
      backgroundColor: theme.bgColor,
      appBar: const CustomAppBar(
        title: 'pegma',
        showBackButton: true,
        showMenuButton: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            RuleParagraph(
              text:
                  'the board has holes filled with pegs, usually with the center hole empty.',
            ),
            RuleParagraph(
              text:
                  'move: a peg jumps over an adjacent peg (horizontally or vertically) into an empty hole right beyond it. the jumped peg is removed.',
            ),
            RuleParagraph(
              text:
                  'goal: remove as many pegs as possible, ideally leaving only one — in the center.',
            ),

            _RulesImage(),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

class RuleParagraph extends StatelessWidget {
  final String text;

  const RuleParagraph({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = UIThemes.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        text,
        style: theme.basicTextStyle.copyWith(color: theme.secondaryTextColor),
      ),
    );
  }
}

class _RulesImage extends StatelessWidget {
  const _RulesImage();

  @override
  Widget build(BuildContext context) {
    return Center(child: SvgPicture.asset(Images.rulesScheme, height: 200));
  }
}
