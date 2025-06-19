import 'package:flutter/material.dart';
import 'dart:math';
import '../constants/app_colors.dart';

class ConfettiWidget extends StatefulWidget {
  final bool isPlaying;
  final Widget child;

  const ConfettiWidget({
    Key? key,
    required this.isPlaying,
    required this.child,
  }) : super(key: key);

  @override
  State<ConfettiWidget> createState() => _ConfettiWidgetState();
}

class _ConfettiWidgetState extends State<ConfettiWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(ConfettiWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying && !oldWidget.isPlaying) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.isPlaying)
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return CustomPaint(
                  painter: ConfettiPainter(_animation.value),
                );
              },
            ),
          ),
      ],
    );
  }
}

class ConfettiPainter extends CustomPainter {
  final double progress;
  final Random random = Random(42);

  ConfettiPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (int i = 0; i < 50; i++) {
      final x = random.nextDouble() * size.width;
      final y = -20 + (size.height + 40) * progress + random.nextDouble() * 100;
      final color = AppColors.confettiColors[i % AppColors.confettiColors.length];

      paint.color = color;
      canvas.drawCircle(Offset(x, y), 4, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}