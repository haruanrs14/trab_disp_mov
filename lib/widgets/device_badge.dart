import 'package:flutter/material.dart';
import '../app_theme.dart';

class DeviceBadge extends StatelessWidget {
  const DeviceBadge({super.key, required this.tipo});

  final String tipo;

  IconData get _icon {
    switch (tipo) {
      case 'Videogame':
        return Icons.sports_esports;
      case 'Controle':
        return Icons.gamepad;
      case 'Celular':
        return Icons.smartphone;
      case 'Computador':
        return Icons.computer;
      default:
        return Icons.devices;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.secondaryColor.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 14, color: AppTheme.secondaryColor),
          const SizedBox(width: 4),
          Text(
            tipo,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.secondaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
