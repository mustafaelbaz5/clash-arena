import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:im_legends/core/utils/extensions/context_ext.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/utils/spacing.dart';

class ChampionShimmer extends StatelessWidget {
  const ChampionShimmer({super.key});

  @override
  Widget build(final BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.customColors.textPrimary.withAlpha(50),
      highlightColor: context.customColors.textSecondary,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpacing(24),
            _PodiumShimmer(),
            verticalSpacing(16),
            const Divider(),
            verticalSpacing(8),

            _LeaderboardShimmer(),
          ],
        ),
      ),
    );
  }
}

class _PodiumShimmer extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: rw(16)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 2nd place
          Expanded(
            child: _PodiumSlotShimmer(
              podiumHeight: rh(70),
              avatarRadius: rr(30),
            ),
          ),
          // 1st place
          Expanded(
            child: _PodiumSlotShimmer(
              podiumHeight: rh(100),
              avatarRadius: rr(38),
              showCrown: true,
            ),
          ),
          // 3rd place
          Expanded(
            child: _PodiumSlotShimmer(
              podiumHeight: rh(50),
              avatarRadius: rr(26),
            ),
          ),
        ],
      ),
    );
  }
}

class _PodiumSlotShimmer extends StatelessWidget {
  final double podiumHeight;
  final double avatarRadius;
  final bool showCrown;

  const _PodiumSlotShimmer({
    required this.podiumHeight,
    required this.avatarRadius,
    this.showCrown = false,
  });

  @override
  Widget build(final BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Crown placeholder
        Container(
          height: rh(28),
          width: rw(28),
          decoration: showCrown
              ? const BoxDecoration(color: Colors.white, shape: BoxShape.circle)
              : null,
        ),

        verticalSpacing(6),

        // Avatar
        CircleAvatar(radius: avatarRadius, backgroundColor: Colors.white),

        verticalSpacing(8),

        // Name
        Container(
          height: rh(10),
          width: rw(60),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),

        verticalSpacing(6),

        // Stat
        Container(
          height: rh(8),
          width: rw(44),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(rr(4)),
          ),
        ),

        verticalSpacing(8),

        // Podium block
        Container(
          height: podiumHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(rr(8))),
          ),
        ),
      ],
    );
  }
}

class _LeaderboardShimmer extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return Column(
      children: List.generate(
        6,
        (final i) => _LeaderboardRowShimmer(isEven: i.isEven),
      ),
    );
  }
}

class _LeaderboardRowShimmer extends StatelessWidget {
  final bool isEven;

  const _LeaderboardRowShimmer({required this.isEven});

  @override
  Widget build(final BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      color: isEven ? colors.surfaceContainerLowest : colors.surface,
      padding: EdgeInsets.symmetric(horizontal: rw(16), vertical: rh(10)),
      child: Row(
        children: [
          // Rank number
          Container(
            height: rh(14),
            width: rw(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(rr(4)),
            ),
          ),

          horizontalSpacing(16),

          // Avatar
          CircleAvatar(radius: rr(16), backgroundColor: Colors.white),

          horizontalSpacing(10),

          // Name
          Expanded(
            child: Container(
              height: rh(12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(rr(4)),
              ),
            ),
          ),

          horizontalSpacing(16),

          // Stat value
          Container(
            height: rh(14),
            width: rw(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(rr(4)),
            ),
          ),
        ],
      ),
    );
  }
}
