import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/challenge.dart';

class ChallengeCard extends StatefulWidget {
  final Challenge challenge;
  final int currentIndex;
  final int totalChallenges;
  final bool isVisible;

  const ChallengeCard({
    super.key,
    required this.challenge,
    required this.currentIndex,
    required this.totalChallenges,
    this.isVisible = true,
  });

  @override
  State<ChallengeCard> createState() => _ChallengeCardState();
}

class _ChallengeCardState extends State<ChallengeCard>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeIn),
    );

    if (widget.isVisible) {
      _slideController.forward();
      _scaleController.forward();
    }
  }

  @override
  void didUpdateWidget(ChallengeCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      _slideController.forward();
      _scaleController.forward();
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_slideAnimation, _scaleAnimation, _fadeAnimation]),
      builder: (context, child) => SlideTransition(
        position: _slideAnimation,
        child: Transform.scale(
          scale: _scaleAnimation.value,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                elevation: 20,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.deepPurple,
                        AppColors.deepPurple.withOpacity(0.9),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.purple.withOpacity(0.2),
                        blurRadius: 20,
                        spreadRadius: 2,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header avec numéro du défi
                        _buildHeader(),
                        const SizedBox(height: 25),

                        // Icône du défi
                        _buildChallengeIcon(),
                        const SizedBox(height: 25),

                        // Titre du défi
                        _buildChallengeTitle(),
                        const SizedBox(height: 20),

                        // Description du défi
                        _buildChallengeDescription(),
                        const SizedBox(height: 25),

                        // Difficulté
                        _buildDifficultyIndicator(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.purple, AppColors.pink],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Défi ${widget.currentIndex + 1}/${widget.totalChallenges}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.accent.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(
            Icons.emoji_events,
            color: AppColors.accent,
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildChallengeIcon() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.purple.withOpacity(0.2), AppColors.pink.withOpacity(0.2)],
        ),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Icon(
        _getChallengeIcon(),
        size: 40,
        color: AppColors.purple,
      ),
    );
  }

  Widget _buildChallengeTitle() {
    return Text(
      widget.challenge.text ,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.accent,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildChallengeDescription() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: AppColors.purple.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        widget.challenge.text,
        style: TextStyle(
          fontSize: 18,
          color: AppColors.pink,
          height: 1.4,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDifficultyIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Difficulté: ',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.pink,
            fontWeight: FontWeight.w500,
          ),
        ),
        ...List.generate(3, (index) => Container(
          margin: const EdgeInsets.only(left: 4),
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: index < widget.challenge.difficulty.index
                ? AppColors.accent
                : AppColors.accent.withOpacity(0.3),
            borderRadius: BorderRadius.circular(6),
          ),
        )),
      ],
    );
  }

  IconData _getChallengeIcon() {
    switch (widget.challenge.type) {
      case ChallengeType.truth:
        return Icons.chat_bubble_outline;
      case ChallengeType.fun:
        return Icons.sentiment_satisfied_alt;
      case ChallengeType.couple:
        return Icons.favorite_border;
      case ChallengeType.dare:
        return Icons.local_fire_department;
      default:
        return Icons.star_outline;
    }
  }
}