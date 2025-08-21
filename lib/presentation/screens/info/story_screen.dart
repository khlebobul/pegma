import 'package:flutter/material.dart';
import 'package:pegma/core/themes/app_theme.dart';
import '../../widgets/common/app_bar_widget.dart';

class StoryScreen extends StatelessWidget {
  const StoryScreen({super.key});

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
            StoryParagraph(
              text:
                  'peg solitaire, or solitaire on pegs, originated in europe in the 17th century and quickly became popular in france.',
            ),
            StoryParagraph(
              text:
                  'the earliest documented mention of the game is in 1687 in a book by french writer bernard lebonn, describing a board with 33 holes.',
            ),
            StoryParagraph(
              text:
                  'the classic board has a cross shape: 7×7 squares, 33 filled with pegs, the center square empty. besides the classic shape, there are circular, triangular, and other non-standard boards with different numbers of pegs.',
            ),
            StoryParagraph(
              text:
                  'the goal is to remove all pegs, leaving only one in the center. interesting fact: for the classic 33-peg board, there is only one perfect solution path, although players often find many intermediate variations.',
            ),
            StoryParagraph(
              text:
                  'peg solitaire is not only a game but also a subject of mathematical study. combinatorialists and logicians have used it to explore strategies, optimal moves, and problem-solving techniques.',
            ),
            StoryParagraph(
              text:
                  'in the 19th century, the game spread across europe and england, becoming a popular pastime in aristocratic circles. modern versions now exist as computer games, mobile apps, and online puzzles.',
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

class StoryParagraph extends StatelessWidget {
  final String text;

  const StoryParagraph({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = UIThemes.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        text,
        style: theme.basicTextStyle.copyWith(
          color: theme.secondaryTextColor,
          height: 1.5,
        ),
      ),
    );
  }
}
