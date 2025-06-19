import '../repositories/game_repository.dart';

class GetRandomPenalty {
  final GameRepository repository;

  GetRandomPenalty(this.repository);

  Future<String> call() async {
    return await repository.getRandomPenalty();
  }
}