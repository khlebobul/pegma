import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pegma/presentation/widgets/tutorial/interactive_tutorial_dialog.dart';

final firstLaunchProvider = Provider((ref) => FirstLaunchProvider());

class FirstLaunchProvider {
  static const String _isFirstLaunchKey = 'isFirstLaunch';

  Future<void> showTutorialDialogIfNeeded(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool(_isFirstLaunchKey) ?? true;

    if (isFirstLaunch) {
      if (context.mounted) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => InteractiveTutorialDialog(
            onClose: () {
              Navigator.of(context).pop();
            },
          ),
        );
        await prefs.setBool(_isFirstLaunchKey, false);
      }
    }
  }

  Future<void> showTutorialDialog(BuildContext context) async {
    if (context.mounted) {
      await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => InteractiveTutorialDialog(
          onClose: () {
            Navigator.of(context).pop();
          },
        ),
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isFirstLaunchKey, false);
    }
  }
}
