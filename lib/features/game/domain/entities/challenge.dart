enum ChallengeType {
  truth,
  dare,
  couple,
  fun,
}

enum DifficultyLevel {
  easy,
  medium,
  hard,
  spicy,
}

class Challenge {
  final String id;
  final String text;
  final ChallengeType type;
  final DifficultyLevel difficulty;
  final List<String> tags;
  final String? penalty; // Gage si le défi n'est pas relevé
  final int points;

  const Challenge({
    required this.id,
    required this.text,
    required this.type,
    required this.difficulty,
    this.tags = const [],
    this.penalty,
    this.points = 1,
  });

  Challenge copyWith({
    String? id,
    String? text,
    ChallengeType? type,
    DifficultyLevel? difficulty,
    List<String>? tags,
    String? penalty,
    int? points,
  }) {
    return Challenge(
      id: id ?? this.id,
      text: text ?? this.text,
      type: type ?? this.type,
      difficulty: difficulty ?? this.difficulty,
      tags: tags ?? this.tags,
      penalty: penalty ?? this.penalty,
      points: points ?? this.points,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Challenge && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Challenge(id: $id, text: $text, type: $type, difficulty: $difficulty)';
  }
}