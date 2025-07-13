import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomBackButton extends StatelessWidget {
  final Color? iconColor;
  final VoidCallback? onPressed;

  const CustomBackButton({super.key, this.iconColor, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF8B5CF6);
    return IconButton(
      icon: const Icon(Icons.arrow_back_rounded),
      color: iconColor ?? primaryColor,
      onPressed:
          onPressed ??
          () {
            HapticFeedback.lightImpact();
            Navigator.of(context).pop();
          },
      tooltip: 'Retour',
    );
  }
}
