import 'package:flutter/material.dart';
import 'package:pegma/core/themes/app_theme.dart';
import 'package:pegma/core/constants/app_constants.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/common/app_bar_widget.dart';
import '../../widgets/common/info_paragraph.dart';
import '../../widgets/common/action_button.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _shareApp() async {
    await Share.share(GeneralConsts.shareText);
  }

  Future<void> _rateApp() async {
    // TODO update
    await _launchUrl(
      'https://play.google.com/store/apps/details?id=com.example.pegma',
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
        padding: const EdgeInsets.all(GeneralConsts.generalPadding),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoParagraph(
              text: GeneralConsts.appNameDescription,
              padding: const EdgeInsets.only(bottom: 24),
            ),

            ActionButton(title: 'rate the app', onTap: _rateApp),
            ActionButton(title: 'share with friends', onTap: _shareApp),
            ActionButton(
              title: 'project website',
              onTap: () => _launchUrl(GeneralConsts.projectWebsite),
            ),
            ActionButton(
              title: 'telegram',
              onTap: () => _launchUrl(GeneralConsts.telegramUrl),
            ),

            const SizedBox(height: 24),

            InfoParagraph(
              text: GeneralConsts.fontFactText,
              padding: const EdgeInsets.only(bottom: 24),
            ),

            ActionButton(
              title: 'github repository',
              onTap: () => _launchUrl(GeneralConsts.githubRepository),
            ),
            ActionButton(
              title: 'follow me on x (twitter)',
              onTap: () => _launchUrl(GeneralConsts.twitterUrl),
            ),
            ActionButton(
              title: 'check my website',
              onTap: () => _launchUrl(GeneralConsts.personalWebsite),
            ),
            ActionButton(
              title: 'my other apps',
              onTap: () => _launchUrl(GeneralConsts.otherAppsUrl),
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
