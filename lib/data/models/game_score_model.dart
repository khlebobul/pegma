class GameScore {
  final int score;
  final int level;
  final int moves;
  final DateTime timestamp;

  const GameScore({
    required this.score,
    required this.level,
    required this.moves,
    required this.timestamp,
  });

  GameScore copyWith({
    int? score,
    int? level,
    int? moves,
    DateTime? timestamp,
  }) {
    return GameScore(
      score: score ?? this.score,
      level: level ?? this.level,
      moves: moves ?? this.moves,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GameScore &&
        other.score == score &&
        other.level == level &&
        other.moves == moves &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return score.hashCode ^
        level.hashCode ^
        moves.hashCode ^
        timestamp.hashCode;
  }

  @override
  String toString() {
    return 'GameScore(score: $score, level: $level, moves: $moves, timestamp: $timestamp)';
  }
}
