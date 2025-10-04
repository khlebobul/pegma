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
    _checkLevelStatusAndLoad();
  }

  Future<void> _checkLevelStatusAndLoad() async {
    final gameNotifier = ref.read(gameProvider(widget.levelId).notifier);
    final loadType = await gameNotifier.checkLevelStatus();

    if (!mounted) return;

    switch (loadType) {
      case LevelLoadType.fresh:
        await gameNotifier.loadLevel(widget.levelId);
        break;
      case LevelLoadType.savedGame:
        _showSavedGameDialog();
        break;
      case LevelLoadType.completed:
        _showCompletedLevelDialog();
        break;
    }
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

  void _showRestartDialog(BuildContext context, GameNotifier gameNotifier) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => DialogWindow.textWithTwoButtons(
        message: S.of(context).startAgain,
        firstButtonText: S.of(context).cancel,
        secondButtonText: S.of(context).yes,
        onFirstButtonPressed: () {
          Navigator.of(context).pop();
        },
        onSecondButtonPressed: () {
          Navigator.of(context).pop();
          gameNotifier.restartLevel();
        },
      ),
    );
  }

  void _showSavedGameDialog() {
    final gameNotifier = ref.read(gameProvider(widget.levelId).notifier);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => DialogWindow.textWithTwoButtons(
        message: S.of(context).youHaveAnUnfinishedGame,
        firstButtonText: S.of(context).again,
        secondButtonText: S.of(context).doContinue,
        onFirstButtonPressed: () async {
          Navigator.of(context).pop();
          await gameNotifier.loadFreshLevel();
        },
        onSecondButtonPressed: () async {
          Navigator.of(context).pop();
          await gameNotifier.loadLevel(widget.levelId);
        },
      ),
    );
  }

  void _showCompletedLevelDialog() {
    final gameNotifier = ref.read(gameProvider(widget.levelId).notifier);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => DialogWindow.textWithTwoButtons(
        message: S.of(context).levelCompleted,
        firstButtonText: S.of(context).menu,
        secondButtonText: S.of(context).again,
        onFirstButtonPressed: () {
          Navigator.of(context).pop();
          context.pop();
        },
        onSecondButtonPressed: () async {
          Navigator.of(context).pop();
          await gameNotifier.loadFreshLevel();
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

    final levelsAsyncValue = ref.watch(levelsProvider);
    final levels = levelsAsyncValue.valueOrNull ?? [];
    final displayLevelNumber = levels.indexOf(widget.levelId);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
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
          showRefreshButton: true,
          onRefreshPressed: () => _showRestartDialog(context, gameNotifier),
          isRefreshEnabled: gameState.movesCount > 0,
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
