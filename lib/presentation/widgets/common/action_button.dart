import 'package:flutter/material.dart';
import 'package:pegma/core/constants/app_constants.dart';
import 'package:pegma/core/themes/app_theme.dart';

class ActionButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;

  const ActionButton({
    super.key,
    required this.title,
    required this.onTap,
    this.padding,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = UIThemes.of(context);

    return Padding(
      padding:
          padding ??
          const EdgeInsets.only(bottom: GeneralConsts.verticalPadding / 4),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Text(title, style: textStyle ?? theme.basicTextStyle),
      ),
    );
  }
}
