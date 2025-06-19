import 'dart:math';
import '../../../../shared/data/game_data.dart';
import '../../domain/entities/challenge.dart';
import '../../domain/entities/game_result.dart';
import '../../domain/repositories/game_repository.dart';
import '../models/challenge_model.dart';

class GameRepositoryImpl implements GameRepository {
  final List<GameResult> _gameHistory = [];
  final Random _random = Random();

  GameRepositoryImpl();

  @override
  Future<List<Challenge>> getAllChallenges() async {
    return GameData.challenges.map((data) =>
        ChallengeModel.fromJson(data as Map<String, dynamic>).toEntity()
    ).toList();
  }

  @override
  Future<List<Challenge>> getChallengesByType(ChallengeType type) async {
    final challenges = await getAllChallenges();
    return challenges.where((challenge) => challenge.type == type).toList();
  }

  @override
  Future<List<Challenge>> getChallengesByDifficulty(DifficultyLevel difficulty) async {
    final challenges = await getAllChallenges();
    return challenges.where((challenge) => challenge.difficulty == difficulty).toList();
  }

  @override
  Future<Challenge> getRandomChallenge() async {
    final challenges = await getAllChallenges();
    if (challenges.isEmpty) {
      throw Exception('Aucun défi disponible');
    }
    return challenges[_random.nextInt(challenges.length)];
  }

  @override
  Future<Challenge> getRandomChallengeByType(ChallengeType type) async {
    final challenges = await getChallengesByType(type);
    if (challenges.isEmpty) {
      throw Exception('Aucun défi disponible pour le type $type');
    }
    return challenges[_random.nextInt(challenges.length)];
  }

  @override
  Future<Challenge> getRandomChallengeByDifficulty(DifficultyLevel difficulty) async {
    final challenges = await getChallengesByDifficulty(difficulty);
    if (challenges.isEmpty) {
      throw Exception('Aucun défi disponible pour la difficulté $difficulty');
    }
    return challenges[_random.nextInt(challenges.length)];
  }

  @override
  Future<String> getRandomPenalty() async {
    final penalties = GameData.penalties;
    if (penalties.isEmpty) {
      return 'Aucun gage disponible';
    }
    return penalties[_random.nextInt(penalties.length)];
  }

  @override
  Future<void> saveGameResult(GameResult result) async {
    _gameHistory.add(result);
  }

  @override
  Future<List<GameResult>> getGameHistory() async {
    return List.from(_gameHistory);
  }

  @override
  Future<int> getTotalScore() async {
    int total = 0;
    for (final result in _gameHistory.where((r) => r.type == GameResultType.completed)) {
      final points = result.pointsEarned;
      total += points;
    }
    return total;
  }


  @override
  Future<Map<String, dynamic>> getGameStats() async {
    final completed = _gameHistory.where((r) => r.type == GameResultType.completed).length;
    final skipped = _gameHistory.where((r) => r.type == GameResultType.skipped).length;
    final penalties = _gameHistory.where((r) => r.type == GameResultType.penalty).length;
    final totalScore = await getTotalScore();

    return {
      'totalChallenges': _gameHistory.length,
      'completed': completed,
      'skipped': skipped,
      'penalties': penalties,
      'totalScore': totalScore,
      'completionRate': _gameHistory.isNotEmpty ? (completed / _gameHistory.length * 100).round() : 0,
    };
  }
}