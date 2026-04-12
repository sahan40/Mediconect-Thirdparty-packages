import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

import '../presentation/screens/dashboard_screen.dart';
import '../presentation/screens/login_screen.dart';
import '../presentation/screens/medical_history_screen.dart';
import '../presentation/screens/signup_screen.dart';
import '../presentation/screens/splash_screen.dart';
import '../presentation/state/login_provider.dart';
import '../presentation/state/medical_history_provider.dart';
import '../presentation/state/signup_provider.dart';
import 'app_routes.dart';

final RootStackRouter appRouter = RootStackRouter.build(
  defaultRouteType: const RouteType.material(),
  routes: <AutoRoute>[
    NamedRouteDef(
      name: 'SplashRoute',
      path: AppRoutes.splash,
      builder: (context, data) => const SplashScreen(),
    ),
    NamedRouteDef(
      name: 'LoginRoute',
      path: AppRoutes.login,
      builder: (context, data) => const LoginStateManager(child: LoginScreen()),
    ),
    NamedRouteDef(
      name: 'SignupRoute',
      path: AppRoutes.signup,
      builder:
          (context, data) => const SignupStateManager(child: SignupScreen()),
    ),
    NamedRouteDef(
      name: 'DashboardRoute',
      path: AppRoutes.dashboard,
      builder: (context, data) {
        final tabQuery = data.queryParams.optString('tab');
        final initialIndex = int.tryParse(tabQuery ?? '') ?? 0;
        return DashboardScreen(initialIndex: initialIndex);
      },
      type: RouteType.custom(
        duration: const Duration(milliseconds: 420),
        reverseDuration: const Duration(milliseconds: 380),
        transitionsBuilder: TransitionsBuilders.slideLeft,
      ),
    ),
    NamedRouteDef(
      name: 'MedicalHistoryRoute',
      path: AppRoutes.medicalHistory,
      builder:
          (context, data) =>
              const MedicalHistoryStateManager(child: MedicalHistoryScreen()),
    ),
    NamedRouteDef(
      name: 'ForgotPasswordRoute',
      path: AppRoutes.forgotPassword,
      builder:
          (context, data) => const _PlaceholderScreen(title: 'Forgot Password'),
    ),
    NamedRouteDef(
      name: 'InsuranceDetailsRoute',
      path: AppRoutes.insuranceDetails,
      builder:
          (context, data) =>
              const _PlaceholderScreen(title: 'Insurance Details'),
    ),
    NamedRouteDef(
      name: 'NotFoundRoute',
      path: '*',
      builder: (context, data) => const _PlaceholderScreen(title: 'Not Found'),
    ),
  ],
);

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          '$title\n(Coming soon)',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }
}
