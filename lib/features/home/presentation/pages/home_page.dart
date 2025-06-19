import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../core/widgets/animated_button.dart';
import '../../../../shared/data/game_data.dart';
import '../../../game/presentation/pages/game_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        colors: AppColors.homeGradient,
        animated: true,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo/Titre avec animation
              Hero(
                tag: 'title',
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      Text(
                        AppStrings.homeTitle,
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          shadows: [
                            const Shadow(
                              blurRadius: 10.0,
                              color: Colors.black26,
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.3)),
                        ),
                        child: Text(
                          AppStrings.homeSubtitle,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 80),

              // Bouton Jouer avec animation
              SizedBox(
                width: 200,
                child: AnimatedButton(
                  text: AppStrings.playButton,
                  onPressed: () => _navigateToGame(context),
                  backgroundColor: AppColors.white,
                  textColor: AppColors.pink,
                  icon: Icons.play_arrow,
                  pulse: true,
                  height: 60,
                ),
              ),

              const SizedBox(height: 40),

              // Stats
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 60),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  AppStrings.homeStats
                      .replaceAll('{challenges}', '${GameData.challengesCount}')
                      .replaceAll('{penalties}', '${GameData.penaltiesCount}'),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToGame(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, _) => GamePage(),
        transitionDuration: const Duration(milliseconds: 600),
        transitionsBuilder: (context, animation, _, child) {
          return SlideTransition(
            position: animation.drive(
              Tween(begin: const Offset(0.0, 1.0), end: Offset.zero),
            ),
            child: child,
          );
        },
      ),
    );
  }
}