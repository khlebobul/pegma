import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Utility class for persisting game data
class GamePersistence {
  static const String _keyGameTime = 'game_time';
  static const String _keyGameState = 'game_state';
  static const String _keyGameLevel = 'game_level';
  static const String _keyGameMoves = 'game_moves';
  static const String _keyGameScore = 'game_score';

  /// Save current game time (in seconds)
  static Future<void> saveGameTime(Duration gameTime) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyGameTime, gameTime.inSeconds);
  }

  /// Load saved game time
  static Future<Duration?> loadGameTime() async {
    final prefs = await SharedPreferences.getInstance();
    final seconds = prefs.getInt(_keyGameTime);
    return seconds != null ? Duration(seconds: seconds) : null;
  }

  /// Save complete game state for resuming
  static Future<void> saveGameState({
    required Duration gameTime,
    required int level,
    required int moves,
    required int score,
    Map<String, dynamic>? additionalData,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final gameStateData = {
      'gameTime': gameTime.inSeconds,
      'level': level,
      'moves': moves,
      'score': score,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      if (additionalData != null) ...additionalData,
    };

    await prefs.setString(_keyGameState, jsonEncode(gameStateData));
  }

  /// Load saved game state
  static Future<Map<String, dynamic>?> loadGameState() async {
    final prefs = await SharedPreferences.getInstance();
    final gameStateJson = prefs.getString(_keyGameState);

    if (gameStateJson != null) {
      try {
        return jsonDecode(gameStateJson) as Map<String, dynamic>;
      } catch (e) {
        // Handle corrupted data
        await clearGameState();
        return null;
      }
    }
    return null;
  }

  /// Clear saved game state (when game is completed or reset)
  static Future<void> clearGameState() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.remove(_keyGameTime),
      prefs.remove(_keyGameState),
      prefs.remove(_keyGameLevel),
      prefs.remove(_keyGameMoves),
      prefs.remove(_keyGameScore),
    ]);
  }

  /// Check if there's a saved game that can be resumed
  static Future<bool> hasSavedGame() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_keyGameState);
  }

  /// Get the timestamp of the last saved game
  static Future<DateTime?> getLastSaveTimestamp() async {
    final gameState = await loadGameState();
    if (gameState != null && gameState['timestamp'] != null) {
      return DateTime.fromMillisecondsSinceEpoch(gameState['timestamp'] as int);
    }
    return null;
  }
}
