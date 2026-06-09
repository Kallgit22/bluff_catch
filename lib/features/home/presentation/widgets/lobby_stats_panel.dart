import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../profile/presentation/providers/profile_provider.dart';

class LobbyStatsPanel extends ConsumerWidget {
  const LobbyStatsPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);
    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 24.0, top: 16.0, bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.2),
            BlendMode.darken,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CAREER STATS',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  profileAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (err, stack) => const Center(child: Text('Error loading stats')),
                    data: (profile) {
                      if (profile == null) {
                        return const Center(child: Text('No profile found.'));
                      }
                      return Column(
                        children: [
                          // Rank Display
                          Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.shield,
                                  size: 64,
                                  color: Colors.amber.shade300,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  profile.rank,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Divider(color: Colors.white12),
                          ),

                          // Stat Rows
                          _buildStatRow('Matches', profile.matchesPlayed.toString()),
                          _buildStatRow('Wins', profile.wins.toString(), isHighlight: true),
                          _buildStatRow('Win Rate', '${(profile.winRate * 100).toStringAsFixed(1)}%'),
                          _buildStatRow('Points', profile.points.toString()),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isHighlight ? Colors.greenAccent : Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
