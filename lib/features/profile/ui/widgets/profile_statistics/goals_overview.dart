import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/utils/extensions/context_ext.dart';

import '../../../../../core/models/players_states_model.dart';
import '../../../../../core/themes/app_colors.dart';
import '../../../../../core/themes/app_texts_style.dart';
import '../../../../../core/utils/spacing.dart';

class GoalsOverview extends StatelessWidget {
  final PlayerStatsModel stats;
  const GoalsOverview({super.key, required this.stats});

  @override
  Widget build(final BuildContext context) {
    final bool isPositive = stats.goalsScored - stats.goalsReceived >= 0;
    return Container(
      padding: EdgeInsets.all(rw(16)),
      decoration: BoxDecoration(
        color: (isPositive ? AppColors.green100 : AppColors.red100).withAlpha(
          (0.1 * 255).toInt(),
        ),
        borderRadius: BorderRadius.circular(rr(12)),
        border: Border.all(
          color: (isPositive ? AppColors.green100 : AppColors.red100).withAlpha(
            (0.3 * 255).toInt(),
          ),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'profile.stats.goal_difference'.tr(),
                style: AppTextStyles.font12Regular.copyWith(
                  color: context.customColors.textSecondary,
                ),
              ),
              verticalSpacing(4),
              Row(
                children: [
                  Icon(
                    isPositive ? Icons.trending_up : Icons.trending_down,
                    size: rw(20),
                    color: isPositive ? AppColors.green100 : AppColors.red100,
                  ),
                  horizontalSpacing(4),
                  Text(
                    '${isPositive ? '+' : ''}${stats.goalsScored - stats.goalsReceived}',
                    style: AppTextStyles.font20Bold.copyWith(
                      color: isPositive ? AppColors.green100 : AppColors.red100,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: rw(12), vertical: rh(8)),
            decoration: BoxDecoration(
              color: context.customColors.successBackground,
              borderRadius: BorderRadius.circular(rr(8)),
            ),
            child: Column(
              children: [
                Text(
                  '${stats.goalsScored} : ${stats.goalsReceived}',
                  style: AppTextStyles.font14Bold.copyWith(
                    color: context.customColors.textPrimary,
                  ),
                ),
                Text(
                  '${'profile.stats.goals_scored'.tr()} : ${'profile.stats.goals_received'.tr()}',
                  style: AppTextStyles.font12Regular.copyWith(
                    color: context.customColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
