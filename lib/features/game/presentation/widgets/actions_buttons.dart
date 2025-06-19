import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';


class ActionButtons extends StatefulWidget {
  final VoidCallback onSuccess;
  final VoidCallback onFailure;
  final bool isEnabled;
  final String successText;
  final String failureText;

  const ActionButtons({
    super.key,
    required this.onSuccess,
    required this.onFailure,
    this.isEnabled = true,
    this.successText = "C'est fait ✅",
    this.failureText = "J'ai échoué ❌",
  });

  @override
  State<ActionButtons> createState() => _ActionButtonsState();
}

class _ActionButtonsState extends State<ActionButtons>
    with TickerProviderStateMixin {
  late AnimationController _successController;
  late AnimationController _failureController;
  late Animation<double> _successScale;
  late Animation<double> _failureScale;

  @override
  void initState() {
    super.initState();
    _successController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _failureController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _successScale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _successController, curve: Curves.easeInOut),
    );
    _failureScale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _failureController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _successController.dispose();
    _failureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Row(
        children: [
          // Bouton Échec
          Expanded(
            child: AnimatedBuilder(
              animation: _failureScale,
              builder: (context, child) => Transform.scale(
                scale: _failureScale.value,
                child: _buildButton(
                  text: widget.failureText,
                  colors: [Colors.red.shade400, Colors.red.shade600],
                  onPressed: widget.isEnabled
                      ? () => _handleButtonPress(_failureController, widget.onFailure)
                      : null,
                  icon: Icons.close_rounded,
                ),
              ),
            ),
          ),

          const SizedBox(width: 20),

          // Bouton Succès
          Expanded(
            child: AnimatedBuilder(
              animation: _successScale,
              builder: (context, child) => Transform.scale(
                scale: _successScale.value,
                child: _buildButton(
                  text: widget.successText,
                  colors: [AppColors.purple, AppColors.pink],
                  onPressed: widget.isEnabled
                      ? () => _handleButtonPress(_successController, widget.onSuccess)
                      : null,
                  icon: Icons.check_rounded,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required List<Color> colors,
    required VoidCallback? onPressed,
    required IconData icon,
  }) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: onPressed != null
            ? LinearGradient(colors: colors)
            : LinearGradient(colors: [Colors.grey.shade400, Colors.grey.shade500]),
        boxShadow: onPressed != null
            ? [
          BoxShadow(
            color: colors.first.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleButtonPress(AnimationController controller, VoidCallback callback) {
    controller.forward().then((_) {
      controller.reverse();
      callback();
    });
  }
}