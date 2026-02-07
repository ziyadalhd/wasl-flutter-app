import 'package:go_router/go_router.dart';
import 'package:wasl/features/splash/splash_screen.dart';
import 'package:wasl/features/onboarding/onboarding_screen.dart';
import 'package:wasl/features/auth/login_screen.dart';
import 'package:wasl/features/auth/role_selection_screen.dart';
import 'package:wasl/features/auth/signup_screen.dart';
import 'package:wasl/features/auth/password_screen.dart';
import 'package:wasl/features/welcome/welcome_screen.dart';
import 'package:wasl/features/student/home/presentation/pages/student_home_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/role',
      builder: (context, state) => const RoleSelectionScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) {
        final role = state.uri.queryParameters['role']; // Role is now optional
        return SignUpScreen(role: role);
      },
    ),
    GoRoute(
      path: '/password',
      builder: (context, state) => const PasswordScreen(),
    ),
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/student/home',
      builder: (context, state) => const StudentHomeScreen(),
    ),
  ],
);
