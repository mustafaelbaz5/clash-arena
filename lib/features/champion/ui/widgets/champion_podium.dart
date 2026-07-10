import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/functions/get_rank_color.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_texts_style.dart';
import '../../../../core/utils/spacing.dart';
import '../../data/model/champion_player_model.dart';

class ChampionPodium extends StatelessWidget {
  final List<ChampionPlayerModel> topThree;
  final StatCategory category;

  const ChampionPodium({
    super.key,
    required this.topThree,
    required this.category,
  });

  @override
  Widget build(final BuildContext context) {
    // Skip top 3 — they're shown in the leaderboard
    if (topThree.isEmpty) return const SizedBox.shrink();

    final first = topThree[0];
    final second = topThree.length > 1 ? topThree[1] : null;
    final third = topThree.length > 2 ? topThree[2] : null;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: rh(24), horizontal: rw(8)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: _PodiumSlot(
              player: second,
              rank: 2,
              podiumHeight: rh(70),
              avatarRadius: rr(30),
              category: category,
            ),
          ),

          Expanded(
            child: _PodiumSlot(
              player: first,
              rank: 1,
              podiumHeight: rh(100),
              avatarRadius: rr(38),
              category: category,
            ),
          ),

          Expanded(
            child: _PodiumSlot(
              player: third,
              rank: 3,
              podiumHeight: rh(50),
              avatarRadius: rr(26),
              category: category,
            ),
          ),
        ],
      ),
    );
  }
}

class _PodiumSlot extends StatelessWidget {
  final ChampionPlayerModel? player;
  final int rank;
  final double podiumHeight;
  final double avatarRadius;
  final StatCategory category;

  const _PodiumSlot({
    required this.player,
    required this.rank,
    required this.podiumHeight,
    required this.avatarRadius,
    required this.category,
  });

  @override
  Widget build(final BuildContext context) {
    final rankColor = getRankColor(rank);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Crown icon for 1st ──
        if (rank == 1)
          Icon(
            Icons.emoji_events_rounded,
            color: AppColors.amber300,
            size: rf(28),
          )
        else
          verticalSpacing(6),

        verticalSpacing(8),

        // ── Avatar ──
        CircleAvatar(
          radius: avatarRadius,
          backgroundColor: rankColor,
          backgroundImage: player?.profileImageUrl != null
              ? CachedNetworkImageProvider(player!.profileImageUrl!)
              : null,
          child: player?.profileImageUrl == null
              ? Text(
                  player?.name.isNotEmpty == true
                      ? player!.name[0].toUpperCase()
                      : '?',
                  style: AppTextStyles.font14SemiBold,
                )
              : null,
        ),

        verticalSpacing(8),

        Text(
          player?.name ?? '—',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: AppTextStyles.font14SemiBold,
        ),

        verticalSpacing(4),

        if (player != null)
          Text(
            '${category.statValue(player!)} ${category.statLabel}',
            style: AppTextStyles.font12SemiBold.copyWith(color: rankColor),
          ),

        verticalSpacing(8),

        Container(
          height: podiumHeight,
          decoration: BoxDecoration(
            color: rankColor.withValues(alpha: 0.1),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            border: Border.all(
              color: rankColor.withValues(alpha: 0.1),
              width: 1.5,
            ),
          ),
          child: Center(
            child: Text(
              '#$rank',
              style: AppTextStyles.font16SemiBold.copyWith(color: rankColor),
            ),
          ),
        ),
      ],
    );
  }

  /// Returns a distinct color per rank using the app's color scheme.
}
