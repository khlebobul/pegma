import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:pegma/core/themes/app_theme.dart';
import 'package:pegma/core/constants/app_constants.dart';
import 'package:pegma/core/utils/market_helper.dart';
import 'package:pegma/core/utils/useful_methods.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pegma/generated/l10n.dart';
import '../../widgets/common/app_bar_widget.dart';
import '../../widgets/common/info_paragraph.dart';
import '../../widgets/common/action_button.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _shareApp() async {
    await SharePlus.instance.share(
      ShareParams(
        text: S.current.discoverPegmaAFreeOpensourceTakeOnTheClassicPeg,
      ),
    );
  }

  Future<void> _rateApp() async {
    await launchLinkUrl(
      Platform.isIOS
          ? GeneralConsts.rateAppStore
          : GeneralConsts.rateGooglePlay,
    );
  }

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
            InfoParagraph(
              text: S.of(context).appDescription(GeneralConsts.appName),
              padding: const EdgeInsets.only(
                bottom: GeneralConsts.verticalPadding,
              ),
            ),

            const SizedBox(height: 12),
            if (MarketHelper.shouldShowRating())
              ActionButton(title: S.of(context).rateTheApp, onTap: _rateApp),
            ActionButton(
              title: S.of(context).shareWithFriends,
              onTap: _shareApp,
            ),
            ActionButton(
              title: S.of(context).projectWebsite,
              onTap: () => launchLinkUrl(GeneralConsts.projectWebsite),
            ),
            ActionButton(
              title: S.of(context).telegram,
              onTap: () => launchLinkUrl(GeneralConsts.telegramUrl),
            ),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.only(
                bottom: GeneralConsts.verticalPadding,
              ),
              child: RichText(
                text: TextSpan(
                  style: theme.basicTextStyle.copyWith(
                    color: theme.secondaryTextColor,
                  ),
                  children: [
                    TextSpan(text: S.of(context).funFact),
                    TextSpan(
                      text: GeneralConsts.fontstruct,
                      style: theme.basicTextStyle,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => launchLinkUrl(GeneralConsts.fontUrl),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            ActionButton(
              title: S.of(context).githubRepository,
              onTap: () => launchLinkUrl(GeneralConsts.githubRepository),
            ),
            ActionButton(
              title: S.of(context).xTwitter,
              onTap: () => launchLinkUrl(GeneralConsts.twitterUrl),
            ),
            ActionButton(
              title: S.of(context).myWebsite,
              onTap: () => launchLinkUrl(GeneralConsts.personalWebsite),
            ),
            ActionButton(
              title: S.of(context).myOtherApps,
              onTap: () => launchLinkUrl(
                Platform.isIOS
                    ? GeneralConsts.otherAppsAppStoreLink
                    : GeneralConsts.otherAppsGooglePlayLink,
              ),
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
