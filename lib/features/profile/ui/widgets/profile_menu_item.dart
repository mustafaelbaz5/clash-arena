import 'package:flutter/material.dart';
import 'package:im_legends/core/utils/extensions/context_ext.dart';

import '../../../../core/themes/app_texts_style.dart';
import '../../../../core/utils/spacing.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(final BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(rr(12)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: rw(8), vertical: rh(16)),
          child: Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(rw(10)),
                decoration: BoxDecoration(
                  color: context.customColors.divider,
                  borderRadius: BorderRadius.circular(rr(12)),
                ),
                child: Icon(
                  icon,
                  size: rw(22),
                  color: context.customColors.textSecondary,
                ),
              ),

              horizontalSpacing(16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: AppTextStyles.font14Bold.copyWith(
                        color: context.customColors.textPrimary,
                      ),
                    ),
                    verticalSpacing(4),
                    Text(
                      subtitle,
                      style: AppTextStyles.font12SemiBold.copyWith(
                        color: context.customColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              if (trailing != null)
                trailing!
              else
                Icon(
                  Icons.arrow_forward_ios,
                  size: rw(16),
                  color: context.customColors.textSecondary.withAlpha(100),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
