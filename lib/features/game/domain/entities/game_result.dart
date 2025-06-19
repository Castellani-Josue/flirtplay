enum GameResultType {
  completed,
  skipped,
  penalty,
}

class GameResult {
  final String id;
  final String challengeId;
  final GameResultType type;
  final DateTime timestamp;
  final int pointsEarned;
  final String? notes;

  const GameResult({
    required this.id,
    required this.challengeId,
    required this.type,
    required this.timestamp,
    this.pointsEarned = 0,
    this.notes,
  });

  GameResult copyWith({
    String? id,
    String? challengeId,
    GameResultType? type,
    DateTime? timestamp,
    int? pointsEarned,
    String? notes,
  }) {
    return GameResult(
      id: id ?? this.id,
      challengeId: challengeId ?? this.challengeId,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      pointsEarned: pointsEarned ?? this.pointsEarned,
      notes: notes ?? this.notes,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GameResult && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'GameResult(id: $id, challengeId: $challengeId, type: $type, pointsEarned: $pointsEarned)';
  }
}