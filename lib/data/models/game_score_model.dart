class GameScore {
  final int score;
  final int level;
  final int moves;
  final DateTime timestamp;
  final Duration? gameTime;

  const GameScore({
    required this.score,
    required this.level,
    required this.moves,
    required this.timestamp,
    this.gameTime,
  });

  GameScore copyWith({
    int? score,
    int? level,
    int? moves,
    DateTime? timestamp,
    Duration? gameTime,
  }) {
    return GameScore(
      score: score ?? this.score,
      level: level ?? this.level,
      moves: moves ?? this.moves,
      timestamp: timestamp ?? this.timestamp,
      gameTime: gameTime ?? this.gameTime,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GameScore &&
        other.score == score &&
        other.level == level &&
        other.moves == moves &&
        other.timestamp == timestamp &&
        other.gameTime == gameTime;
  }

  @override
  int get hashCode {
    return score.hashCode ^
        level.hashCode ^
        moves.hashCode ^
        timestamp.hashCode ^
        gameTime.hashCode;
  }

  @override
  String toString() {
    return 'GameScore(score: $score, level: $level, moves: $moves, timestamp: $timestamp, gameTime: $gameTime)';
  }

  String get formattedGameTime {
    if (gameTime == null) return 'N/A';
    final totalSeconds = gameTime!.inSeconds;
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString()}:${seconds.toString().padLeft(2, '0')}';
  }
}
