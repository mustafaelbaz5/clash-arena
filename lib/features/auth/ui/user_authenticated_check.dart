import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:im_legends/core/ui/loaders/overlay_loader.dart';
import 'package:im_legends/features/auth/logic/cubit/auth_cubit.dart';
import 'package:im_legends/features/main_navigation/ui/main_scaffold.dart';
import 'package:im_legends/features/onboarding/ui/on_boarding_screen.dart';

class UserAuthenticatedCheck extends StatelessWidget {
  const UserAuthenticatedCheck({super.key});

  @override
  Widget build(final BuildContext context) {
    final authState = context.watch<AuthCubit>().state;

    if (authState is AuthInitial || authState is AuthLoading) {
      return OverlayLoader(
        isLoading: authState is AuthLoading,
        child: const Scaffold(body: Center(child: SizedBox())),
      );
    }

    if (authState is AuthUnauthenticated || authState is AuthError) {
      return const OnBoardingScreen();
    }

    return const MainScaffold();
  }
}
// m9stafa05@gmail.com