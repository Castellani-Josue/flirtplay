import '../../domain/entities/game_result.dart';

class GameResultModel extends GameResult {
  const GameResultModel({
    required super.id,
    required super.challengeId,
    required super.type,
    required super.timestamp,
    super.pointsEarned,
    super.notes,
  });

  factory GameResultModel.fromJson(Map<String, dynamic> json) {
    return GameResultModel(
      id: json['id'] as String,
      challengeId: json['challengeId'] as String,
      type: GameResultType.values.firstWhere(
            (e) => e.name == json['type'],
        orElse: () => GameResultType.completed,
      ),
      timestamp: DateTime.parse(json['timestamp'] as String),
      pointsEarned: json['pointsEarned'] as int? ?? 0,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'challengeId': challengeId,
      'type': type.name,
      'timestamp': timestamp.toIso8601String(),
      'pointsEarned': pointsEarned,
      'notes': notes,
    };
  }

  factory GameResultModel.fromEntity(GameResult result) {
    return GameResultModel(
      id: result.id,
      challengeId: result.challengeId,
      type: result.type,
      timestamp: result.timestamp,
      pointsEarned: result.pointsEarned,
      notes: result.notes,
    );
  }

  GameResult toEntity() {
    return GameResult(
      id: id,
      challengeId: challengeId,
      type: type,
      timestamp: timestamp,
      pointsEarned: pointsEarned,
      notes: notes,
    );
  }
}