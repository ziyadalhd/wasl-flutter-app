import 'package:go_router/go_router.dart';
import 'package:wasl/features/admin/presentation/pages/admin_dashboard_screen.dart';
import 'package:wasl/features/splash/splash_screen.dart';
import 'package:wasl/features/onboarding/onboarding_screen.dart';
import 'package:wasl/features/auth/login_screen.dart';
import 'package:wasl/features/auth/role_selection_screen.dart';
import 'package:wasl/features/auth/signup_screen.dart';
import 'package:wasl/features/auth/password_screen.dart';
import 'package:wasl/features/welcome/welcome_screen.dart';
import 'package:wasl/features/student/home/presentation/pages/student_home_screen.dart';
import 'package:wasl/features/service_provider/home/presentation/pages/service_provider_home_screen.dart';
import 'package:wasl/features/student/profile/presentation/screens/complete_profile_screen.dart';
import 'package:wasl/features/student/profile/presentation/screens/edit_profile_screen.dart';
import 'package:wasl/features/student/profile/presentation/screens/manage_notifications_screen.dart';
import 'package:wasl/features/student/profile/presentation/screens/support_screen.dart';
import 'package:wasl/features/student/profile/presentation/screens/about_us_screen.dart';
import 'package:wasl/features/student/profile/presentation/screens/support_chat_screen.dart';
import 'package:wasl/features/student/profile/presentation/screens/terms_conditions_screen.dart';
import 'package:wasl/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:wasl/features/auth/delete_account_screen.dart';
import 'package:wasl/features/wallet/presentation/screens/wallet_top_up_screen.dart';
import 'package:wasl/features/wallet/presentation/screens/withdraw_screen.dart';
import 'package:wasl/features/wallet/presentation/screens/withdraw_success_screen.dart';
import 'package:wasl/features/wallet/presentation/screens/all_transactions_screen.dart';
import 'package:wasl/features/student/services/presentation/screens/services_screen.dart';
import 'package:wasl/features/student/services/presentation/screens/housing_details_screen.dart';
import 'package:wasl/features/student/services/presentation/screens/transport_details_screen.dart';
import 'package:wasl/features/student/services/presentation/screens/payment_screen.dart';
import 'package:wasl/features/service_provider/services/presentation/widgets/provider_services_toggle.dart';
import 'package:wasl/features/student/services/presentation/screens/study_hours_selection_screen.dart';

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
      builder: (context, state) {
        final signupData = state.extra as Map<String, dynamic>?;
        return PasswordScreen(signupData: signupData);
      },
    ),
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminDashboardScreen(),
    ),
    GoRoute(
      path: '/student/home',
      builder: (context, state) {
        final initialIndex = state.extra as int? ?? 2;
        return StudentHomeScreen(initialIndex: initialIndex);
      },
    ),
    GoRoute(
      path: '/service_provider/home',
      builder: (context, state) {
        final initialIndex = state.extra as int? ?? 2;
        return ServiceProviderHomeScreen(initialIndex: initialIndex);
      },
    ),
    GoRoute(
      path: '/student/complete-profile',
      builder: (context, state) => const CompleteProfileScreen(),
    ),
    GoRoute(
      path: '/student/profile/edit',
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: '/student/profile/notifications',
      builder: (context, state) => const ManageNotificationsScreen(),
    ),
    GoRoute(
      path: '/student/profile/support',
      builder: (context, state) => const SupportScreen(),
      routes: [
        GoRoute(
          path: 'chat',
          builder: (context, state) => const SupportChatScreen(),
        ),
        GoRoute(
          path: 'about',
          builder: (context, state) => const AboutUsScreen(),
        ),
        GoRoute(
          path: 'terms',
          builder: (context, state) => const TermsConditionsScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: '/delete-account',
      builder: (context, state) {
        final role = state.uri.queryParameters['role'] ?? 'student';
        return DeleteAccountScreen(role: role);
      },
    ),
    GoRoute(
      path: '/wallet/topup',
      builder: (context, state) => const WalletTopUpScreen(),
    ),
    GoRoute(
      path: '/wallet/withdraw',
      builder: (context, state) {
        final double balance = state.extra as double? ?? 0.0;
        return WithdrawScreen(currentBalance: balance);
      },
    ),
    GoRoute(
      path: '/wallet/withdraw/success',
      builder: (context, state) => const WithdrawSuccessScreen(),
    ),
    GoRoute(
      path: '/wallet/transactions',
      builder: (context, state) => const AllTransactionsScreen(),
    ),
    GoRoute(
      path: '/services',
      builder: (context, state) {
        final initialTabParam = state.uri.queryParameters['initialTab'];
        final initialTab = initialTabParam == 'transportation'
            ? ServiceTab.transportation
            : ServiceTab.accommodation;
        return ServicesScreen(initialTab: initialTab);
      },
    ),
    GoRoute(
      path: '/housing-details',
      builder: (context, state) {
        final isFromBookings = state.extra as bool? ?? false;
        return HousingDetailsScreen(isFromBookings: isFromBookings);
      },
    ),
    GoRoute(
      path: '/transport-details',
      builder: (context, state) {
        final extra = state.extra;
        Map<String, dynamic> data = {};
        bool isFromBookings = false;

        if (extra is Map<String, dynamic>) {
          if (extra.containsKey('isFromBookings')) {
            isFromBookings = extra['isFromBookings'] as bool;
            data = extra['data'] as Map<String, dynamic>? ?? {};
          } else {
            data = extra;
          }
        }
        return TransportDetailsScreen(
          data: data,
          isFromBookings: isFromBookings,
        );
      },
    ),
    GoRoute(
      path: '/study-hours',
      builder: (context, state) => const StudyHoursSelectionScreen(),
    ),
    GoRoute(
      path: '/payment',
      builder: (context, state) {
        final isHousing = state.extra as bool? ?? true;
        return PaymentScreen(isHousing: isHousing);
      },
    ),
  ],
);
