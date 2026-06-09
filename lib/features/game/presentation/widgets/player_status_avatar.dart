import 'package:flutter/material.dart';
import '../../domain/entities/player.dart';

class PlayerStatusAvatar extends StatelessWidget {
  final Player player;
  final bool isActive;
  final Color avatarColor;

  const PlayerStatusAvatar({
    super.key,
    required this.player,
    this.isActive = false,
    required this.avatarColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEliminated = player.isEliminated;
    final hasPassed = player.hasPassed;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isActive ? theme.colorScheme.primary : Colors.transparent,
                  width: 3,
                ),
              ),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: isEliminated ? Colors.grey : avatarColor,
                child: Text(
                  player.playerName.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            if (player.totalCards > 0)
              Positioned(
                right: -1,
                top: -1,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.error,
                    shape: BoxShape.circle,
                    border: Border.all(color: theme.colorScheme.surface, width: 2),
                  ),
                  child: Text(
                    '${player.totalCards}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            if (hasPassed && !isEliminated)
              Positioned(
                bottom: -1,
                right: -1,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.do_not_disturb,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
              ),
            if (isEliminated && player.rankPosition != null)
              Positioned(
                bottom: -4,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '#${player.rankPosition}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          player.playerName,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isEliminated ? theme.colorScheme.onSurface.withValues(alpha: 0.5) : theme.colorScheme.onSurface,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
