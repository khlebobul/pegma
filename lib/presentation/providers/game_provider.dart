import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pegma/data/models/board_model.dart';

final gameProvider = StateNotifierProvider<GameNotifier, GameState>((ref) {
  return GameNotifier();
});

class GameNotifier extends StateNotifier<GameState> {
  GameNotifier() : super(GameState(board: [])) {
    loadLevel(1);
  }

  Future<void> loadLevel(int level) async {
    final jsonString = await rootBundle.loadString(
      'lib/data/levels/level_$level.json',
    );
    final boardModel = BoardModel.fromJson(jsonString);
    state = GameState(board: boardModel.board);
  }

  void onPegTap(int row, int col) {
    final newBoard = List<List<int>>.from(
      state.board.map((e) => List<int>.from(e)),
    );
    if (newBoard[row][col] == 1) {
      newBoard[row][col] = 2; // Selected
    } else if (newBoard[row][col] == 2) {
      newBoard[row][col] = 1; // Unselected
    }
    state = GameState(board: newBoard);
  }
}

class GameState {
  final List<List<int>> board;

  GameState({required this.board});
}
