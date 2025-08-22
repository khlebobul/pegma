import 'package:flutter/material.dart';
import 'package:pegma/core/themes/app_theme.dart';
import 'package:pegma/core/constants/app_constants.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/common/app_bar_widget.dart';
import '../../widgets/common/info_paragraph.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _shareApp() async {
    await Share.share(AboutConstants.shareText);
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
        title: AboutConstants.appName,
        showBackButton: true,
        showMenuButton: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoParagraph(
              text: AboutConstants.appNameDescription,
              padding: const EdgeInsets.only(bottom: 24),
            ),

            _buildActionTile(context, 'rate the app', _rateApp),
            _buildActionTile(context, 'share with friends', _shareApp),
            _buildActionTile(
              context,
              'project website',
              () => _launchUrl(AboutConstants.projectWebsite),
            ),
            _buildActionTile(
              context,
              'telegram',
              () => _launchUrl(AboutConstants.telegramUrl),
            ),

            const SizedBox(height: 24),

            InfoParagraph(
              text: AboutConstants.fontFactText,
              padding: const EdgeInsets.only(bottom: 24),
            ),

            _buildActionTile(
              context,
              'github repository',
              () => _launchUrl(AboutConstants.githubRepository),
            ),
            _buildActionTile(
              context,
              'follow me on x (twitter)',
              () => _launchUrl(AboutConstants.twitterUrl),
            ),
            _buildActionTile(
              context,
              'check my website',
              () => _launchUrl(AboutConstants.personalWebsite),
            ),
            _buildActionTile(
              context,
              'my other apps',
              () => _launchUrl(AboutConstants.otherAppsUrl),
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context,
    String title,
    VoidCallback onTap,
  ) {
    final theme = UIThemes.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Text(title, style: theme.basicTextStyle),
      ),
    );
  }
}
