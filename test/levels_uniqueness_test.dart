import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pegma/data/models/board_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Levels Uniqueness Test', () {
    test('all levels should be unique', () async {
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

      // Load all levels
      final Map<int, BoardModel> levels = {};
      for (final levelNumber in levelNumbers) {
        final jsonString = await rootBundle.loadString(
          'lib/data/levels/level_$levelNumber.json',
        );
        levels[levelNumber] = BoardModel.fromJson(jsonString);
      }

      // Check uniqueness: compare each level with every other level
      final duplicates = <List<int>>[];

      for (int i = 0; i < levelNumbers.length; i++) {
        for (int j = i + 1; j < levelNumbers.length; j++) {
          final level1 = levelNumbers[i];
          final level2 = levelNumbers[j];
          final board1 = levels[level1]!.board;
          final board2 = levels[level2]!.board;

          // Compare boards row by row
          if (_boardsAreEqual(board1, board2)) {
            duplicates.add([level1, level2]);
          }
        }
      }

      // Check that there are no duplicates
      if (duplicates.isNotEmpty) {
        final duplicateMessages = duplicates
            .map((pair) => 'level_${pair[0]}.json == level_${pair[1]}.json')
            .join(', ');
        fail('Found duplicate levels: $duplicateMessages');
      }

      // Additional check: all levels should be unique
      expect(duplicates.isEmpty, true, reason: 'All levels should be unique');

      // Print information about the number of checked levels
      debugPrint('✓ Checked ${levelNumbers.length} levels, all are unique');
    });

    test('should load all level files correctly', () async {
      // Check that all level files can be loaded and parsed
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);

      final levelPaths = manifestMap.keys
          .where((String key) => key.contains('lib/data/levels/level_'))
          .toList();

      for (final path in levelPaths) {
        final jsonString = await rootBundle.loadString(path);
        expect(
          () => BoardModel.fromJson(jsonString),
          returnsNormally,
          reason: 'Level $path should be valid JSON',
        );
      }
    });
  });
}

/// Compares two boards for equality
bool _boardsAreEqual(List<List<String>> board1, List<List<String>> board2) {
  if (board1.length != board2.length) {
    return false;
  }

  for (int i = 0; i < board1.length; i++) {
    if (board1[i].length != board2[i].length) {
      return false;
    }
    for (int j = 0; j < board1[i].length; j++) {
      if (board1[i][j] != board2[i][j]) {
        return false;
      }
    }
  }

  return true;
}
