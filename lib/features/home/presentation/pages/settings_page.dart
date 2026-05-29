import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_themes.dart';
import '../../../../core/providers/settings_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => context.pop(),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'SETTINGS',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    // Left Side: Theme Selector
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 24.0, right: 12.0, bottom: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'THEME STYLE',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Expanded(
                                child: GridView.builder(
                                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 250,
                                    mainAxisExtent: 100,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                  ),
                                  itemCount: AppThemes.themes.length,
                                itemBuilder: (context, index) {
                                  final themeConfig = AppThemes.themes[index];
                                  final isSelected = themeConfig.id == settings.themeId;
                                  
                                  return _ThemeCard(
                                    config: themeConfig,
                                    isSelected: isSelected,
                                    onTap: () {
                                      ref.read(settingsProvider.notifier).setTheme(themeConfig.id);
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Right Side: Toggles
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0, right: 24.0, bottom: 24.0),
                        child: Card(
                          color: Colors.black.withValues(alpha: 0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                            side: BorderSide(color: Colors.white.withValues(alpha: 0.1), width: 1),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'PREFERENCES',
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  _buildToggleRow(
                                    context,
                                    icon: Icons.volume_up,
                                    label: 'Sound Effects',
                                    value: settings.soundEnabled,
                                    onChanged: (val) => ref.read(settingsProvider.notifier).toggleSound(),
                                  ),
                                  const SizedBox(height: 16),
                                  _buildToggleRow(
                                    context,
                                    icon: Icons.vibration,
                                    label: 'Vibration',
                                    value: settings.vibrationEnabled,
                                    onChanged: (val) => ref.read(settingsProvider.notifier).toggleVibration(),
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    'ANIMATION SPEED',
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Slider(
                                    value: settings.animationSpeed,
                                    min: 0.5,
                                    max: 1.5,
                                    divisions: 2,
                                    label: '${settings.animationSpeed}x',
                                    activeColor: theme.colorScheme.primary,
                                    inactiveColor: Colors.white24,
                                    onChanged: (val) {
                                      ref.read(settingsProvider.notifier).setAnimationSpeed(val);
                                    },
                                  ),
                                  const SizedBox(height: 24),
                                  SizedBox(
                                    width: double.infinity,
                                    child: OutlinedButton(
                                      onPressed: () {
                                        ref.read(settingsProvider.notifier).resetPreferences();
                                      },
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        side: const BorderSide(color: Colors.white30),
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      ),
                                      child: const Text('Reset to Defaults', style: TextStyle(fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleRow(BuildContext context, {required IconData icon, required String label, required bool value, required ValueChanged<bool> onChanged}) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _ThemeCard extends StatelessWidget {
  final ThemeConfig config;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeCard({
    required this.config,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.1),
            width: isSelected ? 3 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: config.themeData.colorScheme.primary.withValues(alpha: 0.5),
                    blurRadius: 10,
                    spreadRadius: 2,
                  )
                ]
              : [],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: config.backgroundGradient,
                ),
              ),
              Positioned(
                top: -10,
                right: -10,
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: config.themeData.colorScheme.primary,
                ),
              ),
              Positioned(
                bottom: -15,
                left: -10,
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: config.themeData.colorScheme.secondary,
                ),
              ),
              Container(
                color: Colors.black.withValues(alpha: 0.2), // Dim overlay for text readability
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      config.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      config.description,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 10,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
