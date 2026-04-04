import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/themes/app_texts_style.dart';
import '../../logic/cubit/home_cubit.dart';
import 'leader_board_card.dart';
import 'leader_board_shimmer_loading.dart';

class LeadBoardListView extends StatelessWidget {
  const LeadBoardListView({super.key});

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (final context, final state) {
        if (state is HomeFailure) {
          return Center(
            child: Text(state.error.message, style: AppTextStyles.font20Bold),
          );
        } else if (state is HomeLoading) {
          return const LeaderBoardShimmerLoading();
        } else if (state is HomeSuccess) {
          return ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.leaderboard.length,
            itemBuilder: (final context, final index) {
              final player = state.leaderboard[index];
              final currentUserId =
                  Supabase.instance.client.auth.currentUser?.id;
              player.matchesPlayed;
              return LeaderBoardCard(
                isCurrentUser: currentUserId == player.playerId,
                player: player,
              );
            },
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
