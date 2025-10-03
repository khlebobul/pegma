import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pegma/core/themes/app_theme.dart';
import 'package:pegma/generated/l10n.dart';
import 'package:pegma/presentation/widgets/common/dialog_window.dart';
import 'package:pegma/presentation/widgets/game/game_board.dart';
import 'package:pegma/presentation/providers/completed_levels_provider.dart';
import 'package:pegma/presentation/providers/levels_provider.dart';
import '../../widgets/common/app_bar_widget.dart';
import '../../widgets/game/undo_bottom_bar.dart';
import 'package:pegma/presentation/providers/game_provider.dart';

class GameScreen extends ConsumerStatefulWidget {
  final int levelId;
  const GameScreen({super.key, required this.levelId});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _saveGameState() {
    final gameNotifier = ref.read(gameProvider(widget.levelId).notifier);
    gameNotifier.saveCurrentState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        _saveGameState();
        break;
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.hidden:
        _saveGameState();
        break;
    }
  }

  void _showWinDialog(BuildContext context, GameNotifier gameNotifier) {
    // Invalidate completed levels provider to refresh UI
    ref.invalidate(completedLevelsProvider);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => DialogWindow.textWithTwoButtons(
        message: S.of(context).youWon,
        firstButtonText: S.of(context).menu,
        secondButtonText: S.of(context).nextLevel,
        onFirstButtonPressed: () {
          Navigator.of(context).pop();
          context.pop();
        },
        onSecondButtonPressed: () {
          Navigator.of(context).pop();
          final nextLevelId = widget.levelId + 1;
          context.pop();
          context.push('/game/$nextLevelId');
        },
      ),
    );
  }

  void _showLossDialog(BuildContext context, GameNotifier gameNotifier) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => DialogWindow.textWithTwoButtons(
        message: S.of(context).noMoreMoves,
        firstButtonText: S.of(context).menu,
        secondButtonText: S.of(context).restart,
        onFirstButtonPressed: () {
          Navigator.of(context).pop();
          context.pop();
        },
        onSecondButtonPressed: () {
          Navigator.of(context).pop();
          gameNotifier.restartLevel();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = UIThemes.of(context);
    final gameNotifier = ref.read(gameProvider(widget.levelId).notifier);

    ref.listen<GameState>(gameProvider(widget.levelId), (previous, next) {
      if (next.status == GameStatus.won && previous?.status != GameStatus.won) {
        _showWinDialog(context, gameNotifier);
      } else if (next.status == GameStatus.lost &&
          previous?.status != GameStatus.lost) {
        _showLossDialog(context, gameNotifier);
      }
    });

    final gameState = ref.watch(gameProvider(widget.levelId));

    // Get level display number (0-based in UI, but we receive asset IDs)
    final levelsAsyncValue = ref.watch(levelsProvider);
    final levels = levelsAsyncValue.valueOrNull ?? [];
    final displayLevelNumber = levels.indexOf(widget.levelId);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          _saveGameState();
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: theme.bgColor,
        appBar: CustomAppBar(
          showLeftArrowButton: true,
          showBackButton: false,
          showMenuButton: false,
          isGameScreen: true,
          moves: displayLevelNumber >= 0 ? '$displayLevelNumber' : '0',
          onBackButtonPressed: () {
            _saveGameState();
            context.pop();
          },
        ),
        body: Column(
          children: [
            Expanded(
              child: Center(child: GameBoard(levelId: widget.levelId)),
            ),
            UndoBottomBar(
              onUndoPressed: gameNotifier.redo,
              onRedoPressed: gameNotifier.undo,
              canUndo: gameState.redoStack.isNotEmpty,
              canRedo: gameState.history.isNotEmpty,
            ),
          ],
        ),
      ),
    );
  }
}
