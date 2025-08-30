import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pegma/core/constants/app_constants.dart';
import 'package:pegma/core/themes/app_theme.dart';

// TODO add haptic feedback
// TODO check android bottom bar menu settings
class UndoBottomBar extends StatelessWidget {
  final VoidCallback? onUndoPressed;
  final VoidCallback? onRedoPressed;
  final bool canUndo;
  final bool canRedo;

  const UndoBottomBar({
    super.key,
    this.onUndoPressed,
    this.onRedoPressed,
    this.canUndo = true,
    this.canRedo = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = UIThemes.of(context);
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(
        horizontal: 40,
        vertical: GeneralConsts.verticalPadding * 2,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: canRedo ? onRedoPressed : null,
            child: Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              child: SvgPicture.asset(
                CustomIcons.arrow,
                width: 30,
                colorFilter: ColorFilter.mode(
                  canRedo ? theme.textColor : theme.secondaryTextColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: canUndo ? onUndoPressed : null,
            child: Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              child: Transform.scale(
                scaleX: -1,
                child: SvgPicture.asset(
                  CustomIcons.arrow,
                  width: 30,
                  colorFilter: ColorFilter.mode(
                    canUndo ? theme.textColor : theme.secondaryTextColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
