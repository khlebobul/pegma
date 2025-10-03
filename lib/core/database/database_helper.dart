import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('pegma.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Drop old tables and recreate without time_seconds
      await db.execute('DROP TABLE IF EXISTS completed_levels');
      await db.execute('DROP TABLE IF EXISTS saved_games');
      await _createDB(db, newVersion);
    }
  }

  Future<void> _createDB(Database db, int version) async {
    // Table for completed levels
    await db.execute('''
      CREATE TABLE completed_levels (
        level_id INTEGER PRIMARY KEY,
        completed_at TEXT NOT NULL,
        moves_count INTEGER NOT NULL
      )
    ''');

    // Table for saved game states
    await db.execute('''
      CREATE TABLE saved_games (
        level_id INTEGER PRIMARY KEY,
        board_state TEXT NOT NULL,
        moves_count INTEGER NOT NULL,
        saved_at TEXT NOT NULL
      )
    ''');
  }

  // Completed Levels
  Future<void> markLevelCompleted({
    required int levelId,
    required int movesCount,
  }) async {
    final db = await database;
    await db.insert('completed_levels', {
      'level_id': levelId,
      'completed_at': DateTime.now().toIso8601String(),
      'moves_count': movesCount,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<bool> isLevelCompleted(int levelId) async {
    final db = await database;
    final result = await db.query(
      'completed_levels',
      where: 'level_id = ?',
      whereArgs: [levelId],
    );
    return result.isNotEmpty;
  }

  Future<List<int>> getCompletedLevelIds() async {
    final db = await database;
    final result = await db.query('completed_levels');
    return result.map((row) => row['level_id'] as int).toList();
  }

  // Saved Game States
  Future<void> saveGameState({
    required int levelId,
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

  Future<Map<String, dynamic>?> getSavedGameState(int levelId) async {
    final db = await database;
    final result = await db.query(
      'saved_games',
      where: 'level_id = ?',
      whereArgs: [levelId],
    );

    if (result.isEmpty) return null;

    final row = result.first;
    return {
      'board': jsonDecode(row['board_state'] as String) as List<dynamic>,
      'moves_count': row['moves_count'] as int,
    };
  }

  Future<void> deleteSavedGameState(int levelId) async {
    final db = await database;
    await db.delete('saved_games', where: 'level_id = ?', whereArgs: [levelId]);
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
