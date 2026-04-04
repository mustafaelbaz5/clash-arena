import 'package:flutter/material.dart';
import 'package:im_legends/core/utils/extensions/context_ext.dart';

import '../themes/app_texts_style.dart';
import '../utils/spacing.dart';
import 'notification_icon.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: rw(24), vertical: rh(16)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          Text(
            title,
            style: AppTextStyles.font20Bold,
            textAlign: TextAlign.center,
          ),
          const Spacer(),
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
