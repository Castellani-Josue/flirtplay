import '../../domain/entities/challenge.dart';

abstract class GameEvent {
  const GameEvent();
}

class GameStarted extends GameEvent {
  final int totalChallenges;
  final ChallengeType? preferredType;
  final DifficultyLevel? preferredDifficulty;

  const GameStarted({
    this.totalChallenges = 3,
    this.preferredType,
    this.preferredDifficulty,
  });
}

class ChallengeGenerated extends GameEvent {
  const ChallengeGenerated();
}

class ChallengeCompleted extends GameEvent {
  final bool wasSuccessful;
  final String? notes;

  const ChallengeCompleted({
    required this.wasSuccessful,
    this.notes,
  });
}

class ChallengeSkipped extends GameEvent {
  const ChallengeSkipped();
}

class PenaltyAccepted extends GameEvent {
  const PenaltyAccepted();
}

class NextChallengeRequested extends GameEvent {
  const NextChallengeRequested();
}

class GameReset extends GameEvent {
  const GameReset();
}

class GameEnded extends GameEvent {
  const GameEnded();
}

class GameStatsRequested extends GameEvent {
  const GameStatsRequested();
}

class GameSettingsChanged extends GameEvent {
  final ChallengeType? newType;
  final DifficultyLevel? newDifficulty;

  const GameSettingsChanged({
    this.newType,
    this.newDifficulty,
  });
}