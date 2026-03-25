import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:im_legends/core/utils/extensions/context_ext.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../../../core/di/dependency_injection.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/utils/spacing.dart';
import '../../add_match/logic/cubit/add_match_cubit.dart';
import '../../add_match/ui/add_match_screen.dart';
import '../../champion/logic/cubit/champion_cubit.dart';
import '../../champion/ui/champion_screen.dart';
import '../../history/logic/cubit/match_history_cubit.dart';
import '../../history/ui/history_screen.dart';
import '../../home/logic/cubit/home_cubit.dart';
import '../../home/ui/home_screen.dart';
import '../../profile/logic/cubit/profile_cubit.dart';
import '../../profile/ui/profile_screen.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Widget> _buildScreens() {
    return const [
      HomeScreen(),
      HistoryScreen(),
      AddMatchScreen(),
      ChampionScreen(),
      ProfileScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarItems(final BuildContext context) {
    return [
      _buildNavItem(context, Icons.home_rounded, Icons.home_outlined),
      _buildNavItem(context, Icons.history_rounded, Icons.history_outlined),
      _buildNavItem(
        context,
        Icons.add_circle,
        Icons.add_circle_outline,
        isCenterButton: true,
      ),
      _buildNavItem(context, Icons.emoji_events, Icons.emoji_events_outlined),
      _buildNavItem(context, Icons.person, Icons.person_outline),
    ];
  }

  PersistentBottomNavBarItem _buildNavItem(
    final BuildContext context,
    final IconData activeIcon,
    final IconData inactiveIcon, {
    final bool isCenterButton = false,
  }) {
    return PersistentBottomNavBarItem(
      icon: Icon(
        activeIcon,
        size: rr(26),
        color: isCenterButton ? AppColors.white : AppColors.primary400,
      ),
      inactiveIcon: Icon(
        inactiveIcon,
        size: rr(26),
        color: isCenterButton
            ? AppColors.white
            : context.customColors.textPrimary,
      ),
      activeColorPrimary: AppColors.primary400,
      inactiveColorPrimary: context.customColors.textPrimary,
    );
  }

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<HomeCubit>()..loadLeaderboard()),
        BlocProvider(create: (_) => getIt<MatchHistoryCubit>()..fetchMatches()),
        BlocProvider(create: (_) => getIt<AddMatchCubit>()..getPlayersList()),
        BlocProvider(create: (_) => getIt<ProfileCubit>()..fetchProfile()),
        BlocProvider(create: (_) => getIt<ChampionCubit>()..fetchLeaderboard()),
      ],
      child: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarItems(context),
        navBarStyle: NavBarStyle.style15,
        backgroundColor: context.customColors.background,
        navBarHeight: rh(70),
        padding: EdgeInsets.symmetric(vertical: rh(4), horizontal: rw(8)),
        decoration: NavBarDecoration(
          colorBehindNavBar: context.customColors.background,
          border: Border(
            top: BorderSide(color: context.customColors.divider, width: 1),
          ),
        ),
        confineToSafeArea: true,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        hideNavigationBarWhenKeyboardAppears: true,
        popBehaviorOnSelectedNavBarItemPress: PopBehavior.all,
      ),
    );
  }
}
