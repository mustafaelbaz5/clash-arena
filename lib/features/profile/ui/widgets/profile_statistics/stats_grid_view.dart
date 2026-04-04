import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:im_legends/core/utils/extensions/context_ext.dart';

import '../../../../../core/models/players_states_model.dart';
import '../../../../../core/themes/app_colors.dart';
import '../../../../../core/themes/app_texts_style.dart';
import '../../../../../core/utils/spacing.dart';

class StatsGridView extends StatelessWidget {
  const StatsGridView({super.key, required this.stats});
  final PlayerStatsModel stats;
  @override
  Widget build(final BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.symmetric(vertical: rh(20)),
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: rh(12),
      crossAxisSpacing: rw(12),
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          context,
          icon: Icons.sports_soccer,
          label: 'profile.stats.matches_played'.tr(),
          value: stats.matchesPlayed.toString(),
          color: context.customColors.info,
        ),
        _buildStatCard(
          context,
          icon: Icons.emoji_events,
          label: 'profile.stats.points'.tr(),
          value: stats.points.toString(),
          color: AppColors.amber300,
        ),
        _buildStatCard(
          context,
          icon: Icons.sports_score,
          label: 'profile.stats.goals_scored'.tr(),
          value: stats.goalsScored.toString(),
          color: AppColors.green100,
        ),
        _buildStatCard(
          context,
          icon: Icons.shield,
          label: 'profile.stats.goals_received'.tr(),
          value: stats.goalsReceived.toString(),
          color: AppColors.red100,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    final BuildContext context, {
    required final IconData icon,
    required final String label,
    required final String value,
    required final Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(rw(12)),
      decoration: BoxDecoration(
        color: color.withAlpha((0.1 * 255).toInt()),
        borderRadius: BorderRadius.circular(rr(12)),
        border: Border.all(
          color: color.withAlpha((0.3 * 255).toInt()),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, size: rw(24), color: color),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: AppTextStyles.font18Bold.copyWith(
                  color: context.customColors.textPrimary,
                ),
              ),
              Text(
                label,
                style: AppTextStyles.font12Regular.copyWith(
                  color: context.customColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
