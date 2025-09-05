import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/models/game_score_model.dart';

part 'game_state_provider.g.dart';

enum GameStatus { idle, playing, paused, gameOver, won }

class GameState {
  final GameStatus status;
  final int currentScore;
  final int currentLevel;
  final int currentMoves;
  final List<GameScore> highScores;
  final bool isGameStarted;

  const GameState({
    this.status = GameStatus.idle,
    this.currentScore = 0,
    this.currentLevel = 1,
    this.currentMoves = 0,
    this.highScores = const [],
    this.isGameStarted = false,
  });

  GameState copyWith({
    GameStatus? status,
    int? currentScore,
    int? currentLevel,
    int? currentMoves,
    List<GameScore>? highScores,
    bool? isGameStarted,
  }) {
    return GameState(
      status: status ?? this.status,
      currentScore: currentScore ?? this.currentScore,
      currentLevel: currentLevel ?? this.currentLevel,
      currentMoves: currentMoves ?? this.currentMoves,
      highScores: highScores ?? this.highScores,
      isGameStarted: isGameStarted ?? this.isGameStarted,
    );
  }
}

@riverpod
class GameStateNotifier extends _$GameStateNotifier {
  @override
  GameState build() {
    return const GameState();
  }

  void startGame() {
    state = state.copyWith(
      status: GameStatus.playing,
      isGameStarted: true,
      currentScore: 0,
      currentMoves: 0,
      currentLevel: 1,
    );
  }

  void pauseGame() {
    if (state.status == GameStatus.playing) {
      state = state.copyWith(status: GameStatus.paused);
    }
  }

  void resumeGame() {
    if (state.status == GameStatus.paused) {
      state = state.copyWith(status: GameStatus.playing);
    }
  }

  void endGame([Duration? gameTime]) {
    final gameScore = GameScore(
      score: state.currentScore,
      level: state.currentLevel,
      moves: state.currentMoves,
      timestamp: DateTime.now(),
      gameTime: gameTime,
    );

    final updatedHighScores = [...state.highScores, gameScore]
      ..sort((a, b) => b.score.compareTo(a.score))
      ..take(10).toList();

    state = state.copyWith(
      status: GameStatus.gameOver,
      highScores: updatedHighScores,
    );
  }

  void restartGame() {
    state = state.copyWith(
      status: GameStatus.playing,
      currentScore: 0,
      currentMoves: 0,
      currentLevel: 1,
    );
  }

  void resetGame() {
    state = const GameState();
  }

  void increaseScore(int points) {
    state = state.copyWith(currentScore: state.currentScore + points);
  }

  void increaseMoves() {
    state = state.copyWith(currentMoves: state.currentMoves + 1);
  }

  void nextLevel() {
    state = state.copyWith(currentLevel: state.currentLevel + 1);
  }

  void winGame([Duration? gameTime]) {
    final gameScore = GameScore(
      score: state.currentScore,
      level: state.currentLevel,
      moves: state.currentMoves,
      timestamp: DateTime.now(),
      gameTime: gameTime,
    );

    final updatedHighScores = [...state.highScores, gameScore]
      ..sort((a, b) => b.score.compareTo(a.score))
      ..take(10).toList();

    state = state.copyWith(
      status: GameStatus.won,
      highScores: updatedHighScores,
    );
  }
}
