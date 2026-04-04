import 'package:flutter/material.dart';
import 'package:im_legends/core/utils/extensions/context_ext.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/utils/spacing.dart';

class ProfileShimmerLoading extends StatelessWidget {
  const ProfileShimmerLoading({super.key});

  @override
  Widget build(final BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.customColors.textPrimary.withAlpha(50),
      highlightColor: context.customColors.textSecondary,
      period: const Duration(milliseconds: 1200),
      child: CustomScrollView(
        slivers: [
          // Top bar with avatar shimmer
          SliverToBoxAdapter(
            child: SizedBox(
              height: rh(240),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Top bar background
                  Container(
                    height: rh(190),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(rr(24)),
                        bottomRight: Radius.circular(rr(24)),
                      ),
                    ),
                  ),

                  // Floating Avatar
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: rw(100),
                        height: rw(100),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade700,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: context.customColors.background,
                            width: 4,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content area
          SliverToBoxAdapter(
            child: Column(
              children: [
                verticalSpacing(16),

                // Name shimmer
                Container(
                  width: rw(150),
                  height: rh(24),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade700,
                    borderRadius: BorderRadius.circular(rr(8)),
                  ),
                ),

                verticalSpacing(24),

                // Stats section shimmer
                _buildStatsShimmer(context),

                verticalSpacing(16),

                // Info section shimmer
                _buildInfoShimmer(context),

                verticalSpacing(16),

                // Settings section shimmer
                _buildSettingsShimmer(context),

                verticalSpacing(24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsShimmer(final BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: rw(16)),
      decoration: BoxDecoration(
        color: context.isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(rr(16)),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: EdgeInsets.all(rw(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: rw(100),
                  height: rh(18),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade700,
                    borderRadius: BorderRadius.circular(rr(6)),
                  ),
                ),
                Container(
                  width: rw(80),
                  height: rh(28),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade700,
                    borderRadius: BorderRadius.circular(rr(20)),
                  ),
                ),
              ],
            ),
          ),

          // Win rate card
          Padding(
            padding: EdgeInsets.symmetric(horizontal: rw(20)),
            child: Container(
              padding: EdgeInsets.all(rw(16)),
              decoration: BoxDecoration(
                color: Colors.grey.shade700,
                borderRadius: BorderRadius.circular(rr(12)),
              ),
              child: Row(
                children: [
                  // Circle
                  Container(
                    width: rw(70),
                    height: rw(70),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade600,
                      shape: BoxShape.circle,
                    ),
                  ),
                  horizontalSpacing(16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: rw(80),
                          height: rh(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade600,
                            borderRadius: BorderRadius.circular(rr(4)),
                          ),
                        ),
                        verticalSpacing(8),
                        Row(
                          children: [
                            Container(
                              width: rw(40),
                              height: rh(24),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade600,
                                borderRadius: BorderRadius.circular(rr(6)),
                              ),
                            ),
                            horizontalSpacing(8),
                            Container(
                              width: rw(40),
                              height: rh(24),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade600,
                                borderRadius: BorderRadius.circular(rr(6)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          verticalSpacing(20),

          // Stats grid
          Padding(
            padding: EdgeInsets.symmetric(horizontal: rw(20)),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: rh(12),
              crossAxisSpacing: rw(12),
              childAspectRatio: 1.5,
              children: List.generate(
                4,
                (final index) => Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade700,
                    borderRadius: BorderRadius.circular(rr(12)),
                  ),
                ),
              ),
            ),
          ),

          verticalSpacing(20),

          // Goal difference card
          Padding(
            padding: EdgeInsets.symmetric(horizontal: rw(20)),
            child: Container(
              height: rh(80),
              decoration: BoxDecoration(
                color: Colors.grey.shade700,
                borderRadius: BorderRadius.circular(rr(12)),
              ),
            ),
          ),

          verticalSpacing(20),
        ],
      ),
    );
  }

  Widget _buildInfoShimmer(final BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: rw(16)),
      decoration: BoxDecoration(
        color: context.isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(rr(16)),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: EdgeInsets.fromLTRB(rw(20), rh(20), rw(20), rh(12)),
            child: Row(
              children: [
                Container(
                  width: rw(36),
                  height: rw(36),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade700,
                    borderRadius: BorderRadius.circular(rr(10)),
                  ),
                ),
                horizontalSpacing(12),
                Container(
                  width: rw(120),
                  height: rh(18),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade700,
                    borderRadius: BorderRadius.circular(rr(6)),
                  ),
                ),
              ],
            ),
          ),

          // Info items
          ...List.generate(
            4,
            (final index) => Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: rw(20),
                    vertical: rh(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: rw(40),
                        height: rw(40),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade700,
                          borderRadius: BorderRadius.circular(rr(12)),
                        ),
                      ),
                      horizontalSpacing(16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: rw(80),
                              height: rh(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade700,
                                borderRadius: BorderRadius.circular(rr(4)),
                              ),
                            ),
                            verticalSpacing(6),
                            Container(
                              width: rw(150),
                              height: rh(16),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade700,
                                borderRadius: BorderRadius.circular(rr(4)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: rw(32),
                        height: rw(32),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade700,
                          borderRadius: BorderRadius.circular(rr(8)),
                        ),
                      ),
                    ],
                  ),
                ),
                if (index < 3)
                  Divider(
                    height: 1,
                    indent: rw(60),
                    endIndent: rw(20),
                    color: Colors.grey.shade700,
                  ),
              ],
            ),
          ),

          verticalSpacing(4),
        ],
      ),
    );
  }

  Widget _buildSettingsShimmer(final BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: rw(16)),
      decoration: BoxDecoration(
        color: context.isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(rr(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.fromLTRB(rw(20), rh(20), rw(20), rh(12)),
            child: Container(
              width: rw(100),
              height: rh(18),
              decoration: BoxDecoration(
                color: Colors.grey.shade700,
                borderRadius: BorderRadius.circular(rr(6)),
              ),
            ),
          ),

          // Settings items
          ...List.generate(
            2,
            (final index) => Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: rw(20),
                    vertical: rh(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: rw(40),
                        height: rw(40),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade700,
                          borderRadius: BorderRadius.circular(rr(12)),
                        ),
                      ),
                      horizontalSpacing(16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: rw(80),
                              height: rh(14),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade700,
                                borderRadius: BorderRadius.circular(rr(4)),
                              ),
                            ),
                            verticalSpacing(6),
                            Container(
                              width: rw(60),
                              height: rh(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade700,
                                borderRadius: BorderRadius.circular(rr(4)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: rw(16),
                        height: rw(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade700,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
                if (index < 1)
                  Divider(
                    height: 1,
                    indent: rw(60),
                    endIndent: rw(20),
                    color: Colors.grey.shade700,
                  ),
              ],
            ),
          ),

          verticalSpacing(4),
        ],
      ),
    );
  }
}
