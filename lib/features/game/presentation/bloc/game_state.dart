import '../../domain/entities/challenge.dart';
import '../../domain/entities/game_result.dart';

enum GameStatus {
  initial,
  loading,
  ready,
  playing,
  showingResult,
  completed,
  error,
}

class GameState {
  final GameStatus status;
  final Challenge? currentChallenge;
  final int currentChallengeIndex;
  final int totalChallenges;
  final List<GameResult> gameHistory;
  final int totalScore;
  final String? currentPenalty;
  final String? successMessage;
  final bool showConfetti;
  final String? errorMessage;
  final Map<String, dynamic> gameStats;
  final ChallengeType? preferredType;
  final DifficultyLevel? preferredDifficulty;

  const GameState({
    this.status = GameStatus.initial,
    this.currentChallenge,
    this.currentChallengeIndex = 0,
    this.totalChallenges = 3,
    this.gameHistory = const [],
    this.totalScore = 0,
    this.currentPenalty,
    this.successMessage,
    this.showConfetti = false,
    this.errorMessage,
    this.gameStats = const {},
    this.preferredType,
    this.preferredDifficulty,
  });

  GameState copyWith({
    GameStatus? status,
    Challenge? currentChallenge,
    int? currentChallengeIndex,
    int? totalChallenges,
    List<GameResult>? gameHistory,
    int? totalScore,
    String? currentPenalty,
    String? successMessage,
    bool? showConfetti,
    String? errorMessage,
    Map<String, dynamic>? gameStats,
    ChallengeType? preferredType,
    DifficultyLevel? preferredDifficulty,
  }) {
    return GameState(
      status: status ?? this.status,
      currentChallenge: currentChallenge ?? this.currentChallenge,
      currentChallengeIndex: currentChallengeIndex ?? this.currentChallengeIndex,
      totalChallenges: totalChallenges ?? this.totalChallenges,
      gameHistory: gameHistory ?? this.gameHistory,
      totalScore: totalScore ?? this.totalScore,
      currentPenalty: currentPenalty ?? this.currentPenalty,
      successMessage: successMessage ?? this.successMessage,
      showConfetti: showConfetti ?? this.showConfetti,
      errorMessage: errorMessage ?? this.errorMessage,
      gameStats: gameStats ?? this.gameStats,
      preferredType: preferredType ?? this.preferredType,
      preferredDifficulty: preferredDifficulty ?? this.preferredDifficulty,
    );
  }

  // Getters utiles
  bool get isGameCompleted => currentChallengeIndex >= totalChallenges;
  bool get isFirstChallenge => currentChallengeIndex == 0;
  bool get isLastChallenge => currentChallengeIndex == totalChallenges - 1;
  double get progress => totalChallenges > 0 ? (currentChallengeIndex + 1) / totalChallenges : 0.0;
  int get completedChallenges => gameHistory.where((r) => r.type == GameResultType.completed).length;
  int get skippedChallenges => gameHistory.where((r) => r.type == GameResultType.skipped).length;
  int get penaltiesAccepted => gameHistory.where((r) => r.type == GameResultType.penalty).length;
  double get successRate => gameHistory.isNotEmpty ? (completedChallenges / gameHistory.length) : 0.0;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GameState &&
        other.status == status &&
        other.currentChallenge == currentChallenge &&
        other.currentChallengeIndex == currentChallengeIndex &&
        other.totalChallenges == totalChallenges &&
        other.totalScore == totalScore &&
        other.showConfetti == showConfetti;
  }

  @override
  int get hashCode {
    return Object.hash(
      status,
      currentChallenge,
      currentChallengeIndex,
      totalChallenges,
      totalScore,
      showConfetti,
    );
  }

  @override
  String toString() {
    return 'GameState(status: $status, currentChallengeIndex: $currentChallengeIndex, totalScore: $totalScore)';
  }
}