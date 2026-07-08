import 'package:flutter/material.dart';
import 'package:clash_arena/core/utils/extensions/context_ext.dart';

import '../../../../../../../core/utils/spacing.dart';
import '../../../../../core/themes/app_texts_style.dart';

class LanguageOption extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const LanguageOption({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(final BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(rw(12)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: rw(16), vertical: rh(18)),
        decoration: BoxDecoration(
          color: isSelected
              ? context.customColors.info.withAlpha((0.1 * 255).toInt())
              : Colors.transparent,
          borderRadius: BorderRadius.circular(rw(12)),
          border: Border.all(
            color: isSelected
                ? context.customColors.info
                : context.customColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: <Widget>[
            Text(
              title,
              style: isSelected
                  ? AppTextStyles.font14Bold.copyWith(
                      color: context.customColors.info,
                    )
                  : AppTextStyles.font14Regular.copyWith(
                      color: context.customColors.textSecondary,
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
