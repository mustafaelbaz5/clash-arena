import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:im_legends/core/utils/extensions/context_ext.dart';

import '../../../core/themes/app_texts_style.dart';
import '../../../core/utils/functions/refresh_page.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../logic/cubit/match_history_cubit.dart';
import 'widgets/history_list_card.dart';
import 'widgets/history_shimmer_loading.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          CustomAppBar(title: 'history.history'.tr()),
          Expanded(
            child: BlocBuilder<MatchHistoryCubit, MatchHistoryState>(
              builder: (final context, final state) {
                if (state is MatchHistoryLoading) {
                  return const HistoryShimmerLoading();
                } else if (state is MatchHistorySuccess) {
                  final matches = state.matches;
                  return RefreshIndicator(
                    onRefresh: () => refreshData(context),
                    backgroundColor: context.customColors.background,
                    color: context.customColors.textPrimary,
                    child: ListView.builder(
                      itemCount: matches.length,
                      itemBuilder: (final context, final index) =>
                          HistoryListCard(match: matches[index]),
                    ),
                  );
                } else if (state is MatchHistoryFailed) {
                  return Center(
                    child: Text(
                      state.error.message,
                      style: AppTextStyles.font16Bold,
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
