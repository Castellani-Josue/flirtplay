import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class ProgressBar extends StatefulWidget {
  final int currentStep;
  final int totalSteps;
  final Duration animationDuration;
  final bool showStepNumbers;
  final String? currentStepLabel;

  const ProgressBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.animationDuration = const Duration(milliseconds: 800),
    this.showStepNumbers = true,
    this.currentStepLabel,
  });

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _pulseController;
  late Animation<double> _progressAnimation;
  late Animation<double> _pulseAnimation;

  double _previousProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.currentStep / widget.totalSteps,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOutCubic,
    ));

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _progressController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(ProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentStep != widget.currentStep) {
      _previousProgress = oldWidget.currentStep / oldWidget.totalSteps;
      _progressAnimation = Tween<double>(
        begin: _previousProgress,
        end: widget.currentStep / widget.totalSteps,
      ).animate(CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeInOutCubic,
      ));
      _progressController.reset();
      _progressController.forward();
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        children: [
          // Label du step actuel
          if (widget.currentStepLabel != null) ...[
            Text(
              widget.currentStepLabel!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(height: 10),
          ],

          // Barre de progression principale
          Container(
            height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white.withOpacity(0.3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) => LinearProgressIndicator(
                value: _progressAnimation.value,
                backgroundColor: Colors.transparent,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.purple,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          const SizedBox(height: 15),

          // Indicateurs de steps
          if (widget.showStepNumbers) _buildStepIndicators(),

          const SizedBox(height: 10),

          // Texte de progression
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Étape ${widget.currentStep}',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.pink,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${widget.currentStep}/${widget.totalSteps}',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.purple,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(widget.totalSteps, (index) {
        final isCompleted = index < widget.currentStep;
        final isCurrent = index == widget.currentStep - 1;

        return AnimatedBuilder(
          animation: isCurrent ? _pulseAnimation :
          const AlwaysStoppedAnimation(1.0),
          builder: (context, child) => Transform.scale(
            scale: isCurrent ? _pulseAnimation.value : 1.0,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isCompleted || isCurrent
                    ? LinearGradient(
                  colors: [AppColors.purple, AppColors.pink],
                )
                    : null,
                color: isCompleted || isCurrent
                    ? null
                    : Colors.white.withOpacity(0.3),
                border: Border.all(
                  color: isCompleted || isCurrent
                      ? AppColors.purple
                      : Colors.white.withOpacity(0.5),
                  width: 2,
                ),
                boxShadow: isCompleted || isCurrent
                    ? [
                  BoxShadow(
                    color: AppColors.purple.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ]
                    : null,
              ),
              child: Center(
                child: isCompleted
                    ? const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 20,
                )
                    : Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: isCurrent
                        ? Colors.white
                        : AppColors.accent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}