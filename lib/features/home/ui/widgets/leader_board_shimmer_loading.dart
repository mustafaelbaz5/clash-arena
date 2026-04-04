import 'package:flutter/material.dart';
import 'package:im_legends/core/utils/extensions/context_ext.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/utils/spacing.dart';

class LeaderBoardShimmerLoading extends StatelessWidget {
  const LeaderBoardShimmerLoading({super.key});

  @override
  Widget build(final BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: 8,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (final context, final index) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: rh(4)),
          padding: EdgeInsets.symmetric(horizontal: rw(12), vertical: rh(8)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(rr(12)),
            color: context.customColors.background,
            border: Border.all(
              color: context.customColors.divider.withValues(alpha: 0.5),
              width: 0.5,
            ),
          ),
          child: Shimmer.fromColors(
            baseColor: context.customColors.textPrimary.withAlpha(50),
            highlightColor: context.customColors.textSecondary,
            child: Row(
              children: [
                // Avatar Circle
                Container(
                  width: rw(50),
                  height: rh(50),
                  decoration: BoxDecoration(
                    color: context.customColors.divider,
                    shape: BoxShape.circle,
                  ),
                ),

                // Player Info (Name + Points)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: rw(100),
                        height: rh(14),
                        decoration: BoxDecoration(
                          color: context.customColors.divider,
                          borderRadius: BorderRadius.circular(rr(4)),
                        ),
                      ),
                      verticalSpacing(4),
                      Container(
                        width: rw(60),
                        height: rh(20),
                        decoration: BoxDecoration(
                          color: context.customColors.divider,
                          borderRadius: BorderRadius.circular(rr(4)),
                        ),
                      ),
                    ],
                  ),
                ),

                horizontalSpacing(8),

                // Stats Row (3 stats)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildStatShimmer(context),
                    horizontalSpacing(14),
                    _buildStatShimmer(context),
                    horizontalSpacing(14),
                    _buildStatShimmer(context),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatShimmer(final BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: rw(16),
          height: rh(16),
          decoration: BoxDecoration(
            color: context.customColors.divider,
            shape: BoxShape.circle,
          ),
        ),
        verticalSpacing(4),
        Container(
          width: rw(20),
          height: rh(12),
          decoration: BoxDecoration(
            color: context.customColors.divider,
            borderRadius: BorderRadius.circular(rr(4)),
          ),
        ),
      ],
    );
  }
}
