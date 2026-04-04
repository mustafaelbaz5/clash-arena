import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:im_legends/core/utils/extensions/context_ext.dart';

import '../../../../../core/themes/app_colors.dart';
import '../../../../../core/themes/app_texts_style.dart';
import '../../../../../core/ui/dialogs/app_dialogs.dart';
import '../../../../../core/utils/functions/app_setting_method.dart';
import '../../../../../core/utils/spacing.dart';
import '../../../../auth/logic/cubit/auth_cubit.dart';
import '../profile_menu_item.dart';
import '../profile_section_body.dart';
import 'language_option.dart';
import 'theme_option.dart';

class ProfileSettings extends StatelessWidget {
  const ProfileSettings({super.key});

  @override
  Widget build(final BuildContext context) {
    return ProfileSectionBody(
      title: 'profile.settings.title'.tr(),
      items: <Widget>[
        ProfileMenuItem(
          icon: Icons.language_outlined,
          title: 'profile.settings.language'.tr(),
          subtitle: context.isArabic
              ? 'profile.settings.arabic'.tr()
              : 'profile.settings.english'.tr(),
          onTap: () => _showLanguageDialog(context),
        ),
        Divider(
          height: 1,
          indent: rw(60),
          endIndent: rw(20),
          color: context.customColors.border,
        ),
        ProfileMenuItem(
          icon: Icons.palette_outlined,
          title: 'profile.settings.theme'.tr(),
          subtitle: context.isDarkMode
              ? 'profile.settings.dark'.tr()
              : 'profile.settings.light'.tr(),
          onTap: () => _showThemeDialog(context),
        ),
        Divider(
          height: 1,
          indent: rw(60),
          endIndent: rw(20),
          color: context.customColors.border,
        ),
        verticalSpacing(8),
        InkWell(
          onTap: () {
            AppDialogs.showConfirm(
              context,
              title: 'profile.settings.logout'.tr(),
              message: 'profile.settings.logout_message'.tr(),
              onConfirm: () {
                context.read<AuthCubit>().logout();
              },
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: rw(16), vertical: rh(12)),
            child: Row(
              children: [
                const Icon(Icons.logout, color: AppColors.red100),
                horizontalSpacing(12),
                Text(
                  'profile.settings.logout'.tr(),
                  style: AppTextStyles.font16Bold.copyWith(
                    color: AppColors.red100,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  color: context.customColors.textSecondary.withAlpha(100),
                  size: rw(16),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showLanguageDialog(final BuildContext context) {
    showDialog(
      context: context,
      builder: (final dialogContext) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(rw(24)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'profile.settings.select_language'.tr(),
                style: AppTextStyles.font18Bold.copyWith(
                  color: context.customColors.textPrimary,
                ),
              ),

              verticalSpacing(20),

              LanguageOption(
                title: 'profile.settings.english'.tr(),
                isSelected: !context.isArabic,
                onTap: () {
                  Navigator.pop(dialogContext);
                  switchLanguage(context);
                },
              ),

              verticalSpacing(12),

              LanguageOption(
                title: 'profile.settings.arabic'.tr(),
                isSelected: context.isArabic,
                onTap: () {
                  Navigator.pop(dialogContext);
                  switchLanguage(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showThemeDialog(final BuildContext parentContext) {
    showDialog(
      context: parentContext,
      builder: (final dialogContext) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(rw(24)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'profile.settings.select_theme'.tr(),
                style: AppTextStyles.font18Bold.copyWith(
                  color: parentContext.customColors.textPrimary,
                ),
              ),

              verticalSpacing(20),

              ThemeOption(
                title: 'profile.settings.light'.tr(),
                icon: Icons.light_mode,
                isSelected: !parentContext.isDarkMode,
                onTap: () {
                  Navigator.pop(dialogContext);
                  switchTheme(parentContext);
                },
              ),

              verticalSpacing(12),

              ThemeOption(
                title: 'profile.settings.dark'.tr(),
                icon: Icons.dark_mode,
                isSelected: parentContext.isDarkMode,
                onTap: () {
                  Navigator.pop(dialogContext);
                  switchTheme(parentContext);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
