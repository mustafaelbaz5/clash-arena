import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:im_legends/core/utils/extensions/context_ext.dart';

import '../../../core/themes/app_texts_style.dart';
import '../../../core/utils/functions/refresh_page.dart';
import '../../../core/utils/spacing.dart';
import '../../auth/logic/cubit/auth_cubit.dart';
import 'widgets/home_app_bar.dart';
import 'widgets/home_header_container.dart';
import 'widgets/leader_board_list_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          BlocBuilder<AuthCubit, AuthState>(
            builder: (final context, final state) {
              if (state is AuthAuthenticated) {
                return HomeAppBar(title: state.user!.name);
              }
              return const SizedBox.shrink();
            },
          ),
          verticalSpacing(12),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => refreshData(context),
              backgroundColor: context.customColors.background,
              color: context.customColors.textPrimary,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: rw(8)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HomeHeaderContainer(),
                      verticalSpacing(16),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: rw(8)),
                        child: Text(
                          'home.leaderboard'.tr(),
                          style: AppTextStyles.font20Bold,
                        ),
                      ),
                      verticalSpacing(12),

                      const LeadBoardListView(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
