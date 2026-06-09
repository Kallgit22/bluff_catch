import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../router/app_router.dart';
import '../../../../core/theme/app_themes.dart';
import '../../../../core/providers/settings_provider.dart';
import '../widgets/lobby_top_bar.dart';
import '../widgets/lobby_action_card.dart';
import '../widgets/lobby_bottom_nav.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final currentThemeConfig = AppThemes.getThemeById(settings.themeId);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          // Use the theme's background gradient
          gradient: currentThemeConfig.backgroundGradient,
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // -------------------------------------------------------------
              // Background Accents (Optional, to make it feel premium)
              // -------------------------------------------------------------
              Positioned(
                left: -100,
                top: -100,
                child: Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.1),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.2),
                        blurRadius: 100,
                        spreadRadius: 50,
                      ),
                    ],
                  ),
                ),
              ),

              // -------------------------------------------------------------
              // Main Layout
              // -------------------------------------------------------------
              Column(
                children: [
                  // Top Status Bar
                  const LobbyTopBar(),

                  // Center Content
                  Expanded(
                    child: Row(
                      children: [
                        // Action Cards (Left/Center)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 48.0,
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Online Play (Primary)
                                  LobbyActionCard(
                                    title: 'ONLINE PLAY',
                                    subtitle: 'MATCHMAKING & RANKED',
                                    icon: Icons.public,
                                    isPrimary: true,
                                    baseColor: Colors.amber.shade700,
                                    onTap: () => context.push(AppRouter.onlineHub),
                                  ),
                                  const SizedBox(width: 32),
                                  // Offline Play
                                  LobbyActionCard(
                                    title: 'LOCAL PLAY',
                                    subtitle: 'HOTSEAT MULTIPLAYER',
                                    icon: Icons.people,
                                    isPrimary: false,
                                    baseColor: Colors.blue.shade600,
                                    onTap: () => context.push(AppRouter.setup),
                                  ),
                                  const SizedBox(width: 32),
                                  // Practice Mode
                                  LobbyActionCard(
                                    title: 'PRACTICE',
                                    subtitle: 'PLAY AGAINST AI',
                                    icon: Icons.smart_toy,
                                    isPrimary: false,
                                    baseColor: Colors.purple.shade600,
                                    onTap: () {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Practice Mode coming soon!',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bottom Quick Navigation
                  LobbyBottomNav(
                    onSettingsTap: () => context.push(AppRouter.settings),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
