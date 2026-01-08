import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pegma/data/models/board_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Levels Solvability Test', () {
    test('all levels should be solvable', () async {
      // Load manifest to get list of all levels
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);

      final levelPaths = manifestMap.keys
          .where((String key) => key.contains('lib/data/levels/level_'))
          .toList();

      final levelNumbers = levelPaths.map((path) {
        final levelNumber = int.parse(
          path.split('/').last.replaceAll('level_', '').replaceAll('.json', ''),
        );
        return levelNumber;
      }).toList()..sort();

      expect(
        levelNumbers.isNotEmpty,
        true,
        reason: 'Should have at least one level',
      );

      final unsolvableLevels = <int>[];
      int solvedCount = 0;

      for (final levelNumber in levelNumbers) {
        final jsonString = await rootBundle.loadString(
          'lib/data/levels/level_$levelNumber.json',
        );
        final boardModel = BoardModel.fromJson(jsonString);

        // Create a copy of the board for solving
        final board = boardModel.board
            .map((row) => List<String>.from(row))
            .toList();

        // Check if level is solvable
        final solver = PegSolitaireSolver(board);
        final isSolvable = solver.solve();

        if (isSolvable) {
          solvedCount++;
        } else {
          unsolvableLevels.add(levelNumber);
        }
      }

      // Check that all levels are solvable
      if (unsolvableLevels.isNotEmpty) {
        final unsolvableList = unsolvableLevels
            .map((level) => 'level_$level.json')
            .join(', ');
        fail('Found unsolvable levels: $unsolvableList');
      }

      expect(
        unsolvableLevels.isEmpty,
        true,
        reason: 'All levels should be solvable',
      );

      debugPrint(
        '✓ Checked ${levelNumbers.length} levels, $solvedCount solvable, ${unsolvableLevels.length} unsolvable',
      );
    });
  });
}

/// Solver for Peg Solitaire game
class PegSolitaireSolver {
  final List<List<String>> initialBoard;
  final int maxDepth;
  final Set<String> _visitedStates = {};

  PegSolitaireSolver(this.initialBoard, {this.maxDepth = 1000});

  /// Attempts to solve the puzzle using backtracking
  bool solve() {
    final board = _copyBoard(initialBoard);
    return _solveRecursive(board, 0);
  }

  /// Recursive backtracking solver
  bool _solveRecursive(List<List<String>> board, int depth) {
    // Check if we've exceeded max depth (prevent infinite recursion)
    if (depth > maxDepth) {
      return false;
    }

    // Check win condition: only one peg left
    final pegsCount = _countPegs(board);
    if (pegsCount == 1) {
      return true;
    }

    // Check if no moves are possible
    final allMoves = _getAllPossibleMoves(board);
    if (allMoves.isEmpty) {
      return false;
    }

    // Create state signature to avoid revisiting same states
    final stateSignature = _getBoardSignature(board);
    if (_visitedStates.contains(stateSignature)) {
      return false;
    }
    _visitedStates.add(stateSignature);

    // Try each possible move
    for (final move in allMoves) {
      // Make the move
      _makeMove(board, move);

      // Recursively try to solve
      if (_solveRecursive(board, depth + 1)) {
        return true;
      }

      // Undo the move (backtrack)
      _undoMove(board, move);
    }

    return false;
  }

  /// Get all possible moves from current board state
  List<Move> _getAllPossibleMoves(List<List<String>> board) {
    final moves = <Move>[];

    for (int r = 0; r < board.length; r++) {
      for (int c = 0; c < board[r].length; c++) {
        if (board[r][c] == '1') {
          // Check all four directions
          final directions = [
            const Point(0, 2), // right
            const Point(0, -2), // left
            const Point(2, 0), // down
            const Point(-2, 0), // up
          ];

          for (final dir in directions) {
            final targetRow = r + dir.x;
            final targetCol = c + dir.y;
            final middleRow = r + dir.x ~/ 2;
            final middleCol = c + dir.y ~/ 2;

            if (_isValidMove(
              board,
              r,
              c,
              targetRow,
              targetCol,
              middleRow,
              middleCol,
            )) {
              moves.add(
                Move(
                  fromRow: r,
                  fromCol: c,
                  toRow: targetRow,
                  toCol: targetCol,
                  middleRow: middleRow,
                  middleCol: middleCol,
                ),
              );
            }
          }
        }
      }
    }

    return moves;
  }

  /// Check if a move is valid
  bool _isValidMove(
    List<List<String>> board,
    int fromRow,
    int fromCol,
    int toRow,
    int toCol,
    int middleRow,
    int middleCol,
  ) {
    // Check bounds
    if (toRow < 0 ||
        toRow >= board.length ||
        toCol < 0 ||
        toCol >= board[0].length ||
        middleRow < 0 ||
        middleRow >= board.length ||
        middleCol < 0 ||
        middleCol >= board[0].length) {
      return false;
    }

    // Target must be empty (0 or eaten)
    if (board[toRow][toCol] != '0' && board[toRow][toCol] != 'eaten') {
      return false;
    }

    // Middle must have a peg
    if (board[middleRow][middleCol] != '1') {
      return false;
    }

    // Source must have a peg
    if (board[fromRow][fromCol] != '1') {
      return false;
    }

    // Can't move to inactive cells
    if (board[toRow][toCol] == 'x') {
      return false;
    }

    return true;
  }

  /// Make a move on the board
  void _makeMove(List<List<String>> board, Move move) {
    board[move.toRow][move.toCol] = '1';
    board[move.fromRow][move.fromCol] = 'eaten';
    board[move.middleRow][move.middleCol] = 'eaten';
  }

  /// Undo a move on the board
  void _undoMove(List<List<String>> board, Move move) {
    board[move.fromRow][move.fromCol] = '1';
    board[move.middleRow][move.middleCol] = '1';
    board[move.toRow][move.toCol] = '0';
  }

  /// Count number of pegs on the board
  int _countPegs(List<List<String>> board) {
    int count = 0;
    for (final row in board) {
      for (final cell in row) {
        if (cell == '1') {
          count++;
        }
      }
    }
    return count;
  }

  /// Create a signature of the board state for duplicate detection
  String _getBoardSignature(List<List<String>> board) {
    final buffer = StringBuffer();
    for (final row in board) {
      for (final cell in row) {
        buffer.write(cell);
      }
    }
    return buffer.toString();
  }

  /// Create a deep copy of the board
  List<List<String>> _copyBoard(List<List<String>> board) {
    return board.map((row) => List<String>.from(row)).toList();
  }
}

/// Represents a move in the game
class Move {
  final int fromRow;
  final int fromCol;
  final int toRow;
  final int toCol;
  final int middleRow;
  final int middleCol;

  Move({
    required this.fromRow,
    required this.fromCol,
    required this.toRow,
    required this.toCol,
    required this.middleRow,
    required this.middleCol,
  });
}
