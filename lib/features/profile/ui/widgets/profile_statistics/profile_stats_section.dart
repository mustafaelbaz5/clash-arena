import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:clash_arena/core/utils/extensions/context_ext.dart';

import '../../../../../core/models/players_states_model.dart';
import '../../../../../core/themes/app_texts_style.dart';
import '../../../../../core/utils/spacing.dart';
import 'goals_overview.dart';
import 'stats_grid_view.dart';
import 'win_rate_card.dart';

class ProfileStatsSection extends StatelessWidget {
  final PlayerStatsModel stats;

  const ProfileStatsSection({super.key, required this.stats});

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(rw(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'profile.stats.title'.tr(),
                style: AppTextStyles.font16Bold.copyWith(
                  color: context.customColors.textPrimary,
                ),
              ),
              if (stats.rank != null)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: rw(12),
                    vertical: rh(6),
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        context.customColors.info,
                        context.customColors.info.withAlpha(
                          (0.7 * 255).toInt(),
                        ),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(rr(20)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.emoji_events, size: rf(16)),
                      horizontalSpacing(4),
                      Text(
                        '${'profile.stats.rank'.tr()} #${stats.rank}',
                        style: AppTextStyles.font12Regular,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        // Win Rate Circle
        Padding(
          padding: EdgeInsets.symmetric(horizontal: rw(20)),
          child: WinRateCard(stats: stats),
        ),
        // Stats Grid
        Padding(
          padding: EdgeInsets.symmetric(horizontal: rw(20)),
          child: StatsGridView(stats: stats),
        ),
        // Goals Overview
        Padding(
          padding: EdgeInsets.symmetric(horizontal: rw(20)),
          child: GoalsOverview(stats: stats),
        ),

        verticalSpacing(20),
      ],
    );
  }
}
