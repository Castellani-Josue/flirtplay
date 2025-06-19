import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class GradientBackground extends StatefulWidget {
  final Widget child;
  final List<Color> colors;
  final bool animated;

  const GradientBackground({
    Key? key,
    required this.child,
    this.colors = AppColors.homeGradient,
    this.animated = false,
  }) : super(key: key);

  @override
  State<GradientBackground> createState() => _GradientBackgroundState();
}

class _GradientBackgroundState extends State<GradientBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    if (widget.animated) {
      _controller = AnimationController(
        duration: const Duration(seconds: 4),
        vsync: this,
      )..repeat();

      _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.linear),
      );
    }
  }

  @override
  void dispose() {
    if (widget.animated) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.animated) {
      return AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(widget.colors[0], widget.colors[1], _animation.value)!,
                  Color.lerp(widget.colors[1], widget.colors[2], _animation.value)!,
                  Color.lerp(widget.colors[2], widget.colors[0], _animation.value)!,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: widget.child,
          );
        },
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: widget.colors,
        ),
      ),
      child: widget.child,
    );
  }
}