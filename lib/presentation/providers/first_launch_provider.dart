import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pegma/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pegma/presentation/widgets/common/dialog_window.dart';
import 'package:pegma/core/constants/app_constants.dart';

final firstLaunchProvider = Provider((ref) => FirstLaunchProvider());

class FirstLaunchProvider {
  static const String _isFirstLaunchKey = 'isFirstLaunch';

  Future<void> showRulesDialogIfNeeded(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool(_isFirstLaunchKey) ?? true;

    if (isFirstLaunch) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => DialogWindow.closeButtonWithImage(
            imagePath: Images.rulesScheme,
            description: S.of(context).gameTutorialText,
            onClosePressed: () {
              Navigator.of(context).pop();
            },
          ),
        );
        await prefs.setBool(_isFirstLaunchKey, false);
      }
    }
  }
}
