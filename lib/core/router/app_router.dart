import 'package:flutter/material.dart';

import '../../features/auth/ui/login_screen.dart';
import '../../features/auth/ui/sign_up_screen.dart';
import '../../features/notification/ui/notifications_screen.dart';
import 'routes.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic> generateRoute(final RouteSettings settings) {
    switch (settings.name) {
      case Routes.loginScreen:
        return _buildRoute(const LoginScreen(), settings);
      case Routes.signUpScreen:
        return _buildRoute(const SignUpScreen(), settings);
      case Routes.notificationsScreen:
        return _buildRoute(const NotificationsScreen(), settings);
      // case Routes.onboarding:
      //   return _buildRoute(const OnboardingScreen(), settings);
      // case Routes.home:
      //   return _buildRoute(const HomeScreen(), settings);
      default:
        return _buildRoute(
          Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
          settings,
        );
    }
  }

  static PageRouteBuilder _buildRoute(
    final Widget page,
    final RouteSettings settings,
  ) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (final context, final animation, final secondaryAnimation) =>
          page,
      transitionsBuilder:
          (
            final context,
            final animation,
            final secondaryAnimation,
            final child,
          ) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOutCubic;

            final tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
