import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:clash_arena/core/utils/extensions/context_ext.dart';
import 'package:clash_arena/core/utils/extensions/string_ext.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/themes/app_texts_style.dart';
import '../../../../core/utils/spacing.dart';
import '../../../../core/widgets/notification_icon.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key, required this.title});
  final String title;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: rw(24), vertical: rh(16)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Text(
                title.capitalizeWords(),
                style: AppTextStyles.font16Bold.copyWith(
                  color: context.customColors.textPrimary,
                ),
              ),
              Text(
                'home.welcome_description'.tr(),
                style: AppTextStyles.font12Regular.copyWith(
                  color: context.customColors.textSecondary,
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            tooltip: 'groups.title'.tr(),
            icon: Icon(
              Icons.groups_outlined,
              color: context.customColors.textPrimary,
            ),
            onPressed: () => Navigator.of(
              context,
              rootNavigator: true,
            ).pushNamed(Routes.groupsScreen),
          ),
          CircleAvatar(
            radius: rr(20),
            backgroundColor: context.customColors.divider.withValues(
              alpha: 0.5,
            ),
            child: const NotificationIcon(unreadCount: 3),
          ),
        ],
      ),
    );
  }
}
