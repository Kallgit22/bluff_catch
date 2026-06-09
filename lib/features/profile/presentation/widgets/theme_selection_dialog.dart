import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_themes.dart';
import '../../../../core/providers/settings_provider.dart';

class ThemeSelectionDialog extends ConsumerWidget {
  const ThemeSelectionDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final themes = AppThemes.themes;

    return AlertDialog(
      backgroundColor: Colors.grey[900],
      title: const Text('Select Theme', style: TextStyle(color: Colors.white)),
      content: SizedBox(
        width: 300,
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: themes.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final themeConfig = themes[index];
            final isSelected = themeConfig.id == settings.themeId;

            return InkWell(
              onTap: () {
                ref.read(settingsProvider.notifier).setTheme(themeConfig.id);
                Navigator.of(context).pop();
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected ? themeConfig.themeData.colorScheme.primary.withValues(alpha: 0.2) : Colors.black54,
                  border: Border.all(
                    color: isSelected ? themeConfig.themeData.colorScheme.primary : Colors.white24,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        gradient: themeConfig.backgroundGradient,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white54),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        themeConfig.name,
                        style: TextStyle(
                          color: isSelected ? themeConfig.themeData.colorScheme.primary : Colors.white,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                    if (isSelected)
                      Icon(Icons.check_circle, color: themeConfig.themeData.colorScheme.primary),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('CANCEL'),
        ),
      ],
    );
  }
}
