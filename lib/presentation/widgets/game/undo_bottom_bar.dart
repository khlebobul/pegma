import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gaimon/gaimon.dart';
import 'package:pegma/core/constants/app_constants.dart';
import 'package:pegma/core/themes/app_theme.dart';

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
    return SafeArea(
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(
          horizontal: GeneralConsts.horizontalPadding,
          vertical: GeneralConsts.verticalPadding * 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: canRedo
                    ? () {
                        onRedoPressed?.call();
                        Gaimon.soft();
                      }
                    : null,
                child: Container(
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
            ),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: canUndo
                    ? () {
                        onUndoPressed?.call();
                        Gaimon.soft();
                      }
                    : null,
                child: Container(
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
            ),
          ],
        ),
      ),
    );
  }
}
