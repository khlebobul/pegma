import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pegma/core/constants/app_constants.dart';
import 'package:pegma/core/themes/app_theme.dart';

class CustomToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomToggle({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = UIThemes.of(context);
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: SizedBox(
        width: 50,
        child: SvgPicture.asset(
          value ? CustomIcons.toggleOn : CustomIcons.toggleOff,
          fit: BoxFit.contain,
          colorFilter: ColorFilter.mode(theme.textColor, BlendMode.srcIn),
        ),
      ),
    );
  }
}
