import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pegma/data/models/board_model.dart';
import 'dart:math';

final gameProvider = StateNotifierProvider<GameNotifier, GameState>((ref) {
  return GameNotifier();
});

class GameNotifier extends StateNotifier<GameState> {
  GameNotifier()
    : super(GameState(board: <List<String>>[], possibleMoves: [])) {
    loadLevel(1);
  }

  Future<void> loadLevel(int level) async {
    final jsonString = await rootBundle.loadString(
      'lib/data/levels/level_$level.json',
    );
    final boardModel = BoardModel.fromJson(jsonString);
    state = GameState(board: boardModel.board, possibleMoves: []);
  }

  void onPegTap(int row, int col) {
    final newBoard = List<List<String>>.from(
      state.board.map((e) => List<String>.from(e)),
    );

    // If an empty cell is tapped and it's a valid move
    if ((newBoard[row][col] == '0' || newBoard[row][col] == 'eaten') &&
        state.possibleMoves.any((move) => move.x == row && move.y == col)) {
      movePeg(state.selectedRow!, state.selectedCol!, row, col);
      return;
    }

    // If a peg is tapped
    if (newBoard[row][col] == '1') {
      // Deselect previous if any
      if (state.selectedRow != null) {
        newBoard[state.selectedRow!][state.selectedCol!] = '1';
      }
      // Select the new peg
      newBoard[row][col] = '*';
      final possibleMoves = _calculatePossibleMoves(newBoard, row, col);
      state = GameState(
        board: newBoard,
        selectedRow: row,
        selectedCol: col,
        possibleMoves: possibleMoves,
      );
      return;
    }

    // If the selected peg is tapped again, deselect it
    if (row == state.selectedRow && col == state.selectedCol) {
      newBoard[row][col] = '1';
      state = GameState(
        board: newBoard,
        selectedRow: null,
        selectedCol: null,
        possibleMoves: [],
      );
      return;
    }
  }

  void movePeg(int fromRow, int fromCol, int toRow, int toCol) {
    final newBoard = List<List<String>>.from(
      state.board.map((e) => List<String>.from(e)),
    );

    // Move peg
    newBoard[toRow][toCol] = '1';
    newBoard[fromRow][fromCol] = '0';

    // Remove jumped peg
    final middleRow = fromRow + (toRow - fromRow) ~/ 2;
    final middleCol = fromCol + (toCol - fromCol) ~/ 2;
    newBoard[middleRow][middleCol] = 'eaten';

    state = GameState(
      board: newBoard,
      selectedRow: null,
      selectedCol: null,
      possibleMoves: [],
    );
  }

  List<Point<int>> _calculatePossibleMoves(
    List<List<String>> board,
    int r,
    int c,
  ) {
    final moves = <Point<int>>[];
    final directions = [
      const Point(0, 2), // right
      const Point(0, -2), // left
      const Point(2, 0), // down
      const Point(-2, 0), // up
    ];

    for (var dir in directions) {
      final targetRow = r + dir.x;
      final targetCol = c + dir.y;
      final middleRow = r + dir.x ~/ 2;
      final middleCol = c + dir.y ~/ 2;

      if (targetRow >= 0 &&
          targetRow < board.length &&
          targetCol >= 0 &&
          targetCol < board[0].length &&
          middleRow >= 0 &&
          middleRow < board.length &&
          middleCol >= 0 &&
          middleCol < board[0].length &&
          (board[targetRow][targetCol] == '0' ||
              board[targetRow][targetCol] == 'eaten') &&
          board[middleRow][middleCol] == '1') {
        moves.add(Point(targetRow, targetCol));
      }
    }
    return moves;
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
      possibleMoves: state.possibleMoves,
    );
  }
}

class GameState {
  final List<List<String>> board;
  final int? selectedRow;
  final int? selectedCol;
  final List<Point<int>> possibleMoves;

  GameState({
    required this.board,
    this.selectedRow,
    this.selectedCol,
    required this.possibleMoves,
  });
}
