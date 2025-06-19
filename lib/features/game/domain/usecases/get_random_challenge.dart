import '../entities/challenge.dart';
import '../repositories/game_repository.dart';

class GetRandomChallenge {
  final GameRepository repository;

  GetRandomChallenge(this.repository);

  Future<Challenge> call({
    ChallengeType? type,
    DifficultyLevel? difficulty,
  }) async {
    if (type != null && difficulty != null) {
      // Si on a les deux critères, on récupère d'abord par type puis on filtre par difficulté
      final challengesByType = await repository.getChallengesByType(type);
      final filteredChallenges = challengesByType
          .where((challenge) => challenge.difficulty == difficulty)
          .toList();

      if (filteredChallenges.isEmpty) {
        throw Exception('Aucun défi trouvé pour le type $type et la difficulté $difficulty');
      }

      return filteredChallenges[DateTime.now().millisecondsSinceEpoch % filteredChallenges.length];
    } else if (type != null) {
      return await repository.getRandomChallengeByType(type);
    } else if (difficulty != null) {
      return await repository.getRandomChallengeByDifficulty(difficulty);
    } else {
      return await repository.getRandomChallenge();
    }
  }
}