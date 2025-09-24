import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pegma/core/themes/app_theme.dart';
import 'package:pegma/presentation/widgets/game/game_board.dart';
import '../../widgets/common/app_bar_widget.dart';
import '../../widgets/game/undo_bottom_bar.dart';
import '../../providers/game/timer_provider.dart';
import 'package:pegma/presentation/providers/game_provider.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final timerNotifier = ref.read(timerNotifierProvider.notifier);
    final timerState = ref.read(timerNotifierProvider);

    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        // Pause timer when app goes to background or becomes inactive
        timerNotifier.pauseTimer();
        break;
      case AppLifecycleState.resumed:
        // Auto-resume timer if it was running before (had a start time)
        if (timerState.startTime != null && !timerState.isRunning) {
          timerNotifier.startTimer();
        }
        break;
      case AppLifecycleState.hidden:
        timerNotifier.pauseTimer();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = UIThemes.of(context);
    final timerState = ref.watch(timerNotifierProvider);
    final gameState = ref.watch(gameProvider);
    final gameNotifier = ref.read(gameProvider.notifier);
    final totalPegs = gameState.initialPegCount > 1
        ? gameState.initialPegCount - 1
        : 0;

    return Scaffold(
      backgroundColor: theme.bgColor,
      appBar: CustomAppBar(
        showLeftArrowButton: true,
        showBackButton: false,
        showMenuButton: false,
        isGameScreen: true,
        timer: timerState.formattedTime,
        moves: '${gameState.movesCount}/$totalPegs',
      ),
      body: Column(
        children: [
          Expanded(child: Center(child: GameBoard())),
          UndoBottomBar(
            onUndoPressed: gameNotifier.redo,
            onRedoPressed: gameNotifier.undo,
            canUndo: gameState.redoStack.isNotEmpty,
            canRedo: gameState.history.isNotEmpty,
          ),
        ],
      ),
    );
  }
}
