import 'package:flutter/material.dart';
import 'package:clash_arena/core/utils/extensions/context_ext.dart';

import '../../../../../core/themes/app_texts_style.dart';
import '../../../../../core/utils/spacing.dart';

class ThemeOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const ThemeOption({
    super.key,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(final BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(rr(12)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: rw(16), vertical: rh(18)),
        decoration: BoxDecoration(
          color: isSelected
              ? context.customColors.background
              : Colors.transparent,
          borderRadius: BorderRadius.circular(rr(12)),
          border: Border.all(
            color: isSelected
                ? context.customColors.info
                : context.customColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: <Widget>[
            Icon(
              icon,
              color: isSelected
                  ? context.customColors.info
                  : context.customColors.border,
              size: rf(20),
            ),
            horizontalSpacing(12),
            Text(
              title,
              style: AppTextStyles.font14Regular.copyWith(
                color: isSelected
                    ? context.customColors.info
                    : context.customColors.textSecondary,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: context.customColors.info,
                size: rf(20),
              ),
          ],
        ),
      ),
    );
  }
}
