import 'package:flutter/material.dart';

import '../../../../core/themes/app_texts_style.dart';
import '../../../../core/utils/extensions/context_ext.dart';
import '../../../../core/utils/spacing.dart';
import '../../data/model/champion_player_model.dart';

class ChampionLeaderboard extends StatelessWidget {
  final List<ChampionPlayerModel> players;
  final StatCategory category;

  const ChampionLeaderboard({
    super.key,
    required this.players,
    required this.category,
  });

  @override
  Widget build(final BuildContext context) {
    // Skip top 3 — they're shown in the podium
    final rest = players.length > 3 ? players.sublist(3) : [];

    if (rest.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: rw(16), vertical: rh(8)),
          child: Row(
            children: [
              horizontalSpacing(8),
              const Text('Player', style: AppTextStyles.font14SemiBold),
              const Spacer(),
              Text(category.statLabel),
            ],
          ),
        ),

        verticalSpacing(8),

        ...rest.asMap().entries.map((final entry) {
          final rank = entry.key + 4;
          final player = entry.value as ChampionPlayerModel;

          return _LeaderboardRow(
            rank: rank,
            player: player,
            statValue: category.statValue(player),
            statLabel: category.statLabel,
            isEven: entry.key.isEven,
          );
        }),
      ],
    );
  }
}

class _LeaderboardRow extends StatelessWidget {
  final int rank;
  final ChampionPlayerModel player;
  final int statValue;
  final String statLabel;
  final bool isEven;

  const _LeaderboardRow({
    required this.rank,
    required this.player,
    required this.statValue,
    required this.statLabel,
    required this.isEven,
  });

  @override
  Widget build(final BuildContext context) {
    return Container(
      color: isEven
          ? context.customColors.background
          : context.customColors.background,
      padding: EdgeInsets.symmetric(horizontal: rw(16), vertical: rh(10)),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              '$rank',
              textAlign: TextAlign.center,
              style: AppTextStyles.font14SemiBold,
            ),
          ),

          Expanded(
            flex: 5,
            child: Row(
              children: [
                CircleAvatar(
                  radius: rr(16),
                  backgroundColor: context.customColors.divider.withValues(
                    alpha: 0.5,
                  ),
                  backgroundImage: player.profileImageUrl != null
                      ? NetworkImage(player.profileImageUrl!)
                      : null,
                  child: player.profileImageUrl == null
                      ? Text(
                          player.name.isNotEmpty
                              ? player.name[0].toUpperCase()
                              : '?',
                          style: AppTextStyles.font12Regular,
                        )
                      : null,
                ),
                horizontalSpacing(12),
                Expanded(
                  child: Text(
                    player.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.font14SemiBold,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            flex: 2,
            child: Text(
              '$statValue',
              textAlign: TextAlign.end,
              style: AppTextStyles.font14SemiBold,
            ),
          ),
        ],
      ),
    );
  }
}
