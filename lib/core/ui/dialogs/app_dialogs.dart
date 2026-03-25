import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:im_legends/core/themes/app_colors.dart';

import 'custom_app_dialog.dart';

class AppDialogs {
  AppDialogs._();

  // ─── Info ─────────────────────────────────────────────────────────────
  static Future<void> showInfo(
    final BuildContext context, {
    final String? title,
    required final String message,
    final String? buttonText,
    final VoidCallback? onPressed,
  }) {
    return _show(
      barrierDismissible: false,
      context,
      CustomAppDialog(
        title: title ?? 'app_dialogs.info'.tr(),
        message: message,
        primaryButtonText: buttonText ?? 'app_dialogs.ok'.tr(),
        onPrimaryPressed: onPressed,
        icon: Icons.info_outline_rounded,
        iconColor: AppColors.blue200,
      ),
    );
  }

  // ─── Success ──────────────────────────────────────────────────────────
  static Future<void> showSuccess(
    final BuildContext context, {
    final String? title,
    required final String message,
    final String? buttonText,
    final VoidCallback? onPressed,
  }) {
    return _show(
      barrierDismissible: false,
      context,
      CustomAppDialog(
        title: title ?? 'app_dialogs.success'.tr(),
        message: message,
        primaryButtonText: buttonText ?? 'app_dialogs.ok'.tr(),
        onPrimaryPressed: onPressed,
        icon: Icons.check_circle_outline_rounded,
        iconColor: AppColors.green200,
      ),
    );
  }

  // ─── Error ────────────────────────────────────────────────────────────
  static Future<void> showError(
    final BuildContext context, {
    final String? title,
    required final String message,
    final String? buttonText,
    final VoidCallback? onPressed,
  }) {
    return _show(
      barrierDismissible: false,
      context,
      CustomAppDialog(
        title: title ?? 'app_dialogs.error'.tr(),
        message: message,
        primaryButtonText: buttonText ?? 'app_dialogs.close'.tr(),
        onPrimaryPressed: onPressed,
        icon: Icons.error_outline_rounded,
        iconColor: AppColors.red200,
      ),
    );
  }

  // ─── Warning ──────────────────────────────────────────────────────────
  static Future<void> showWarning(
    final BuildContext context, {
    final String? title,
    required final String message,
    final String? buttonText,
    final VoidCallback? onPressed,
  }) {
    return _show(
      barrierDismissible: false,
      context,
      CustomAppDialog(
        title: title ?? 'app_dialogs.warning'.tr(),
        message: message,
        primaryButtonText: buttonText ?? 'app_dialogs.ok'.tr(),
        onPrimaryPressed: onPressed,
        icon: Icons.warning_amber_rounded,
        iconColor: AppColors.amber200,
      ),
    );
  }

  // ─── Confirm ──────────────────────────────────────────────────────────
  static Future<void> showConfirm(
    final BuildContext context, {
    final String? title,
    required final String message,
    final String? confirmText,
    final String? cancelText,
    required final VoidCallback onConfirm,
    final VoidCallback? onCancel,
  }) {
    return _show(
      barrierDismissible: false,
      context,
      CustomAppDialog(
        title: title ?? 'app_dialogs.confirm'.tr(),
        message: message,
        primaryButtonText: confirmText ?? 'app_dialogs.yes'.tr(),
        secondaryButtonText: cancelText ?? 'app_dialogs.no'.tr(),
        onPrimaryPressed: onConfirm,
        onSecondaryPressed: onCancel,
        icon: Icons.help_outline_rounded,
        iconColor: AppColors.amber200,
      ),
    );
  }

  // ─── Custom ───────────────────────────────────────────────────────────
  static Future<void> showCustom(
    final BuildContext context, {
    required final CustomAppDialog dialog,
    final bool barrierDismissible = true,
  }) {
    return _show(context, dialog, barrierDismissible: barrierDismissible);
  }

  // ─── Internal helper ──────────────────────────────────────────────────
  static Future<void> _show(
    final BuildContext context,
    final Widget dialog, {
    final bool barrierDismissible = true,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (final _) => dialog,
    );
  }
}
