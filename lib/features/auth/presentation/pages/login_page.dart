import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_themes.dart';
import '../../../../core/providers/settings_provider.dart';
import '../../../../router/app_router.dart';
import '../providers/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loginWithEmail() async {
    setState(() => _isLoading = true);
    final authRepo = ref.read(authRepositoryProvider);
    final result = await authRepo.signInWithEmailAndPassword(
      _emailController.text.trim(),
      _passwordController.text,
    );

    result.fold(
      (failure) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(failure.message)),
          );
        }
        setState(() => _isLoading = false);
      },
      (_) {
        // GoRouter will auto-redirect because authState changes
      },
    );
  }

  Future<void> _loginWithGoogle() async {
    setState(() => _isLoading = true);
    final authRepo = ref.read(authRepositoryProvider);
    final result = await authRepo.signInWithGoogle();

    result.fold(
      (failure) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(failure.message)),
          );
        }
        setState(() => _isLoading = false);
      },
      (_) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final themeConfig = AppThemes.getThemeById(settings.themeId);
    final colorScheme = themeConfig.themeData.colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: themeConfig.backgroundGradient),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 400,
              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.style, size: 64, color: colorScheme.primary),
                  const SizedBox(height: 16),
                  const Text(
                    'BLUFF CATCH',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => context.push(AppRouter.forgotPassword),
                      child: const Text('Forgot Password?'),
                    ),
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      onPressed: _isLoading ? null : _loginWithEmail,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('LOGIN', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  const Row(
                    children: [
                      Expanded(child: Divider(color: Colors.white24)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text('OR SIGN IN WITH', style: TextStyle(color: Colors.white54, fontSize: 12)),
                      ),
                      Expanded(child: Divider(color: Colors.white24)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _SocialIconButton(
                        icon: Icons.g_mobiledata,
                        color: Colors.redAccent,
                        onTap: _isLoading ? null : _loginWithGoogle,
                      ),
                      const SizedBox(width: 16),
                      _SocialIconButton(
                        icon: Icons.apple,
                        color: Colors.white,
                        onTap: _isLoading ? null : () {}, // Implement Apple Auth
                      ),
                      const SizedBox(width: 16),
                      _SocialIconButton(
                        icon: Icons.phone,
                        color: Colors.greenAccent,
                        onTap: () => context.push(AppRouter.phoneAuth),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () => context.push(AppRouter.register),
                    child: const Text("Don't have an account? Register"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _SocialIconButton({
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white24),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 32),
        ),
      ),
    );
  }
}
