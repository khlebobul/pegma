import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pegma/core/constants/app_constants.dart';
import 'package:pegma/core/themes/app_theme.dart';
import 'package:pegma/core/utils/useful_methods.dart';
import 'package:pegma/generated/l10n.dart';
import 'package:pegma/presentation/widgets/common/action_button.dart';

enum DialogType {
  textWithTwoButtons,
  textWithOneButton,
  textWithMenuAndLinks,
  closeButtonWithImage,
}

class DialogMenuItem {
  final String title;
  final VoidCallback onTap;

  const DialogMenuItem({required this.title, required this.onTap});
}

class DialogLinkItem {
  final String title;
  final String url;

  const DialogLinkItem({required this.title, required this.url});
}

class DialogWindow extends StatelessWidget {
  final DialogType type;
  final String? message;
  final String? imagePath;
  final String? description;
  final String? firstButtonText;
  final String? secondButtonText;
  final VoidCallback? onFirstButtonPressed;
  final VoidCallback? onSecondButtonPressed;
  final VoidCallback? onClosePressed;
  final List<DialogMenuItem>? menuItems;
  final List<DialogLinkItem>? linkItems;

  const DialogWindow({
    super.key,
    required this.type,
    this.message,
    this.imagePath,
    this.description,
    this.firstButtonText,
    this.secondButtonText,
    this.onFirstButtonPressed,
    this.onSecondButtonPressed,
    this.onClosePressed,
    this.menuItems,
    this.linkItems,
  });

  const DialogWindow.textWithTwoButtons({
    super.key,
    required this.message,
    required this.firstButtonText,
    required this.secondButtonText,
    required this.onFirstButtonPressed,
    required this.onSecondButtonPressed,
  }) : type = DialogType.textWithTwoButtons,
       imagePath = null,
       description = null,
       onClosePressed = null,
       menuItems = null,
       linkItems = null;

  const DialogWindow.textWithOneButton({
    super.key,
    required this.message,
    required this.firstButtonText,
    required this.onFirstButtonPressed,
  }) : type = DialogType.textWithOneButton,
       imagePath = null,
       description = null,
       secondButtonText = null,
       onSecondButtonPressed = null,
       onClosePressed = null,
       menuItems = null,
       linkItems = null;

  const DialogWindow.textWithMenuAndLinks({
    super.key,
    required this.message,
    required this.menuItems,
    required this.linkItems,
    this.onClosePressed,
  }) : type = DialogType.textWithMenuAndLinks,
       imagePath = null,
       description = null,
       firstButtonText = null,
       secondButtonText = null,
       onFirstButtonPressed = null,
       onSecondButtonPressed = null;

  const DialogWindow.closeButtonWithImage({
    super.key,
    required this.imagePath,
    required this.onClosePressed,
    this.description,
  }) : type = DialogType.closeButtonWithImage,
       message = null,
       firstButtonText = null,
       secondButtonText = null,
       onFirstButtonPressed = null,
       onSecondButtonPressed = null,
       menuItems = null,
       linkItems = null;

  @override
  Widget build(BuildContext context) {
    final theme = UIThemes.of(context);

    return Dialog(
      backgroundColor: theme.bgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      insetPadding: const EdgeInsets.all(GeneralConsts.horizontalPadding),
      child: Padding(
        padding: const EdgeInsets.all(GeneralConsts.horizontalPadding),
        child: _buildDialogContent(context, theme),
      ),
    );
  }

  Widget _buildDialogContent(BuildContext context, UIThemes theme) {
    switch (type) {
      case DialogType.textWithTwoButtons:
        return _buildTextWithTwoButtons(context, theme);
      case DialogType.textWithOneButton:
        return _buildTextWithOneButton(context, theme);
      case DialogType.textWithMenuAndLinks:
        return _buildTextWithMenuAndLinks(context, theme);
      case DialogType.closeButtonWithImage:
        return _buildCloseButtonWithImage(context, theme);
    }
  }

  // Type 1: Text with two buttons
  Widget _buildTextWithTwoButtons(BuildContext context, UIThemes theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (message != null) ...[
          Text(
            message!,
            style: theme.basicTextStyle.copyWith(
              color: theme.secondaryTextColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: ActionButton(
                title: firstButtonText ?? S.of(context).ok,
                onTap:
                    onFirstButtonPressed ?? () => Navigator.of(context).pop(),
                textStyle: theme.basicTextStyle,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: ActionButton(
                  title: secondButtonText ?? S.of(context).cancel,
                  onTap:
                      onSecondButtonPressed ??
                      () => Navigator.of(context).pop(),
                  textStyle: theme.basicTextStyle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Type 1b: Text with one button (centered)
  Widget _buildTextWithOneButton(BuildContext context, UIThemes theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (message != null) ...[
          Text(
            message!,
            style: theme.basicTextStyle.copyWith(
              color: theme.secondaryTextColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
        ],
        Center(
          child: ActionButton(
            title: firstButtonText ?? S.of(context).ok,
            onTap: onFirstButtonPressed ?? () => Navigator.of(context).pop(),
            textStyle: theme.basicTextStyle,
          ),
        ),
      ],
    );
  }

  // Type 2: Text with menu and links
  Widget _buildTextWithMenuAndLinks(BuildContext context, UIThemes theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (message != null) ...[
          Text(
            message!,
            style: theme.basicTextStyle.copyWith(
              color: theme.secondaryTextColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
        ],

        if (menuItems != null && menuItems!.isNotEmpty) ...[
          ...menuItems!.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ActionButton(
                title: item.title,
                onTap: item.onTap,
                textStyle: theme.basicTextStyle,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],

        if (linkItems != null && linkItems!.isNotEmpty) ...[
          ...linkItems!.map(
            (link) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GestureDetector(
                onTap: () => launchLinkUrl(link.url),
                child: Text(
                  link.title,
                  style: theme.basicTextStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  // Type 3: close button and image
  Widget _buildCloseButtonWithImage(BuildContext context, UIThemes theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: onClosePressed ?? () => Navigator.of(context).pop(),
              child: SvgPicture.asset(
                CustomIcons.close,
                width: 20,
                colorFilter: ColorFilter.mode(theme.textColor, BlendMode.srcIn),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        if (imagePath != null)
          Image.asset(
            imagePath!,
            fit: BoxFit.contain,
            // height: 200,
            errorBuilder: (context, error, stackTrace) {
              return SvgPicture.asset(Images.rulesScheme);
            },
          ),
        if (description != null) ...[
          const SizedBox(height: 16),
          Text(
            description!,
            style: theme.basicTextStyle.copyWith(
              color: theme.secondaryTextColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
