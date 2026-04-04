import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:im_legends/core/utils/extensions/context_ext.dart';

import '../router/routes.dart';
import '../themes/app_colors.dart';
import '../themes/app_texts_style.dart';
import '../utils/app_assets.dart';

class NotificationIcon extends StatelessWidget {
  final int unreadCount;
  const NotificationIcon({super.key, required this.unreadCount});

  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed(Routes.notificationsScreen),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SvgPicture.asset(
            AppAssets.notificationIconSvg,
            colorFilter: const ColorFilter.mode(
              AppColors.primary300,
              BlendMode.srcIn,
            ),
          ),
          if (unreadCount > 0)
            Positioned(
              right: 6,
              bottom: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColors.red100,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                child: Center(
                  child: Text(
                    unreadCount > 9 ? '9+' : unreadCount.toString(),
                    style: AppTextStyles.font12SemiBold.copyWith(
                      color: AppColors.white,
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
