import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimationService {
  static AnimationService? _instance;
  static AnimationService get instance => _instance ??= AnimationService._();

  AnimationService._();

  // Durées d'animation standards
  static const Duration fastDuration = Duration(milliseconds: 200);
  static const Duration normalDuration = Duration(milliseconds: 300);
  static const Duration slowDuration = Duration(milliseconds: 500);
  static const Duration verySlowDuration = Duration(milliseconds: 800);

  // Courbes d'animation personnalisées
  static const Curve elasticCurve = Curves.elasticOut;
  static const Curve bounceCurve = Curves.bounceOut;
  static const Curve smoothCurve = Curves.easeInOutCubic;

  /// Animation de pulsation pour les boutons
  static Animation<double> createPulseAnimation(AnimationController controller) {
    return Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ));
  }

  /// Animation de rotation
  static Animation<double> createRotationAnimation(AnimationController controller) {
    return Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.linear,
    ));
  }

  /// Animation de scale avec rebond
  static Animation<double> createBounceScaleAnimation(AnimationController controller) {
    return Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.elasticOut,
    ));
  }

  /// Animation de slide depuis le bas
  static Animation<Offset> createSlideFromBottomAnimation(AnimationController controller) {
    return Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ));
  }

  /// Animation de slide depuis la droite
  static Animation<Offset> createSlideFromRightAnimation(AnimationController controller) {
    return Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ));
  }

  /// Animation de fade in
  static Animation<double> createFadeInAnimation(AnimationController controller) {
    return Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeIn,
    ));
  }

  /// Animation de shake (secousse)
  static Animation<double> createShakeAnimation(AnimationController controller) {
    return Tween<double>(
      begin: -10.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.elasticIn,
    ));
  }

  /// Animation de progress bar
  static Animation<double> createProgressAnimation(
      AnimationController controller,
      double target,
      ) {
    return Tween<double>(
      begin: 0.0,
      end: target,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ));
  }

  /// Animation de couleur
  static Animation<Color?> createColorAnimation(
      AnimationController controller,
      Color startColor,
      Color endColor,
      ) {
    return ColorTween(
      begin: startColor,
      end: endColor,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ));
  }

  /// Widget d'animation de rebond
  static Widget createBounceWidget({
    required Widget child,
    required AnimationController controller,
  }) {
    final Animation<double> bounceAnimation = createBounceScaleAnimation(controller);

    return AnimatedBuilder(
      animation: bounceAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: bounceAnimation.value,
          child: child,
        );
      },
      child: child,
    );
  }

  /// Widget d'animation de pulsation
  static Widget createPulseWidget({
    required Widget child,
    required AnimationController controller,
  }) {
    final Animation<double> pulseAnimation = createPulseAnimation(controller);

    return AnimatedBuilder(
      animation: pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: pulseAnimation.value,
          child: child,
        );
      },
      child: child,
    );
  }

  /// Widget d'animation de shake
  static Widget createShakeWidget({
    required Widget child,
    required AnimationController controller,
  }) {
    final Animation<double> shakeAnimation = createShakeAnimation(controller);

    return AnimatedBuilder(
      animation: shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(shakeAnimation.value, 0),
          child: child,
        );
      },
      child: child,
    );
  }

  /// Animation de confetti
  static Widget createConfettiAnimation({
    required Widget child,
    required AnimationController controller,
    required bool isPlaying,
  }) {
    final Animation<double> rotationAnimation = createRotationAnimation(controller);
    final Animation<double> scaleAnimation = createBounceScaleAnimation(controller);

    if (isPlaying) {
      controller.repeat();
    } else {
      controller.stop();
    }

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: rotationAnimation.value,
          child: Transform.scale(
            scale: scaleAnimation.value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  /// Transition personnalisée entre les pages
  static PageRouteBuilder createCustomPageRoute({
    required Widget page,
    RouteSettings? settings,
  }) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  /// Utilitaire pour créer des animations staggerées
  static List<Animation<double>> createStaggeredAnimations({
    required AnimationController controller,
    required int count,
    double interval = 0.1,
  }) {
    final List<Animation<double>> animations = [];

    for (int i = 0; i < count; i++) {
      final start = i * interval;
      final end = math.min(start + 0.5, 1.0);

      animations.add(
        Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(start, end, curve: Curves.easeOut),
          ),
        ),
      );
    }

    return animations;
  }
}