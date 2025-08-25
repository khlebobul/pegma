import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pegma/core/constants/app_constants.dart';
import 'package:pegma/core/themes/app_theme.dart';
import 'package:pegma/generated/l10n.dart';
import '../../widgets/common/app_bar_widget.dart';
import '../../widgets/common/info_paragraph.dart';

class RulesScreen extends StatelessWidget {
  const RulesScreen({super.key});

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
          children: [
            InfoParagraph(text: S.of(context).rulesOne),
            InfoParagraph(text: S.of(context).rulesTwo),
            InfoParagraph(text: S.of(context).rulesThree),

            _RulesImage(),
            SizedBox(height: 50),
          ],
        ),
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
