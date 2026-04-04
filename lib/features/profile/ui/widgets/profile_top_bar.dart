import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:im_legends/core/utils/extensions/context_ext.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_texts_style.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/spacing.dart';

class ProfileTopBar extends StatelessWidget {
  const ProfileTopBar({super.key});

  @override
  Widget build(final BuildContext context) {
    return Container(
      color: AppColors.primary300,
      height: rh(220),
      child: Padding(
        padding: EdgeInsets.only(
          left: rw(24),
          right: rw(24),
          top: rh(56),
          bottom: rh(24),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'profile.profile'.tr(),
              style: AppTextStyles.font20Bold.copyWith(color: AppColors.white),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            GestureDetector(
              onTap: () => context.pushNamed(Routes.notificationsScreen),
              child: SvgPicture.asset(
                AppAssets.notificationIconSvg,
                colorFilter: const ColorFilter.mode(
                  AppColors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
