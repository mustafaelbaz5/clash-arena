import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:im_legends/core/utils/extensions/context_ext.dart';

import '../../../../core/utils/functions/app_setting_method.dart';
import '../../../../core/widgets/custom_icon_bottom.dart';

class OnBoardingTopBar extends StatelessWidget {
  const OnBoardingTopBar({super.key});

  @override
  Widget build(final BuildContext context) {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          CustomIconBottom(
            backgroundColor: context.customColors.divider.withValues(
              alpha: 0.5,
            ),
            icon: context.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            onPressed: () => switchTheme(context),
          ),
          CustomIconBottom(
            backgroundColor: context.customColors.divider.withValues(
              alpha: 0.5,
            ),
            icon: Icons.language_rounded,
            onPressed: () => switchLanguage(context),
            label: context.locale.languageCode.toUpperCase(),
          ),
        ],
      ),
    );
  }
}
