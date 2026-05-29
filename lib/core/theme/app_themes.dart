import 'package:flutter/material.dart';

class AppThemes {
  static final List<ThemeConfig> themes = [
    ThemeConfig(
      id: 'classic_casino',
      name: 'Classic Casino',
      description: 'Deep green felt with gold accents',
      themeData: _buildTheme(
        primary: const Color(0xFFD4AF37), // Gold
        background: const Color(0xFF131A13), // Very dark green
        surface: const Color(0xFF2A3A29), // Felt green
        accent: const Color(0xFFE53935), // Red
      ),
      backgroundGradient: const RadialGradient(
        colors: [Color(0xFF2A3A29), Color(0xFF131A13)],
        center: Alignment.center,
        radius: 1.2,
      ),
    ),
    ThemeConfig(
      id: 'royal_gold',
      name: 'Royal Gold',
      description: 'Rich burgundy and pure gold',
      themeData: _buildTheme(
        primary: const Color(0xFFFFD700), // Gold
        background: const Color(0xFF1A0000), // Dark Burgundy
        surface: const Color(0xFF4A0E17), // Rich Burgundy
        accent: const Color(0xFFFFF8DC), // Cornsilk
      ),
      backgroundGradient: const RadialGradient(
        colors: [Color(0xFF4A0E17), Color(0xFF1A0000)],
        center: Alignment.center,
        radius: 1.2,
      ),
    ),
    ThemeConfig(
      id: 'neon_cyber',
      name: 'Neon Cyber',
      description: 'Dark violet with hot neon highlights',
      themeData: _buildTheme(
        primary: const Color(0xFFFF00FF), // Magenta
        background: const Color(0xFF0D0221), // Deep violet
        surface: const Color(0xFF241734), // Slate violet
        accent: const Color(0xFF00FFFF), // Cyan
      ),
      backgroundGradient: const RadialGradient(
        colors: [Color(0xFF241734), Color(0xFF0D0221)],
        center: Alignment.center,
        radius: 1.2,
      ),
    ),
    ThemeConfig(
      id: 'ocean_blue',
      name: 'Ocean Blue',
      description: 'Deep navy and aquamarine glow',
      themeData: _buildTheme(
        primary: const Color(0xFF00E5FF), // Cyan Accent
        background: const Color(0xFF001524), // Dark Navy
        surface: const Color(0xFF15616D), // Ocean Blue
        accent: const Color(0xFFFF7D00), // Orange contrast
      ),
      backgroundGradient: const RadialGradient(
        colors: [Color(0xFF15616D), Color(0xFF001524)],
        center: Alignment.center,
        radius: 1.2,
      ),
    ),
    ThemeConfig(
      id: 'crimson_dark',
      name: 'Crimson Dark',
      description: 'Pitch black with blood red highlights',
      themeData: _buildTheme(
        primary: const Color(0xFFD90429), // Crimson
        background: const Color(0xFF0B090A), // Near Black
        surface: const Color(0xFF161A1D), // Eerie Black
        accent: const Color(0xFFEDF2F4), // Anti-flash white
      ),
      backgroundGradient: const RadialGradient(
        colors: [Color(0xFF161A1D), Color(0xFF0B090A)],
        center: Alignment.center,
        radius: 1.2,
      ),
    ),
    ThemeConfig(
      id: 'forest_emerald',
      name: 'Forest Emerald',
      description: 'Dark emerald with lime accents',
      themeData: _buildTheme(
        primary: const Color(0xFF00FF00), // Lime
        background: const Color(0xFF002200), // Dark Forest
        surface: const Color(0xFF004400), // Emerald
        accent: const Color(0xFFFFFF00), // Yellow
      ),
      backgroundGradient: const RadialGradient(
        colors: [Color(0xFF004400), Color(0xFF002200)],
        center: Alignment.center,
        radius: 1.2,
      ),
    ),
    ThemeConfig(
      id: 'minimal_light',
      name: 'Minimal Light',
      description: 'Crisp white with charcoal edges',
      themeData: _buildTheme(
        primary: const Color(0xFF212529), // Charcoal
        background: const Color(0xFFF8F9FA), // Off-white
        surface: const Color(0xFFE9ECEF), // Light grey
        accent: const Color(0xFF00B4D8), // Light blue
        isDark: false,
      ),
      backgroundGradient: const RadialGradient(
        colors: [Color(0xFFF8F9FA), Color(0xFFE9ECEF)],
        center: Alignment.center,
        radius: 1.2,
      ),
    ),
    ThemeConfig(
      id: 'retro_arcade',
      name: 'Retro Arcade',
      description: 'Sunset purple and orange grids',
      themeData: _buildTheme(
        primary: const Color(0xFFFF5400), // Orange
        background: const Color(0xFF240046), // Deep purple
        surface: const Color(0xFF5A189A), // Purple
        accent: const Color(0xFFFF9E00), // Bright Orange
      ),
      backgroundGradient: const RadialGradient(
        colors: [Color(0xFF5A189A), Color(0xFF240046)],
        center: Alignment.center,
        radius: 1.2,
      ),
    ),
    ThemeConfig(
      id: 'purple_galaxy',
      name: 'Purple Galaxy',
      description: 'Deep space indigo and starlight',
      themeData: _buildTheme(
        primary: const Color(0xFFB5179E), // Pink/Purple
        background: const Color(0xFF03045E), // Deep Space Blue
        surface: const Color(0xFF3A0CA3), // Indigo
        accent: const Color(0xFF4CC9F0), // Cyan Star
      ),
      backgroundGradient: const RadialGradient(
        colors: [Color(0xFF3A0CA3), Color(0xFF03045E)],
        center: Alignment.center,
        radius: 1.2,
      ),
    ),
    ThemeConfig(
      id: 'matte_black',
      name: 'Matte Black',
      description: 'Pure black with high contrast white',
      themeData: _buildTheme(
        primary: const Color(0xFFFFFFFF), // White
        background: const Color(0xFF000000), // Pure Black
        surface: const Color(0xFF121212), // Matte Grey
        accent: const Color(0xFF888888), // Grey Accent
      ),
      backgroundGradient: const RadialGradient(
        colors: [Color(0xFF121212), Color(0xFF000000)],
        center: Alignment.center,
        radius: 1.2,
      ),
    ),
  ];

  static ThemeData _buildTheme({
    required Color primary,
    required Color background,
    required Color surface,
    required Color accent,
    bool isDark = true,
  }) {
    final brightness = isDark ? Brightness.dark : Brightness.light;
    final onBackground = isDark ? Colors.white : Colors.black;
    
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: primary,
        onPrimary: isDark ? Colors.black : Colors.white,
        secondary: accent,
        onSecondary: isDark ? Colors.black : Colors.white,
        error: Colors.redAccent,
        onError: Colors.white,
        surface: surface,
        onSurface: onBackground,
      ),
      scaffoldBackgroundColor: background,
      cardTheme: CardThemeData(
        color: surface,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: isDark ? Colors.black : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: isDark ? Colors.black : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  static ThemeConfig getThemeById(String id) {
    return themes.firstWhere((t) => t.id == id, orElse: () => themes.first);
  }
}

class ThemeConfig {
  final String id;
  final String name;
  final String description;
  final ThemeData themeData;
  final RadialGradient backgroundGradient;

  ThemeConfig({
    required this.id,
    required this.name,
    required this.description,
    required this.themeData,
    required this.backgroundGradient,
  });
}
