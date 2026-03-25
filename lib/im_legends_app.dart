import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:im_legends/core/config/app_config.dart';
import 'package:im_legends/core/settings/cubit/app_settings_cubit.dart';
import 'package:im_legends/core/settings/cubit/app_settings_state.dart';

import 'core/di/dependency_injection.dart';
import 'core/router/app_router.dart';
import 'core/themes/theme_data/theme_data_dark.dart';
import 'core/themes/theme_data/theme_data_light.dart';
import 'features/auth/logic/cubit/auth_cubit.dart';
import 'features/main_navigation/ui/main_scaffold.dart';
import 'features/onboarding/ui/on_boarding_screen.dart';

class IMLegendsApp extends StatelessWidget {
  const IMLegendsApp({super.key});

  @override
  Widget build(final BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (final context, final child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => getIt<AuthCubit>()..checkAuthStatus()),
            BlocProvider(create: (_) => AppSettingsCubit()),
          ],
          child: BlocBuilder<AppSettingsCubit, AppSettingsState>(
            builder:
                (final BuildContext context, final AppSettingsState settings) {
                  return BlocBuilder<AuthCubit, AuthState>(
                    builder: (final context, final authState) {
                      return MaterialApp(
                        key: ValueKey(authState is AuthAuthenticated),
                        localizationsDelegates: context.localizationDelegates,
                        supportedLocales: context.supportedLocales,
                        locale: settings.locale, // driven by cubit
                        debugShowCheckedModeBanner: false,
                        home: _buildHome(authState),
                        onGenerateRoute: AppRouter.generateRoute,
                        title: AppConfig.appName,
                        // font family injected into both themes
                        theme: getLightTheme().copyWith(
                          textTheme: getLightTheme().textTheme.apply(
                            fontFamily: settings.fontFamily,
                          ),
                        ),
                        darkTheme: getDarkTheme().copyWith(
                          textTheme: getDarkTheme().textTheme.apply(
                            fontFamily: settings.fontFamily,
                          ),
                        ),
                        themeMode: settings.themeMode,
                      );
                    },
                  );
                },
          ),
        );
      },
    );
  }

  Widget _buildHome(final AuthState state) {
    if (state is AuthInitial || state is AuthLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    } else if (state is AuthAuthenticated) {
      return const MainScaffold();
    } else {
      return const OnBoardingScreen();
    }
  }
}

// test123@gmail.com
