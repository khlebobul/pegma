import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger.dart';
import 'app.dart';

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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    ProviderScope(
      observers: [
        TalkerRiverpodObserver(
          talker: talker,
          settings: const TalkerRiverpodLoggerSettings(
            printProviderAdded: true,
            printProviderUpdated: true,
            printProviderDisposed: true,
          ),
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const App();
  }
}
