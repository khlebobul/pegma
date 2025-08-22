import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> sendEmail(
  BuildContext context,
  String email,
  String subject,
) async {
  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: email,
    queryParameters: {'subject': '$subject - pegma'},
  );

  if (await canLaunchUrl(emailLaunchUri)) {
    await launchUrl(emailLaunchUri);
  } else {
    await Clipboard.setData(ClipboardData(text: email));
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 5),
        // ignore: use_build_context_synchronously
        content: Text('email copied to clipboard'),
      ),
    );
  }
}
