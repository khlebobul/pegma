import 'package:flutter/material.dart';
import 'package:pegma/core/themes/app_theme.dart';

class InfoParagraph extends StatelessWidget {
  final String text;
  final EdgeInsets? padding;
  final TextStyle? textStyle;

  const InfoParagraph({
    super.key,
    required this.text,
    this.padding,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = UIThemes.of(context);

    return Padding(
      padding: padding ?? const EdgeInsets.only(bottom: 16),
      child: Text(
        text,
        style:
            textStyle ??
            theme.basicTextStyle.copyWith(color: theme.secondaryTextColor),
      ),
    );
  }
}
