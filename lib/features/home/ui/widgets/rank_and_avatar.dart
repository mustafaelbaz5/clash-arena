import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:im_legends/core/utils/extensions/context_ext.dart';

import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/functions/get_rank_color.dart';
import '../../../../core/utils/spacing.dart';

class RankAndAvatar extends StatelessWidget {
  const RankAndAvatar({
    super.key,
    this.imageUrl,
    this.rank,
    required this.isCurrentUser,
  });

  final String? imageUrl;
  final int? rank;
  final bool isCurrentUser;

  @override
  Widget build(final BuildContext context) {
    final avatarSize = isCurrentUser ? rw(55) : rw(50);
    return SizedBox(
      width: isCurrentUser ? rw(70) : rw(60),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Avatar
          Center(
            child: Container(
              width: avatarSize,
              height: avatarSize,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: CircleAvatar(
                radius: avatarSize / 2,
                backgroundColor: context.customColors.background,
                child: ClipOval(
                  child: SizedBox(
                    width: avatarSize,
                    height: avatarSize,
                    child: imageUrl == null || imageUrl!.isEmpty
                        ? Image.asset(AppAssets.appLogoPng, fit: BoxFit.cover)
                        : CachedNetworkImage(
                            imageUrl: imageUrl!,
                            fit: BoxFit.cover,
                            width: avatarSize,
                            height: avatarSize,
                            placeholder: (final context, final url) =>
                                Image.asset(
                                  AppAssets.appLogoPng,
                                  fit: BoxFit.cover,
                                ),
                            errorWidget:
                                (final context, final url, final error) =>
                                    Image.asset(
                                      AppAssets.appLogoPng,
                                      fit: BoxFit.cover,
                                    ),
                          ),
                  ),
                ),
              ),
            ),
          ),

          // Rank Badge
          if (rank != null)
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: getRankColor(rank!),
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: Center(
                  child: Text(
                    '$rank',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
