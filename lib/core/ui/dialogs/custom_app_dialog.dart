import 'package:flutter/material.dart';
import 'package:im_legends/core/themes/app_colors.dart';
import 'package:im_legends/core/utils/extensions/context_ext.dart';
import 'package:im_legends/core/utils/spacing.dart';

import '../../themes/app_texts_style.dart';
import '../../widgets/custom_text_button.dart';

class CustomAppDialog extends StatelessWidget {
  const CustomAppDialog({
    super.key,
    this.title,
    required this.message,
    required this.primaryButtonText,
    this.onPrimaryPressed,
    this.secondaryButtonText,
    this.onSecondaryPressed,
    this.icon,
    this.iconColor,
    this.iconBackgroundColor,
    this.barrierDismissible = true,
  });

  final String? title;
  final String message;

  final String primaryButtonText;
  final VoidCallback? onPrimaryPressed;

  final String? secondaryButtonText;
  final VoidCallback? onSecondaryPressed;

  final IconData? icon;
  final Color? iconColor;
  final Color? iconBackgroundColor;

  final bool barrierDismissible;

  @override
  Widget build(final BuildContext context) {
    final colors = context.customColors;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: rw(32)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(rr(16)),
      ),
      backgroundColor: colors.surface,
      child: Padding(
        padding: EdgeInsets.all(rw(24)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ─── Icon ───────────────────────────────────
            if (icon != null) ...[
              Container(
                padding: EdgeInsets.all(rw(16)),
                decoration: BoxDecoration(
                  color:
                      (iconBackgroundColor ?? iconColor ?? AppColors.primary200)
                          .withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: rf(32),
                  color: iconColor ?? AppColors.primary200,
                ),
              ),
              verticalSpacing(16),
            ],

            // ─── Title ──────────────────────────────────
            if (title != null) ...[
              Text(
                title!,
                textAlign: TextAlign.center,
                style: AppTextStyles.font18Bold.copyWith(
                  color: colors.textPrimary,
                ),
              ),
              verticalSpacing(8),
            ],

            // ─── Message ────────────────────────────────
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.font14Regular.copyWith(
                color: colors.textSecondary,
              ),
            ),
            verticalSpacing(16),

            // ─── Buttons ────────────────────────────────
            if (secondaryButtonText != null)
              Row(
                children: [
                  Expanded(
                    child: CustomTextButton.outlined(
                      text: secondaryButtonText!,
                      size: CustomButtonSize.small,
                      onPressed: () {
                        context.pop();
                        onSecondaryPressed?.call();
                      },
                    ),
                  ),
                  horizontalSpacing(8),
                  Expanded(
                    child: CustomTextButton(
                      text: primaryButtonText,
                      size: CustomButtonSize.small,
                      onPressed: () {
                        context.pop();
                        onPrimaryPressed?.call();
                      },
                    ),
                  ),
                ],
              )
            else
              CustomTextButton(
                text: primaryButtonText,
                size: CustomButtonSize.small,
                onPressed: () {
                  context.pop();
                  onPrimaryPressed?.call();
                },
              ),
          ],
        ),
      ),
    );
  }
}
