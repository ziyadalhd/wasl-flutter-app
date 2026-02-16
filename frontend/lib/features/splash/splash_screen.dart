import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wasl/core/services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );

    _controller.forward();

    // Check for existing session after splash animation
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) _checkSession();
    });
  }

  Future<void> _checkSession() async {
    try {
      final loggedIn = await AuthService.isLoggedIn();
      if (!mounted) return;

      if (loggedIn) {
        // Token exists — fetch profile to get active mode
        try {
          final me = await AuthService.getMe();
          if (!mounted) return;

          if (me.mode == 'STUDENT') {
            context.go('/student/home');
          } else {
            context.go('/service_provider/home');
          }
          return;
        } catch (_) {
          // Token expired or invalid — clear it and go to onboarding
          await AuthService.logout();
        }
      }

      if (mounted) context.go('/onboarding');
    } catch (_) {
      if (mounted) context.go('/onboarding');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF00695C), // Darker Teal
              Color(0xFF4DB6AC), // Lighter Teal
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Text(
                    'وَصِل',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 80,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'دربك خضر',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w500,
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
