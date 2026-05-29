import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/theme/app_themes.dart';
import 'core/providers/settings_provider.dart';
import 'router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Lock app globally to landscape
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const BluffCatchApp(),
    ),
  );
}

class BluffCatchApp extends ConsumerWidget {
  const BluffCatchApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final currentTheme = AppThemes.getThemeById(settings.themeId);

    return MaterialApp.router(
      title: 'Bluff Catch',
      theme: currentTheme.themeData,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
