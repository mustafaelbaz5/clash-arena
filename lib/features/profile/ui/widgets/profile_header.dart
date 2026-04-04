import 'package:flutter/material.dart';
import 'package:im_legends/core/utils/extensions/context_ext.dart';

import '../../../../core/themes/app_texts_style.dart';
import '../../../../core/utils/spacing.dart';
import 'profile_image_avatar.dart';
import 'profile_top_bar.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.name, this.imageUrl});

  final String name;
  final String? imageUrl;

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      height: rh(320),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const ProfileTopBar(),
          Positioned(
            top: rh(190),
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: context.customColors.background,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(rr(24)),
                  topRight: Radius.circular(rr(24)),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  top: rh(90),
                  left: rw(24),
                  right: rw(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    verticalSpacing(16),
                    Text(
                      name,
                      style: AppTextStyles.font20Bold.copyWith(
                        color: context.customColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// Floating Avatar
          Positioned(
            top: rh(140),
            left: 0,
            right: 0,
            child: Center(
              child: ProfileImageAvatar(
                profileImageUrl: imageUrl ?? '',
                onEditTap: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
