import 'package:talker_flutter/talker_flutter.dart';

final talker = TalkerFlutter.init(
  settings: TalkerSettings(
    enabled: true,
    colors: {
      'error': AnsiPen()..red(),
      'info': AnsiPen()..magenta(),
      'debug': AnsiPen()..magenta(),
      'riverpod-update': AnsiPen()..yellow(),
      'sql': AnsiPen()..cyan(),
      'success': AnsiPen()..green(),
      'riverpod-add': AnsiPen()..cyan(),
    },
  ),
);
