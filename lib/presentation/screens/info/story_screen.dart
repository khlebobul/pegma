import 'package:flutter/material.dart';
import 'package:pegma/core/constants/app_constants.dart';
import 'package:pegma/core/themes/app_theme.dart';
import 'package:pegma/generated/l10n.dart';
import '../../widgets/common/app_bar_widget.dart';
import '../../widgets/common/info_paragraph.dart';

class StoryScreen extends StatelessWidget {
  const StoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = UIThemes.of(context);

    return Scaffold(
      backgroundColor: theme.bgColor,
      appBar: const CustomAppBar(
        title: GeneralConsts.appName,
        showBackButton: true,
        showMenuButton: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(GeneralConsts.horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:  [
            InfoParagraph(
              text:
                  S.of(context).pegSolitaireOrSolitaireOnPegsOriginatedInEuropeIn,
            ),
            InfoParagraph(
              text:
                  S.of(context).theEarliestDocumentedMentionOfTheGameIsIn1687,
            ),
            InfoParagraph(
              text:
                  S.of(context).theClassicBoardHasACrossShape77Squares33,
            ),
            InfoParagraph(
              text:
                  S.of(context).theGoalIsToRemoveAllPegsLeavingOnlyOne,
            ),
            InfoParagraph(
              text:
                  S.of(context).pegSolitaireIsNotOnlyAGameButAlsoA,
            ),
            InfoParagraph(
              text:
                  S.of(context).inThe19thCenturyTheGameSpreadAcrossEuropeAnd,
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
