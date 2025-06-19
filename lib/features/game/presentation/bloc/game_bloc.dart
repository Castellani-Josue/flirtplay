import 'dart:async';
import 'dart:math';
import '../../domain/entities/challenge.dart';
import '../../domain/entities/game_result.dart';
import '../../domain/usecases/get_random_challenge.dart';
import '../../domain/usecases/get_random_penalty.dart';
import '../../domain/repositories/game_repository.dart';
import 'game_event.dart';
import 'game_state.dart';

class GameBloc {
  final GameRepository _gameRepository;
  final GetRandomChallenge _getRandomChallenge;
  final GetRandomPenalty _getRandomPenalty;

  GameState _state = const GameState();
  final StreamController<GameState> _stateController = StreamController<GameState>.broadcast();

  Stream<GameState> get stream => _stateController.stream;
  GameState get state => _state;

  // Messages de succès prédéfinis
  final List<String> _successMessages = [
    '🎉 Excellent ! Vous avez relevé le défi !',
    '👏 Bravo ! C\'était parfait !',
    '🔥 Incroyable ! Vous êtes en feu !',
    '💫 Fantastique ! Continue comme ça !',
    '✨ Magnifique ! Vous formez une super équipe !',
    '🌟 Superbe ! Vous avez assuré !',
    '💪 Génial ! Rien ne vous arrête !',
  ];

  GameBloc({
    required GameRepository gameRepository,
    required GetRandomChallenge getRandomChallenge,
    required GetRandomPenalty getRandomPenalty,
  })  : _gameRepository = gameRepository,
        _getRandomChallenge = getRandomChallenge,
        _getRandomPenalty = getRandomPenalty;

  void add(GameEvent event) {
    switch (event) {
      case GameStarted():
        _handleGameStarted(event);
        break;
      case ChallengeGenerated():
        _handleChallengeGenerated();
        break;
      case ChallengeCompleted():
        _handleChallengeCompleted(event);
        break;
      case ChallengeSkipped():
        _handleChallengeSkipped();
        break;
      case PenaltyAccepted():
        _handlePenaltyAccepted();
        break;
      case NextChallengeRequested():
        _handleNextChallengeRequested();
        break;
      case GameReset():
        _handleGameReset();
        break;
      case GameEnded():
        _handleGameEnded();
        break;
      case GameStatsRequested():
        _handleGameStatsRequested();
        break;
      case GameSettingsChanged():
        _handleGameSettingsChanged(event);
        break;
    }
  }

  void _emit(GameState newState) {
    _state = newState;
    _stateController.add(_state);
  }

  Future<void> _handleGameStarted(GameStarted event) async {
    _emit(_state.copyWith(status: GameStatus.loading));

    try {
      _emit(_state.copyWith(
        status: GameStatus.ready,
        totalChallenges: event.totalChallenges,
        currentChallengeIndex: 0,
        gameHistory: [],
        totalScore: 0,
        preferredType: event.preferredType,
        preferredDifficulty: event.preferredDifficulty,
      ));

      add(const ChallengeGenerated());
    } catch (e) {
      _emit(_state.copyWith(
        status: GameStatus.error,
        errorMessage: 'Erreur lors du démarrage du jeu: $e',
      ));
    }
  }

  Future<void> _handleChallengeGenerated() async {
    _emit(_state.copyWith(status: GameStatus.loading));

    try {
      final challenge = await _getRandomChallenge(
        type: _state.preferredType,
        difficulty: _state.preferredDifficulty,
      );

      _emit(_state.copyWith(
        status: GameStatus.playing,
        currentChallenge: challenge,
        showConfetti: false,
        successMessage: null,
        currentPenalty: null,
        errorMessage: null,
      ));
    } catch (e) {
      _emit(_state.copyWith(
        status: GameStatus.error,
        errorMessage: 'Erreur lors de la génération du défi: $e',
      ));
    }
  }

  Future<void> _handleChallengeCompleted(ChallengeCompleted event) async {
    if (_state.currentChallenge == null) return;

    try {
      final result = GameResult(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        challengeId: _state.currentChallenge!.id,
        type: GameResultType.completed,
        timestamp: DateTime.now(),
        pointsEarned: _state.currentChallenge!.points,
        notes: event.notes,
      );

      await _gameRepository.saveGameResult(result);

      final updatedHistory = [..._state.gameHistory, result];
      final newScore = _state.totalScore + _state.currentChallenge!.points;
      final successMessage = _getRandomSuccessMessage();

      _emit(_state.copyWith(
        status: GameStatus.showingResult,
        gameHistory: updatedHistory,
        totalScore: newScore,
        successMessage: successMessage,
        showConfetti: true,
      ));
    } catch (e) {
      _emit(_state.copyWith(
        status: GameStatus.error,
        errorMessage: 'Erreur lors de la sauvegarde: $e',
      ));
    }
  }

  Future<void> _handleChallengeSkipped() async {
    if (_state.currentChallenge == null) return;

    try {
      // Générer un gage aléatoire
      final penalty = await _getRandomPenalty();

      _emit(_state.copyWith(
        status: GameStatus.showingResult,
        currentPenalty: penalty,
        showConfetti: false,
      ));
    } catch (e) {
      _emit(_state.copyWith(
        status: GameStatus.error,
        errorMessage: 'Erreur lors de la génération du gage: $e',
      ));
    }
  }

  Future<void> _handlePenaltyAccepted() async {
    if (_state.currentChallenge == null) return;

    try {
      final result = GameResult(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        challengeId: _state.currentChallenge!.id,
        type: GameResultType.penalty,
        timestamp: DateTime.now(),
        pointsEarned: 0,
      );

      await _gameRepository.saveGameResult(result);

      final updatedHistory = [..._state.gameHistory, result];

      _emit(_state.copyWith(
        gameHistory: updatedHistory,
      ));

      add(const NextChallengeRequested());
    } catch (e) {
      _emit(_state.copyWith(
        status: GameStatus.error,
        errorMessage: 'Erreur lors de la sauvegarde du gage: $e',
      ));
    }
  }

  void _handleNextChallengeRequested() {
    final nextIndex = _state.currentChallengeIndex + 1;

    if (nextIndex >= _state.totalChallenges) {
      add(const GameEnded());
    } else {
      _emit(_state.copyWith(
        currentChallengeIndex: nextIndex,
        status: GameStatus.ready,
      ));
      add(const ChallengeGenerated());
    }
  }

  Future<void> _handleGameEnded() async {
    try {
      final stats = await _gameRepository.getGameStats();

      _emit(_state.copyWith(
        status: GameStatus.completed,
        gameStats: stats,
        showConfetti: _state.completedChallenges > _state.skippedChallenges,
      ));
    } catch (e) {
      _emit(_state.copyWith(
        status: GameStatus.error,
        errorMessage: 'Erreur lors du calcul des statistiques: $e',
      ));
    }
  }

  void _handleGameReset() {
    _emit(const GameState());
  }

  Future<void> _handleGameStatsRequested() async {
    try {
      final stats = await _gameRepository.getGameStats();
      _emit(_state.copyWith(gameStats: stats));
    } catch (e) {
      _emit(_state.copyWith(
        status: GameStatus.error,
        errorMessage: 'Erreur lors du chargement des statistiques: $e',
      ));
    }
  }

  void _handleGameSettingsChanged(GameSettingsChanged event) {
    _emit(_state.copyWith(
      preferredType: event.newType ?? _state.preferredType,
      preferredDifficulty: event.newDifficulty ?? _state.preferredDifficulty,
    ));
  }

  String _getRandomSuccessMessage() {
    final random = Random();
    return _successMessages[random.nextInt(_successMessages.length)];
  }

  void dispose() {
    _stateController.close();
  }
}