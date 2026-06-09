import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/home/presentation/pages/home_page.dart';
import '../features/setup/presentation/pages/setup_page.dart';
import '../features/game/presentation/pages/game_page.dart';
import '../features/game/presentation/pages/test_harness_page.dart';
import '../features/home/presentation/pages/settings_page.dart';
import '../features/online/presentation/pages/online_hub_page.dart';
import '../features/online/presentation/pages/room_lobby_page.dart';

// Auth Pages (to be created)
import '../features/auth/presentation/pages/splash_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/auth/presentation/pages/forgot_password_page.dart';
import '../features/auth/presentation/pages/phone_auth_page.dart';

import '../features/auth/presentation/providers/auth_provider.dart';
import '../features/profile/presentation/providers/profile_provider.dart';
import '../features/profile/presentation/pages/profile_page.dart';
import '../features/profile/presentation/pages/edit_profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppRouter {
  AppRouter._();

  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String phoneAuth = '/phone-auth';

  static const String home = '/';
  static const String setup = '/setup';
  static const String game = '/game';
  static const String settings = '/settings';
  static const String debugHarness = '/debug-harness';
  static const String onlineHub = '/online-hub';
  static const String roomLobby = '/room-lobby';
  
  // Profile Routes
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
}

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  ref.listen<AsyncValue<User?>>(authStateProvider, (previous, next) {
    if (next.value != null && previous?.value?.uid != next.value?.uid) {
      final repo = ref.read(profileRepositoryProvider);
      final user = next.value!;
      repo.getOrCreateProfile(user.uid, email: user.email, name: user.displayName);
    }
  });

  return GoRouter(
    initialLocation: AppRouter.splash,
    redirect: (BuildContext context, GoRouterState state) {
      // If the auth state is still loading, stay on splash
      if (authState.isLoading) {
        return AppRouter.splash;
      }

      final isAuth = authState.value != null;
      final isSplash = state.uri.toString() == AppRouter.splash;
      final isLoggingIn = state.uri.toString() == AppRouter.login ||
          state.uri.toString() == AppRouter.register ||
          state.uri.toString() == AppRouter.forgotPassword ||
          state.uri.toString() == AppRouter.phoneAuth;

      if (!isAuth) {
        // If not logged in and not on an auth-related page, redirect to login
        if (!isLoggingIn) {
          return AppRouter.login;
        }
        return null;
      }

      // If logged in but on splash or a login page, redirect to home
      if (isSplash || isLoggingIn) {
        return AppRouter.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRouter.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRouter.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRouter.register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: AppRouter.forgotPassword,
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: AppRouter.phoneAuth,
        builder: (context, state) => const PhoneAuthPage(),
      ),
      GoRoute(
        path: AppRouter.home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: AppRouter.setup,
        builder: (context, state) => const SetupPage(),
      ),
      GoRoute(
        path: AppRouter.onlineHub,
        builder: (context, state) => const OnlineHubPage(),
      ),
      GoRoute(
        path: AppRouter.roomLobby,
        builder: (context, state) => RoomLobbyPage(roomId: (state.extra as String?) ?? ''),
      ),
      GoRoute(
        path: AppRouter.game,
        builder: (context, state) => const GamePage(),
      ),
      GoRoute(
        path: AppRouter.settings,
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: AppRouter.debugHarness,
        builder: (context, state) => const TestHarnessPage(),
      ),
      GoRoute(
        path: AppRouter.profile,
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: AppRouter.editProfile,
        builder: (context, state) => const EditProfilePage(),
      ),
    ],
  );
});
