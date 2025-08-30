import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pegma/data/models/board_model.dart';

final gameProvider = StateNotifierProvider<GameNotifier, GameState>((ref) {
  return GameNotifier();
});

class GameNotifier extends StateNotifier<GameState> {
  GameNotifier() : super(GameState(board: <List<String>>[])) {
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
    final currentCell = state.board[row][col];

    if (currentCell != '1' && currentCell != '*') return;

    final newBoard = List<List<String>>.from(
      state.board.map((e) => List<String>.from(e)),
    );

    if (state.selectedRow != null && state.selectedCol != null) {
      final prevSelectedRow = state.selectedRow!;
      final prevSelectedCol = state.selectedCol!;
      if (newBoard[prevSelectedRow][prevSelectedCol] == '*') {
        newBoard[prevSelectedRow][prevSelectedCol] = '1';
      }
    }

    if (state.selectedRow == row && state.selectedCol == col) {
      state = GameState(board: newBoard, selectedRow: null, selectedCol: null);
      return;
    }

    newBoard[row][col] = '*'; // Selected
    state = GameState(board: newBoard, selectedRow: row, selectedCol: col);
  }

  void eatPeg(int row, int col) {
    final newBoard = List<List<String>>.from(
      state.board.map((e) => List<String>.from(e)),
    );
    newBoard[row][col] = 'eaten'; // Eaten peg (съеденный шарик)
    state = GameState(
      board: newBoard,
      selectedRow: state.selectedRow,
      selectedCol: state.selectedCol,
    );
  }
}

class GameState {
  final List<List<String>> board;
  final int? selectedRow;
  final int? selectedCol;

  GameState({required this.board, this.selectedRow, this.selectedCol});
}
