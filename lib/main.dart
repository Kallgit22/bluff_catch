import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:firebase_app_check/firebase_app_check.dart';

import 'core/theme/app_themes.dart';
import 'core/providers/settings_provider.dart';
import 'firebase_options.dart';
import 'router/app_router.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock app globally to landscape
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.debug,
      appleProvider: AppleProvider.debug,
    );
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }

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
      routerConfig: ref.watch(routerProvider),
      debugShowCheckedModeBanner: false,
    );
  }
}
