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

      final levelIds = levelPaths.map((path) {
        final levelId = path.split('/').last.replaceAll('level_', '').replaceAll('.json', '');
        return levelId;
      }).toList();

      // Sort numerically (supports fractional levels like 0.1, 0.2)
      levelIds.sort((a, b) {
        final aNum = double.tryParse(a) ?? 0;
        final bNum = double.tryParse(b) ?? 0;
        return aNum.compareTo(bNum);
      });

      expect(
        levelIds.isNotEmpty,
        true,
        reason: 'Should have at least one level',
      );

      debugPrint('\nChecking uniqueness of ${levelIds.length} levels...');

      // Load all levels
      final Map<String, BoardModel> levels = {};
      for (final levelId in levelIds) {
        final jsonString = await rootBundle.loadString(
          'lib/data/levels/level_$levelId.json',
        );
        levels[levelId] = BoardModel.fromJson(jsonString);
      }

      // Check uniqueness: compare each level with every other level
      final duplicates = <List<String>>[];

      for (int i = 0; i < levelIds.length; i++) {
        for (int j = i + 1; j < levelIds.length; j++) {
          final level1 = levelIds[i];
          final level2 = levelIds[j];
          final board1 = levels[level1]!.board;
          final board2 = levels[level2]!.board;

          // Compare boards row by row
          if (_boardsAreEqual(board1, board2)) {
            duplicates.add([level1, level2]);
          }
        }
      }

      if (duplicates.isNotEmpty) {
        debugPrint('\nFound ${duplicates.length} duplicate level pair(s):');
        for (final pair in duplicates) {
          debugPrint('   • level_${pair[0]}.json == level_${pair[1]}.json');
        }
        debugPrint('');

        final duplicateMessages = duplicates
            .map((pair) => 'level_${pair[0]}.json == level_${pair[1]}.json')
            .join(', ');
        fail('Found duplicate levels: $duplicateMessages');
      }

      // Additional check: all levels should be unique
      expect(duplicates.isEmpty, true, reason: 'All levels should be unique');

      // Print information about the number of checked levels
      debugPrint('✓ Checked ${levelIds.length} levels, all are unique');
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
