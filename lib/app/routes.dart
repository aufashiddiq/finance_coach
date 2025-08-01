import 'package:finance_coach/presentation/screens/auth/signup_screen.dart';
import 'package:finance_coach/presentation/screens/goals/goals_screen.dart';
import 'package:flutter/material.dart';
import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/dashboard/dashboard_screen.dart';
import '../presentation/screens/budget/budget_screen.dart';
import '../presentation/screens/onboarding/onboarding_screen.dart';

class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String dashboard = '/dashboard';
  static const String budget = '/budget';
  static const String goals = '/goals';
  static const String profile = '/profile';
  static const String settings = '/settings';
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppRoutes.signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case AppRoutes.dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case AppRoutes.budget:
        return MaterialPageRoute(builder: (_) => const BudgetScreen());
      case AppRoutes.goals:
        return MaterialPageRoute(builder: (_) => const GoalsScreen());
      // case AppRoutes.profile:
      //   return MaterialPageRoute(builder: (_) => const ProfileScreen());
      // case AppRoutes.settings:
      //   return MaterialPageRoute(builder: (_) => const SettingsScreen());
      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(
                  child: Text('No route defined for ${settings.name}'),
                ),
              ),
        );
    }
  }
}
