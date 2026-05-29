import 'package:flutter/material.dart';
import '../../domain/entities/game_state.dart';

class ActionPanelWidget extends StatelessWidget {
  final GameState gameState;
  final bool hasSelectedCards;
  final VoidCallback onPlayTap;
  final VoidCallback onPassTap;
  final VoidCallback onChallengeTap;

  const ActionPanelWidget({
    super.key,
    required this.gameState,
    required this.hasSelectedCards,
    required this.onPlayTap,
    required this.onPassTap,
    required this.onChallengeTap,
  });

  @override
  Widget build(BuildContext context) {
    final isPoolEmpty = gameState.pool.isEmpty;
    // You cannot pass if the pool is empty (you are starting the round).
    // You cannot challenge if the pool is empty.
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (!isPoolEmpty) ...[
            _buildActionButton(
              context,
              label: 'Challenge',
              icon: Icons.gavel,
              color: Colors.redAccent,
              onPressed: (gameState.lastPlayerId != null && gameState.lastPlayerId == gameState.players[gameState.activePlayerIndex].playerId) 
                  ? null 
                  : onChallengeTap,
            ),
            const SizedBox(width: 8),
            _buildActionButton(
              context,
              label: 'Pass',
              icon: Icons.skip_next,
              color: Colors.orangeAccent,
              onPressed: onPassTap,
            ),
            const SizedBox(width: 8),
          ],
          
          Expanded(
            flex: 2,
            child: _buildActionButton(
              context,
              label: isPoolEmpty ? 'Throw Cards' : 'Add Cards',
              icon: Icons.play_arrow,
              color: Theme.of(context).colorScheme.primary,
              onPressed: hasSelectedCards ? onPlayTap : null,
              isPrimary: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback? onPressed,
    bool isPrimary = false,
  }) {
    return Expanded(
      child: FilledButton.icon(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: isPrimary ? color : color.withValues(alpha: 0.2),
          foregroundColor: isPrimary ? Colors.white : color,
          disabledBackgroundColor: Colors.grey.withValues(alpha: 0.2),
          disabledForegroundColor: Colors.grey,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        icon: Icon(icon, size: 20),
        label: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
