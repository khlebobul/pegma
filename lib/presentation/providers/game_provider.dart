import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pegma/data/models/board_model.dart';
import 'dart:math';

const _sentinel = Object();

enum GameStatus { playing, won, lost }

final gameProvider = StateNotifierProvider.family<GameNotifier, GameState, int>(
  (ref, levelId) {
    return GameNotifier(levelId);
  },
);

class GameNotifier extends StateNotifier<GameState> {
  final int levelId;

  GameNotifier(this.levelId)
    : super(GameState(board: <List<String>>[], possibleMoves: [])) {
    loadLevel(levelId);
  }

  Future<void> loadLevel(int level) async {
    try {
      final jsonString = await rootBundle.loadString(
        'lib/data/levels/level_$level.json',
      );
      final boardModel = BoardModel.fromJson(jsonString);
      final initialPegs = boardModel.board
          .expand((row) => row)
          .where((cell) => cell == '1')
          .length;
      state = GameState(
        board: boardModel.board,
        possibleMoves: [],
        initialPegCount: initialPegs,
      );
    } catch (e) {
      if (level != 1) {
        loadLevel(1);
      }
    }
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
      state = state.copyWith(
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
      state = state.copyWith(
        board: newBoard,
        selectedRow: null,
        selectedCol: null,
        possibleMoves: [],
      );
      return;
    }
  }

  void movePeg(int fromRow, int fromCol, int toRow, int toCol) {
    final previousState = state;
    final newBoard = List<List<String>>.from(
      state.board.map((e) => List<String>.from(e)),
    );

    // Move peg
    newBoard[toRow][toCol] = '1';
    newBoard[fromRow][fromCol] = 'eaten';

    // Remove jumped peg
    final middleRow = fromRow + (toRow - fromRow) ~/ 2;
    final middleCol = fromCol + (toCol - fromCol) ~/ 2;
    newBoard[middleRow][middleCol] = 'eaten';

    state = state.copyWith(
      board: newBoard,
      selectedRow: null,
      selectedCol: null,
      possibleMoves: [],
      history: [...state.history, previousState],
      redoStack: [],
      movesCount: state.movesCount + 1,
    );
    _checkEndGame();
  }

  void _checkEndGame() {
    final pegsLeft = state.board
        .expand((row) => row)
        .where((cell) => cell == '1')
        .length;
    if (pegsLeft == 1) {
      state = state.copyWith(status: GameStatus.won);
      return;
    }

    bool hasMoves = false;
    for (int r = 0; r < state.board.length; r++) {
      for (int c = 0; c < state.board[r].length; c++) {
        if (state.board[r][c] == '1') {
          if (_calculatePossibleMoves(state.board, r, c).isNotEmpty) {
            hasMoves = true;
            break;
          }
        }
      }
      if (hasMoves) break;
    }

    if (!hasMoves) {
      state = state.copyWith(status: GameStatus.lost);
    }
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
    newBoard[row][col] = 'eaten'; // Eaten peg
    state = state.copyWith(
      board: newBoard,
      selectedRow: state.selectedRow,
      selectedCol: state.selectedCol,
      possibleMoves: state.possibleMoves,
    );
  }

  void undo() {
    if (state.history.isEmpty) return;
    final lastState = state.history.last;
    final newHistory = List<GameState>.from(state.history)..removeLast();
    state = lastState.copyWith(
      redoStack: [...lastState.redoStack, state],
      history: newHistory,
    );
  }

  void redo() {
    if (state.redoStack.isEmpty) return;
    final nextState = state.redoStack.last;
    final newRedoStack = List<GameState>.from(state.redoStack)..removeLast();
    state = nextState.copyWith(
      history: [...nextState.history, state],
      redoStack: newRedoStack,
    );
  }

  void restartLevel() {
    loadLevel(levelId);
  }
}

class GameState {
  final List<List<String>> board;
  final int? selectedRow;
  final int? selectedCol;
  final List<Point<int>> possibleMoves;
  final List<GameState> history;
  final List<GameState> redoStack;
  final int movesCount;
  final int initialPegCount;
  final GameStatus status;

  GameState({
    required this.board,
    this.selectedRow,
    this.selectedCol,
    required this.possibleMoves,
    this.history = const [],
    this.redoStack = const [],
    this.movesCount = 0,
    this.initialPegCount = 0,
    this.status = GameStatus.playing,
  });

  GameState copyWith({
    List<List<String>>? board,
    Object? selectedRow = _sentinel,
    Object? selectedCol = _sentinel,
    List<Point<int>>? possibleMoves,
    List<GameState>? history,
    List<GameState>? redoStack,
    int? movesCount,
    int? initialPegCount,
    GameStatus? status,
  }) {
    return GameState(
      board: board ?? this.board,
      selectedRow: selectedRow == _sentinel
          ? this.selectedRow
          : selectedRow as int?,
      selectedCol: selectedCol == _sentinel
          ? this.selectedCol
          : selectedCol as int?,
      possibleMoves: possibleMoves ?? this.possibleMoves,
      history: history ?? this.history,
      redoStack: redoStack ?? this.redoStack,
      movesCount: movesCount ?? this.movesCount,
      initialPegCount: initialPegCount ?? this.initialPegCount,
      status: status ?? this.status,
    );
  }
}
