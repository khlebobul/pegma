// Offline captures of production widgets; no personal preferences or saves.
// Run from app root: flutter test test/store_screenshots/capture_test.dart
@Tags(['store-screenshots'])
library;

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pegma/core/themes/app_theme.dart';
import 'package:pegma/generated/l10n.dart';
import 'package:pegma/presentation/providers/game_provider.dart';
import 'package:pegma/presentation/screens/game/game_screen.dart';
import 'package:pegma/presentation/screens/home/home_screen.dart';
import 'package:pegma/presentation/widgets/tutorial/interactive_tutorial_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    databaseFactory = databaseFactorySqflitePlugin;
    await (FontLoader(
      'Pegma',
    )..addFont(rootBundle.load('assets/fonts/pegma-app.ttf'))).load();
    // Native fallback for glyphs absent from the app font, as on a device.
    await (FontLoader('Roboto')..addFont(
          Future.value(
            ByteData.sublistView(
              File(
                '/System/Library/Fonts/Supplemental/Arial.ttf',
              ).readAsBytesSync(),
            ),
          ),
        ))
        .load();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('com.tekartik.sqflite'), (
          call,
        ) async {
          switch (call.method) {
            case 'getDatabasesPath':
              return '/tmp/pegma-screenshot-fixture';
            case 'openDatabase':
              return {'id': 1};
            case 'query':
              if ((call.arguments['sql'] as String).contains('user_version')) {
                return [
                  {'user_version': 6},
                ];
              }
              return <Map<String, Object?>>[];
            case 'execute':
            case 'closeDatabase':
            case 'options':
              return null;
            default:
              throw StateError('Unexpected database call: ${call.method}');
          }
        });
  });

  testWidgets('capture every supported locale and device', (tester) async {
    addTearDown(() {
      tester.view.reset();
      debugDefaultTargetPlatformOverride = null;
    });
    for (final locale in S.delegate.supportedLocales) {
      for (final device in ['iphone', 'ipad', 'android']) {
        debugPrint('Capturing ${locale.languageCode} $device');
        final android = device == 'android';
        final phone = device != 'ipad';
        final ratio = phone ? 3.0 : 2.0;
        tester.view.physicalSize = android
            ? const Size(1080, 2340)
            : phone
            ? const Size(1320, 2868)
            : const Size(2064, 2752);
        tester.view.devicePixelRatio = ratio;
        tester.view.padding = FakeViewPadding(
          top: (phone ? 62 : 24) * ratio,
          bottom: (phone ? 34 : 20) * ratio,
        );
        tester.view.viewPadding = tester.view.padding;
        final platform = android ? TargetPlatform.android : TargetPlatform.iOS;
        debugDefaultTargetPlatformOverride = platform;

        Future<void> shoot(
          String name,
          String level, {
          int moves = 0,
          bool dark = false,
          bool home = false,
          bool tutorial = false,
          bool hints = false,
          bool undo = false,
        }) async {
          await tester.pumpWidget(const SizedBox());
          SharedPreferences.setMockInitialValues({'isFirstLaunch': false});
          final container = ProviderContainer();
          final key = GlobalKey();
          await tester.pumpWidget(
            UncontrolledProviderScope(
              container: container,
              child: RepaintBoundary(
                key: key,
                child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: (dark ? UIThemes.darkTheme() : UIThemes.lightTheme())
                      .copyWith(platform: platform),
                  locale: locale,
                  localizationsDelegates: const [
                    S.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: S.delegate.supportedLocales,
                  home: home ? const HomeScreen() : GameScreen(levelId: level),
                ),
              ),
            ),
          );
          for (var i = 0; i < 20; i++) {
            await tester.pump(const Duration(milliseconds: 50));
          }
          if (!home) {
            final game = container.read(gameProvider(level).notifier);
            expect(container.read(gameProvider(level)).board, isNotEmpty);
            // Select and perform only jumps offered by the production game.
            for (var i = 0; i < moves + (hints ? 1 : 0); i++) {
              final board = container.read(gameProvider(level)).board;
              var found = false;
              for (var r = 0; r < board.length && !found; r++) {
                for (var c = 0; c < board[r].length && !found; c++) {
                  if (board[r][c] != '1') {
                    continue;
                  }
                  await game.onPegTap(r, c);
                  final options = container
                      .read(gameProvider(level))
                      .possibleMoves;
                  if (options.isEmpty) {
                    game.clearSelection();
                    continue;
                  }
                  found = true;
                  if (i < moves) {
                    await game.onPegTap(options.first.x, options.first.y);
                  }
                }
              }
              expect(found, isTrue, reason: 'Demo jump must be legal');
            }
            expect(container.read(gameProvider(level)).movesCount, moves);
            expect(
              container.read(gameProvider(level)).status,
              GameStatus.playing,
            );
            if (undo) {
              game.undo();
              expect(container.read(gameProvider(level)).redoStack, isNotEmpty);
            }
            if (tutorial) {
              showDialog<void>(
                context: tester.element(find.byType(GameScreen)),
                builder: (context) => InteractiveTutorialDialog(
                  onClose: () => Navigator.pop(context),
                ),
              );
            }
          }
          for (var i = 0; i < 12; i++) {
            await tester.pump(const Duration(milliseconds: 50));
          }
          expect(tester.takeException(), isNull);
          final boundary = tester.renderObject<RenderRepaintBoundary>(
            find.byKey(key),
          );
          await tester.runAsync(() async {
            final image = await boundary.toImage(pixelRatio: ratio);
            final data = await image.toByteData(format: ui.ImageByteFormat.png);
            final folder = android ? 'android/phone' : 'apple/$device';
            final file = File(
              'store_screenshots/public/screenshots/$folder/${locale.languageCode}/$name.png',
            );
            file.parent.createSync(recursive: true);
            file.writeAsBytesSync(data!.buffer.asUint8List());
            image.dispose();
          });
          await tester.pumpWidget(const SizedBox());
          container.dispose();
        }

        await shoot('01-classic', '0.1', moves: 8, hints: true);
        await shoot('02-levels', '0.1', home: true);
        await shoot('03-hints', '0.2', moves: 3, hints: true);
        await shoot('04-dark', '0.1', moves: 12, dark: true);
        await shoot('05-tutorial', '0.1', tutorial: true);
        await shoot('06-undo', '0.2', moves: 5, undo: true);
        debugDefaultTargetPlatformOverride = null;
        tester.view.reset();
      }
    }
  });
}
