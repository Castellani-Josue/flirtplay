import 'package:flutter/material.dart';

class AppColors {
  // Couleurs principales
  static const Color purple = Color(0xFF9C27B0);
  static const Color pink = Color(0xFFE91E63);
  static const Color orange = Color(0xFFFF9800);
  static const Color deepPurple = Color(0xFF673AB7);

  // Couleurs pour les gradients
  static const List<Color> homeGradient = [
    Color(0xFF9C27B0), // purple[400]
    Color(0xFFE91E63), // pink[400]
    Color(0xFFFF9800), // orange[400]
  ];

  static const List<Color> gameGradient = [
    Color(0xFF673AB7), // deepPurple[400]
    Color(0xFFE91E63), // pink[400]
    Color(0xFFFFCC80), // orange[300]
  ];

  // Couleurs d'état
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFF9800);

  // Couleurs neutres
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey600 = Color(0xFF757575);
  static const Color grey800 = Color(0xFF424242);

  // Couleurs pour confettis
  static const List<Color> confettiColors = [
    pink,
    orange,
    purple,
    Color(0xFFFFEB3B), // yellow
  ];
}