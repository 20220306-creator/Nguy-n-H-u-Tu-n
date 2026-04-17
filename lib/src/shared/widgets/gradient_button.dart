import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
  });

  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3525CD), Color(0xFF4F46E5)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.20),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: Colors.white),
              const SizedBox(width: 10),
            ],
            Text(label, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w800, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

