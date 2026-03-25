import 'package:flutter/material.dart';
import 'package:im_legends/core/utils/extensions/context_ext.dart';

import '../../../../core/models/players_states_model.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_texts_style.dart';
import '../../../../core/utils/spacing.dart';
import 'rank_and_avatar.dart';

class LeaderBoardCard extends StatelessWidget {
  final PlayerStatsModel player;
  final bool isCurrentUser;

  const LeaderBoardCard({
    super.key,
    this.isCurrentUser = false,
    required this.player,
  });

  @override
  Widget build(final BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: rh(4)),
      padding: EdgeInsets.symmetric(horizontal: rw(12), vertical: rh(8)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(rr(12)),
        color: isCurrentUser
            ? context.customColors.divider
            : context.customColors.background,
        border: Border.all(
          color: isCurrentUser
              ? AppColors.primary300
              : context.customColors.divider.withValues(alpha: 0.5),
          width: isCurrentUser ? 1.5 : .5,
        ),
      ),
      child: Row(
        children: [
          RankAndAvatar(
            isCurrentUser: isCurrentUser,
            rank: player.rank,
            imageUrl: player.profileImage,
          ),
          horizontalSpacing(10),
          Expanded(child: _buildPlayerInfo(context)),
          horizontalSpacing(8),
          _buildStatsRow(context),
        ],
      ),
    );
  }

  Widget _buildPlayerInfo(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          player.playerName,
          style: AppTextStyles.font14SemiBold.copyWith(
            color: context.customColors.textPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        verticalSpacing(4),
        Container(
          padding: EdgeInsets.symmetric(horizontal: rw(6), vertical: rh(2)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(rr(4)),
            color: AppColors.amber100.withValues(alpha: 0.1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star, size: rf(12), color: AppColors.amber100),
              horizontalSpacing(3),
              Text(
                '${player.points}',
                style: AppTextStyles.font12Regular.copyWith(
                  color: context.customColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(final BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildStatItem(
          context,
          player.matchesPlayed.toString(),
          Icons.sports_esports,
        ),
        horizontalSpacing(14),
        _buildStatItem(
          context,
          player.wins.toString(),
          Icons.emoji_events,
          AppColors.green100,
        ),
        horizontalSpacing(14),
        _buildStatItem(
          context,
          player.goalsScored - player.goalsReceived >= 0
              ? '+${player.goalsScored - player.goalsReceived}'
              : '${player.goalsScored - player.goalsReceived}',
          Icons.sports_soccer,
          player.goalsScored - player.goalsReceived >= 0
              ? AppColors.green100
              : AppColors.red100,
        ),
      ],
    );
  }

  Widget _buildStatItem(
    final BuildContext context,
    final String value,
    final IconData icon, [
    final Color? color,
  ]) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: rf(16),
          color: color ?? context.customColors.textSecondary,
        ),
        verticalSpacing(4),
        Text(
          value,
          style: AppTextStyles.font12SemiBold.copyWith(
            color: context.customColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
