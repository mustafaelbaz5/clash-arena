import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/ui/login_screen.dart';
import '../../features/auth/ui/sign_up_screen.dart';
import '../../features/groups/logic/cubit/groups_cubit.dart';
import '../../features/groups/ui/groups_screen.dart';
import '../../features/match_request/logic/cubit/match_request_cubit.dart';
import '../../features/match_request/ui/match_request_screen.dart';
import '../../features/notification/ui/notifications_screen.dart';
import '../di/dependency_injection.dart';
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
      case Routes.groupsScreen:
        return _buildRoute(
          // BlocProvider.value: GroupsCubit is a DI-managed singleton (its
          // active-group context must survive navigation), so this route
          // must not take ownership and close it on dispose.
          BlocProvider.value(
            value: getIt<GroupsCubit>()..loadGroups(),
            child: const GroupsScreen(),
          ),
          settings,
        );
      case Routes.matchRequestScreen:
        return _buildRoute(
          BlocProvider.value(
            value: getIt<MatchRequestCubit>()..loadRequests(),
            child: const MatchRequestScreen(),
          ),
          settings,
        );
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
