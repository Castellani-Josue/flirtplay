import '../entities/challenge.dart';
import '../entities/game_result.dart';

abstract class GameRepository {
  /// Récupère tous les défis disponibles
  Future<List<Challenge>> getAllChallenges();

  /// Récupère les défis par type
  Future<List<Challenge>> getChallengesByType(ChallengeType type);

  /// Récupère les défis par niveau de difficulté
  Future<List<Challenge>> getChallengesByDifficulty(DifficultyLevel difficulty);

  /// Récupère un défi aléatoire
  Future<Challenge> getRandomChallenge();

  /// Récupère un défi aléatoire par type
  Future<Challenge> getRandomChallengeByType(ChallengeType type);

  /// Récupère un défi aléatoire par difficulté
  Future<Challenge> getRandomChallengeByDifficulty(DifficultyLevel difficulty);

  /// Récupère un gage aléatoire
  Future<String> getRandomPenalty();

  /// Sauvegarde le résultat d'un défi
  Future<void> saveGameResult(GameResult result);

  /// Récupère l'historique des résultats
  Future<List<GameResult>> getGameHistory();

  /// Calcule le score total
  Future<int> getTotalScore();

  /// Récupère les statistiques de jeu
  Future<Map<String, dynamic>> getGameStats();
}