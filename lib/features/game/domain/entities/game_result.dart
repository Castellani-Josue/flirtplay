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
  final String penaltyMessage;
  final String rewardMessage;
  final bool isSuccess;
  final String message;

  const GameResult({
    required this.id,
    required this.challengeId,
    required this.type,
    required this.timestamp,
    this.pointsEarned = 0,
    this.notes, this.penaltyMessage = '',
    this.rewardMessage = '',
    this.isSuccess = false,
    this.message = '',
  });

  get successCount => null;

  get totalScore => null;

  GameResult copyWith({
    String? id,
    String? challengeId,
    GameResultType? type,
    DateTime? timestamp,
    int? pointsEarned,
    String? notes,
    String? penaltyMessage,
    String? rewardMessage,
    bool? isSuccess,
    String? message,
    
  }) {
    return GameResult(
      id: id ?? this.id,
      challengeId: challengeId ?? this.challengeId,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      pointsEarned: pointsEarned ?? this.pointsEarned,
      notes: notes ?? this.notes,
      penaltyMessage: penaltyMessage ?? this.penaltyMessage,
      rewardMessage: rewardMessage ?? this.rewardMessage,
      isSuccess: isSuccess ?? this.isSuccess,
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
    return 'GameResult(id: $id, challengeId: $challengeId, type: $type, pointsEarned: $pointsEarned,'
        'penaltyMessage: $penaltyMessage, rewardMessage: $rewardMessage, '
        'isSuccess: $isSuccess, timestamp: $timestamp, notes: $notes, message: $message)';
  }
}