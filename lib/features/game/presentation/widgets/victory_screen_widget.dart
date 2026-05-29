import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/game_state.dart';
import '../../domain/entities/player.dart';
import '../providers/game_state_provider.dart';

class VictoryScreenWidget extends ConsumerWidget {
  final GameState gameState;

  const VictoryScreenWidget({
    super.key,
    required this.gameState,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final sortedPlayers = List<Player>.from(gameState.players)
      ..sort((a, b) => (a.rankPosition ?? 99).compareTo(b.rankPosition ?? 99));

    return Row(
      children: [
        // Left Column: Podium & Actions
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'MATCH RESULTS',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 24),
                if (sortedPlayers.isNotEmpty) _buildPodium(context, sortedPlayers),
                const SizedBox(height: 24),
                _buildActionButtons(context, ref),
              ],
            ),
          ),
        ),
        // Right Column: Stats List
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.only(top: 24, right: 16),
            child: ListView.builder(
              itemCount: sortedPlayers.length,
              itemBuilder: (context, index) {
                final player = sortedPlayers[index];
                return _buildPlayerStatsCard(context, player, index + 1);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPodium(BuildContext context, List<Player> players) {
    final theme = Theme.of(context);
    
    Widget buildPodiumStep(Player? player, int rank, double height, Color color) {
      if (player == null) return const SizedBox(width: 80);
      
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: color,
            child: Text(
              player.playerName.substring(0, 1).toUpperCase(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            player.playerName,
            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Container(
            width: 80,
            height: height,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
            ),
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              '#$rank',
              style: TextStyle(
                color: color,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    }

    return SizedBox(
      height: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          buildPodiumStep(players.length > 1 ? players[1] : null, 2, 80, Colors.grey[400]!),
          const SizedBox(width: 8),
          buildPodiumStep(players.isNotEmpty ? players[0] : null, 1, 120, Colors.amber),
          const SizedBox(width: 8),
          buildPodiumStep(players.length > 2 ? players[2] : null, 3, 60, Colors.brown[400]!),
        ],
      ),
    );
  }

  Widget _buildPlayerStatsCard(BuildContext context, Player player, int rank) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: rank == 1 ? Colors.amber : (rank == 2 ? Colors.grey[400] : (rank == 3 ? Colors.brown[400] : theme.colorScheme.surfaceContainerHighest)),
          child: Text('#$rank', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
        title: Text(player.playerName, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Tap to view stats', style: theme.textTheme.bodySmall),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(context, 'Lies Caught', player.liesCaught.toString(), Icons.visibility),
                _buildStatItem(context, 'Success Bluffs', player.successfulBluffs.toString(), Icons.masks),
                _buildStatItem(context, 'Chal. Won', player.challengesWon.toString(), Icons.gavel),
                _buildStatItem(context, 'Cards Eaten', player.cardsConsumed.toString(), Icons.style),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value, IconData icon) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, color: theme.colorScheme.primary, size: 24),
        const SizedBox(height: 4),
        Text(value, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label, style: theme.textTheme.bodySmall?.copyWith(fontSize: 10)),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {
                ref.read(gameStateProvider.notifier).replayGame();
              },
              icon: const Icon(Icons.replay),
              label: const Text('Play Again'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                ref.read(gameStateProvider.notifier).resetGame();
                context.go('/');
              },
              icon: const Icon(Icons.home),
              label: const Text('Main Menu'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
