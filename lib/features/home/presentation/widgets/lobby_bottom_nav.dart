import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/app_router.dart';

class LobbyBottomNav extends StatelessWidget {
  final VoidCallback onSettingsTap;

  const LobbyBottomNav({
    super.key,
    required this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withValues(alpha: 0.9),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildNavItem(context, Icons.person_outline, 'Profile', onTap: () => context.push(AppRouter.profile)),
          const SizedBox(width: 32),
          _buildNavItem(context, Icons.history, 'History'),
          const SizedBox(width: 32),
          _buildNavItem(context, Icons.leaderboard_outlined, 'Rankings'),
          const SizedBox(width: 32),
          _buildNavItem(context, Icons.people_outline, 'Friends'),
          const SizedBox(width: 32),
          _buildNavItem(context, Icons.settings_outlined, 'Settings', onTap: onSettingsTap),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap ?? () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label coming soon!')),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white70, size: 28),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
