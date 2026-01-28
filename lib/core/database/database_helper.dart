import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  static Future<Database>? _initFuture;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    // Prevent race conditions by reusing the same initialization future
    _initFuture ??= _initDB('pegma.db');
    _database = await _initFuture;
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 6,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('DROP TABLE IF EXISTS completed_levels');
      await db.execute('DROP TABLE IF EXISTS saved_games');
      await _createDB(db, newVersion);
      return;
    }

    if (oldVersion < 3) {
      await db.delete('saved_games');
    }
    
    if (oldVersion < 4) {
      await db.execute('DROP TABLE IF EXISTS saved_games');
      await db.execute('''
        CREATE TABLE saved_games (
          level_id INTEGER PRIMARY KEY,
          board_state TEXT NOT NULL,
          moves_count INTEGER NOT NULL,
          saved_at TEXT NOT NULL
        )
      ''');
    }

    if (oldVersion < 5) {
      // Delete saved games for levels that were modified (10, 45, 48)
      // This fixes incompatibility issues while preserving completed level progress
      await db.delete(
        'saved_games',
        where: 'level_id IN (?, ?, ?)',
        whereArgs: [10, 45, 48],
      );
    }

    if (oldVersion < 6) {
      // Migrate level_id from INTEGER to TEXT to support fractional levels (0.1, 0.2, etc.)
      // Also migrate level 0 to 0.1 for users who already completed it

      // Create new tables with TEXT level_id
      await db.execute('''
        CREATE TABLE completed_levels_new (
          level_id TEXT PRIMARY KEY,
          completed_at TEXT NOT NULL,
          moves_count INTEGER NOT NULL
        )
      ''');

      await db.execute('''
        CREATE TABLE saved_games_new (
          level_id TEXT PRIMARY KEY,
          board_state TEXT NOT NULL,
          moves_count INTEGER NOT NULL,
          saved_at TEXT NOT NULL
        )
      ''');

      // Migrate data, converting level 0 to 0.1
      await db.execute('''
        INSERT INTO completed_levels_new (level_id, completed_at, moves_count)
        SELECT CASE WHEN level_id = 0 THEN '0.1' ELSE CAST(level_id AS TEXT) END,
               completed_at, moves_count
        FROM completed_levels
      ''');

      await db.execute('''
        INSERT INTO saved_games_new (level_id, board_state, moves_count, saved_at)
        SELECT CASE WHEN level_id = 0 THEN '0.1' ELSE CAST(level_id AS TEXT) END,
               board_state, moves_count, saved_at
        FROM saved_games
      ''');

      // Drop old tables and rename new ones
      await db.execute('DROP TABLE completed_levels');
      await db.execute('DROP TABLE saved_games');
      await db.execute('ALTER TABLE completed_levels_new RENAME TO completed_levels');
      await db.execute('ALTER TABLE saved_games_new RENAME TO saved_games');
    }
  }

  Future<void> _createDB(Database db, int version) async {
    // Table for completed levels
    await db.execute('''
      CREATE TABLE completed_levels (
        level_id TEXT PRIMARY KEY,
        completed_at TEXT NOT NULL,
        moves_count INTEGER NOT NULL
      )
    ''');

    // Table for saved game states
    await db.execute('''
      CREATE TABLE saved_games (
        level_id TEXT PRIMARY KEY,
        board_state TEXT NOT NULL,
        moves_count INTEGER NOT NULL,
        saved_at TEXT NOT NULL
      )
    ''');
  }

  // Completed Levels
  Future<void> markLevelCompleted({
    required String levelId,
    required int movesCount,
  }) async {
    final db = await database;
    await db.insert('completed_levels', {
      'level_id': levelId,
      'completed_at': DateTime.now().toIso8601String(),
      'moves_count': movesCount,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<bool> isLevelCompleted(String levelId) async {
    final db = await database;
    final result = await db.query(
      'completed_levels',
      where: 'level_id = ?',
      whereArgs: [levelId],
    );
    return result.isNotEmpty;
  }

  Future<List<String>> getCompletedLevelIds() async {
    final db = await database;
    final result = await db.query('completed_levels');
    return result.map((row) => row['level_id'] as String).toList();
  }

  // Saved Game States
  Future<void> saveGameState({
    required String levelId,
    required List<List<String>> board,
    required int movesCount,
  }) async {
    final db = await database;
    await db.insert('saved_games', {
      'level_id': levelId,
      'board_state': jsonEncode(board),
      'moves_count': movesCount,
      'saved_at': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, dynamic>?> getSavedGameState(String levelId) async {
    final db = await database;
    final result = await db.query(
      'saved_games',
      where: 'level_id = ?',
      whereArgs: [levelId],
    );

    if (result.isEmpty) return null;

    try {
      final row = result.first;
      final boardData = jsonDecode(row['board_state'] as String) as List<dynamic>;

      // Validate board structure
      if (boardData.isEmpty || boardData.first is! List) {
        // Invalid board structure, delete corrupted save
        await deleteSavedGameState(levelId);
        return null;
      }

      return {
        'board': boardData,
        'moves_count': row['moves_count'] as int,
      };
    } catch (e) {
      // If decoding fails, delete corrupted save and return null
      await deleteSavedGameState(levelId);
      return null;
    }
  }

  Future<void> deleteSavedGameState(String levelId) async {
    final db = await database;
    await db.delete('saved_games', where: 'level_id = ?', whereArgs: [levelId]);
  }

  Future<void> clearAllSavedGames() async {
    final db = await database;
    await db.delete('saved_games');
  }

  /// Clear saved games for specific levels (useful after level modifications)
  Future<void> clearSavedGamesForLevels(List<String> levelIds) async {
    if (levelIds.isEmpty) return;
    final db = await database;
    final placeholders = List.filled(levelIds.length, '?').join(',');
    await db.delete(
      'saved_games',
      where: 'level_id IN ($placeholders)',
      whereArgs: levelIds,
    );
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
