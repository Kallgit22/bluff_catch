import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_themes.dart';
import '../../../../core/providers/settings_provider.dart';
import '../../../../router/app_router.dart';
import '../providers/profile_provider.dart';
import '../widgets/theme_selection_dialog.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final themeConfig = AppThemes.getThemeById(settings.themeId);
    final colorScheme = themeConfig.themeData.colorScheme;
    
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('PLAYER PROFILE', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Profile',
            onPressed: () => context.push(AppRouter.editProfile),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(gradient: themeConfig.backgroundGradient),
        child: SafeArea(
          child: profileAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.redAccent))),
            data: (profile) {
              if (profile == null) {
                return const Center(child: Text('Profile not found.', style: TextStyle(color: Colors.white)));
              }

              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Container(
                    width: 700, // Constrain width for landscape
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Column: Avatar & Basic Info
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 64,
                                backgroundColor: colorScheme.primary,
                                child: const Icon(Icons.face, size: 80, color: Colors.white), // Use avatar asset later
                              ),
                              const SizedBox(height: 16),
                              Text(
                                profile.displayName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '@${profile.username}',
                                style: const TextStyle(color: Colors.white54, fontSize: 16),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: colorScheme.primary),
                                ),
                                child: Text(
                                  profile.rank,
                                  style: TextStyle(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),
                              OutlinedButton.icon(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => const ThemeSelectionDialog(),
                                  );
                                },
                                icon: const Icon(Icons.color_lens),
                                label: const Text('Change Theme'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(color: Colors.white54),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(width: 32),
                        Container(width: 1, height: 300, color: Colors.white24),
                        const SizedBox(width: 32),

                        // Right Column: Stats
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'STATISTICS',
                                style: TextStyle(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2),
                              ),
                              const SizedBox(height: 24),
                              _StatRow(
                                icon: Icons.sports_esports,
                                label: 'Matches Played',
                                value: profile.matchesPlayed.toString(),
                                color: Colors.blueAccent,
                              ),
                              const SizedBox(height: 16),
                              _StatRow(
                                icon: Icons.emoji_events,
                                label: 'Victories',
                                value: profile.wins.toString(),
                                color: Colors.amber,
                              ),
                              const SizedBox(height: 16),
                              _StatRow(
                                icon: Icons.pie_chart,
                                label: 'Win Rate',
                                value: '${(profile.winRate * 100).toStringAsFixed(1)}%',
                                color: Colors.greenAccent,
                              ),
                              const SizedBox(height: 16),
                              _StatRow(
                                icon: Icons.stars,
                                label: 'Total Points',
                                value: profile.points.toString(),
                                color: Colors.purpleAccent,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
