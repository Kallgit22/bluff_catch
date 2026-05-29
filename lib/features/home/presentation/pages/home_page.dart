import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../router/app_router.dart';
import '../../../../core/theme/app_themes.dart';
import '../../../../core/providers/settings_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final settings = ref.watch(settingsProvider);
    final currentThemeConfig = AppThemes.getThemeById(settings.themeId);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: currentThemeConfig.backgroundGradient,
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Left Side: Logo/Title
              Expanded(
                flex: 5,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.style,
                        size: 80,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppStrings.appName.toUpperCase(),
                        style: theme.textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 8,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'THE ULTIMATE DECEPTION GAME',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white70,
                          letterSpacing: 4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Right Side: Menu Buttons
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(right: 32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FilledButton.icon(
                        onPressed: () => context.push(AppRouter.setup),
                        icon: const Icon(Icons.play_arrow, size: 28),
                        label: const Text(
                          AppStrings.playNow,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          elevation: 8,
                        ),
                      ),
                      const SizedBox(height: 24),
                      OutlinedButton.icon(
                        onPressed: () => context.push(AppRouter.settings),
                        icon: const Icon(Icons.settings, size: 24),
                        label: const Text(
                          AppStrings.settings,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white54, width: 2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
