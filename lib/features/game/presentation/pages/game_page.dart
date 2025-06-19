import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../core/widgets/confetti_widget.dart';
import '../../../../shared/data/game_data.dart';




class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with TickerProviderStateMixin {
  int currentChallengeIndex = 0;
  int totalChallenges = 3;
  bool isShowingResult = false;
  bool hasSucceeded = false;
  String currentChallenge = '';
  String resultMessage = '';
  bool showConfetti = false;

  late AnimationController _cardController;
  late Animation<double> _cardAnimation;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _cardAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.elasticOut),
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));

    _generateNewChallenge();
  }

  @override
  void dispose() {
    _cardController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _generateNewChallenge() {
    setState(() {
      currentChallenge = GameData.getRandomChallenge();
      isShowingResult = false;
      showConfetti = false;
    });
    _cardController.forward(from: 0);
  }

  void _handleSuccess() {
    setState(() {
      hasSucceeded = true;
      resultMessage = GameData.getRandomSuccessMessage();
      isShowingResult = true;
      showConfetti = true;
    });
    _slideController.forward(from: 0);
  }

  void _handleFailure() {
    setState(() {
      hasSucceeded = false;
      resultMessage = GameData.getRandomPenalty();
      isShowingResult = true;
      showConfetti = false;
    });
    _slideController.forward(from: 0);
  }

  void _nextChallenge() {
    if (currentChallengeIndex < totalChallenges - 1) {
      setState(() {
        currentChallengeIndex++;
      });
      _slideController.reverse().then((_) {
        _generateNewChallenge();
      });
    } else {
      _showGameComplete();
    }
  }

  void _showGameComplete() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          '🎉 Jeu terminé !',
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        content: const Text(
          'Félicitations ! Vous avez terminé tous les défis.',
          style: TextStyle(color: Colors.white70),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text(
              'Retour à l\'accueil',
              style: TextStyle(color: AppColors.accent),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        colors: AppColors.gameGradient,
        child: SafeArea(
          child: ConfettiWidget(
            isPlaying: showConfetti,
            child: Column(
              children: [
                // Header avec progression
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                          ),
                          Text(
                            AppStrings.challengeProgress
                                .replaceAll('{current}', '${currentChallengeIndex + 1}')
                                .replaceAll('{total}', '$totalChallenges'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 48),
                        ],
                      ),
                      const SizedBox(height: 15),
                      GameProgressBar(
                        current: currentChallengeIndex + 1,
                        total: totalChallenges,
                      ),
                    ],
                  ),
                ),

                // Contenu principal
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Carte du défi/résultat
                        AnimatedBuilder(
                          animation: _cardAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _cardAnimation.value,
                              child: isShowingResult
                                  ? SlideTransition(
                                position: _slideAnimation,
                                child: ResultCard(
                                  message: resultMessage,
                                  isSuccess: hasSucceeded,
                                ),
                              )
                                  : ChallengeCard(
                                challenge: currentChallenge,
                                challengeNumber: currentChallengeIndex + 1,
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 40),

                        // Boutons d'action
                        if (!isShowingResult)
                          ActionButtons(
                            onSuccess: _handleSuccess,
                            onFailure: _handleFailure,
                          )
                        else
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: ElevatedButton(
                              onPressed: _nextChallenge,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.accent,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 4,
                              ),
                              child: Text(
                                currentChallengeIndex < totalChallenges - 1
                                    ? 'Défi suivant'
                                    : 'Terminer',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // Footer avec conseils
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    isShowingResult
                        ? 'Appuyez sur "Défi suivant" pour continuer'
                        : 'Relevez le défi ou acceptez le gage !',
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}