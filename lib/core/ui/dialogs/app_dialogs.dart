import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../themes/app_colors.dart';
import 'custom_dialog.dart';

class AppDialogs {
  AppDialogs._();

  static Future<void> showCustomDialog(
    final BuildContext context, {
    final String? title,
    required final String message,
    final String? buttonText,
    final void Function()? onPressed,
  }) {
    return showDialog(
      context: context,
      builder: (_) => CustomDialog(
        title: title ?? 'app_dialogs.info'.tr(),
        message: message,
        primaryButtonText: buttonText ?? 'app_dialogs.ok'.tr(),
        onPrimaryPressed: onPressed,
        icon: Icons.info_outline,
        iconColor: AppColors.amber200,
      ),
    );
  }

  static Future<void> showError(
    final BuildContext context, {
    final String? title,
    required final String message,
    final String? buttonText,
  }) {
    return showDialog(
      context: context,
      builder: (_) => CustomDialog(
        title: title ?? 'app_dialogs.error'.tr(),
        message: message,
        primaryButtonText: buttonText ?? 'app_dialogs.close'.tr(),
        icon: Icons.error_outline,
        iconColor: AppColors.red200,
      ),
    );
  }

  static Future<void> showSuccess(
    final BuildContext context, {
    final String? title,
    required final String message,
    final String? buttonText,
    final VoidCallback? onPressed,
  }) {
    return showDialog(
      context: context,
      builder: (_) => CustomDialog(
        title: title ?? 'app_dialogs.success'.tr(),
        message: message,
        primaryButtonText: buttonText ?? 'app_dialogs.ok'.tr(),
        icon: Icons.check_circle_outline,
        iconColor: AppColors.green300,
        onPrimaryPressed: onPressed,
      ),
    );
  }

  static Future<void> showConfirm(
    final BuildContext context, {
    final String? title,
    required final String message,
    final String? confirmText,
    final String? cancelText,
    required final VoidCallback onConfirm,
  }) {
    return showDialog(
      context: context,
      builder: (_) => CustomDialog(
        title: title ?? 'app_dialogs.confirm'.tr(),
        message: message,
        primaryButtonText: confirmText ?? 'app_dialogs.yes'.tr(),
        secondaryButtonText: cancelText ?? 'app_dialogs.no'.tr(),
        onPrimaryPressed: onConfirm,
      ),
    );
  }
}
