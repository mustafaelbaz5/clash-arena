import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/utils/extensions/context_ext.dart';

import '../../../../../core/models/players_states_model.dart';
import '../../../../../core/themes/app_colors.dart';
import '../../../../../core/themes/app_texts_style.dart';
import '../../../../../core/utils/spacing.dart';

class WinRateCard extends StatelessWidget {
  const WinRateCard({super.key, required this.stats});
  final PlayerStatsModel stats;
  @override
  Widget build(final BuildContext context) {
    final double winRate = stats.matchesPlayed > 0
        ? (stats.wins / stats.matchesPlayed) * 100
        : 0;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: rw(16), vertical: rh(24)),
      decoration: BoxDecoration(
        color: context.customColors.info.withAlpha((0.1 * 255).toInt()),
        borderRadius: BorderRadius.circular(rr(12)),
      ),
      child: Row(
        children: [
          // Win Rate Circle
          SizedBox(
            width: rw(70),
            height: rw(70),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: rw(70),
                  height: rw(70),
                  child: CircularProgressIndicator(
                    value: winRate / 100,
                    strokeWidth: 6,
                    backgroundColor: context.customColors.border.withAlpha(
                      (0.3 * 255).toInt(),
                    ),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      context.customColors.info,
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${winRate.toStringAsFixed(0)}%',
                      style: AppTextStyles.font16Bold.copyWith(
                        color: context.customColors.info,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          horizontalSpacing(16),

          // Win/Loss breakdown
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'profile.stats.win_rate'.tr(),
                  style: AppTextStyles.font14Bold.copyWith(
                    color: context.customColors.textPrimary,
                  ),
                ),
                verticalSpacing(8),
                Row(
                  children: [
                    _buildWinLossChip(
                      context,
                      'W',
                      stats.wins.toString(),
                      AppColors.green100,
                    ),
                    horizontalSpacing(8),
                    _buildWinLossChip(
                      context,
                      'L',
                      stats.losses.toString(),
                      AppColors.red100,
                    ),
                    horizontalSpacing(8),
                    _buildWinLossChip(
                      context,
                      'Total',
                      stats.matchesPlayed.toString(),
                      context.customColors.textSecondary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWinLossChip(
    final BuildContext context,
    final String label,
    final String value,
    final Color color,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: rw(8), vertical: rh(4)),
      decoration: BoxDecoration(
        color: color.withAlpha((0.1 * 255).toInt()),
        borderRadius: BorderRadius.circular(rr(6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTextStyles.font12Regular.copyWith(color: color),
          ),
          horizontalSpacing(4),
          Text(
            value,
            style: AppTextStyles.font12Regular.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
