import '../../domain/entities/challenge.dart';

class ChallengeModel extends Challenge {
  const ChallengeModel({
    required super.id,
    required super.text,
    required super.type,
    required super.difficulty,
    super.tags,
    super.penalty,
    super.points,
  });

  factory ChallengeModel.fromJson(Map<String, dynamic> json) {
    return ChallengeModel(
      id: json['id'] as String,
      text: json['text'] as String,
      type: ChallengeType.values.firstWhere(
            (e) => e.name == json['type'],
        orElse: () => ChallengeType.fun,
      ),
      difficulty: DifficultyLevel.values.firstWhere(
            (e) => e.name == json['difficulty'],
        orElse: () => DifficultyLevel.easy,
      ),
      tags: List<String>.from(json['tags'] ?? []),
      penalty: json['penalty'] as String?,
      points: json['points'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'type': type.name,
      'difficulty': difficulty.name,
      'tags': tags,
      'penalty': penalty,
      'points': points,
    };
  }

  factory ChallengeModel.fromEntity(Challenge challenge) {
    return ChallengeModel(
      id: challenge.id,
      text: challenge.text,
      type: challenge.type,
      difficulty: challenge.difficulty,
      tags: challenge.tags,
      penalty: challenge.penalty,
      points: challenge.points,
    );
  }

  Challenge toEntity() {
    return Challenge(
      id: id,
      text: text,
      type: type,
      difficulty: difficulty,
      tags: tags,
      penalty: penalty,
      points: points,
    );
  }
}