import 'package:go_router/go_router.dart';

import '../../features/home/presentation/pages/home_page.dart';
import '../../features/setup/presentation/pages/setup_page.dart';
import '../../features/game/presentation/pages/game_page.dart';
import '../../features/home/presentation/pages/settings_page.dart';

class AppRouter {
  AppRouter._();

  static const String home = '/';
  static const String setup = '/setup';
  static const String game = '/game';
  static const String settings = '/settings';

  static final router = GoRouter(
    initialLocation: home,
    routes: [
      GoRoute(
        path: home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: setup,
        builder: (context, state) => const SetupPage(),
      ),
      GoRoute(
        path: game,
        builder: (context, state) => const GamePage(),
      ),
      GoRoute(
        path: settings,
        builder: (context, state) => const SettingsPage(),
      ),
    ],
  );
}
