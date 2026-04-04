import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:im_legends/core/utils/extensions/context_ext.dart';

import '../themes/app_colors.dart';
import '../themes/app_texts_style.dart';
import '../utils/spacing.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key, this.error, this.onRetry});

  final String? error;
  final VoidCallback? onRetry;

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            onRetry?.call();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Error Icon
                    Container(
                      padding: EdgeInsets.all(rw(24)),
                      decoration: BoxDecoration(
                        color: AppColors.red100.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.error_outline_rounded,
                        size: rf(80),
                        color: AppColors.red100,
                      ),
                    ),

                    verticalSpacing(32),

                    // Title
                    Text(
                      'errors.error_screen_title'.tr(),
                      style: AppTextStyles.font20Bold,
                      textAlign: TextAlign.center,
                    ),

                    verticalSpacing(8),

                    // Description
                    Text(
                      'errors.error_screen_desc'.tr(),
                      style: AppTextStyles.font14Regular.copyWith(
                        color: context.customColors.textSecondary,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    if (error != null) ...[
                      verticalSpacing(16),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: rw(16)),
                        child: Text(
                          error!,
                          style: AppTextStyles.font12Regular.copyWith(
                            color: context.customColors.textSecondary,
                          ),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],

                    verticalSpacing(16),

                    // Retry Button
                    if (onRetry != null)
                      GestureDetector(
                        onTap: onRetry,
                        child: Text(
                          'errors.error_screen_button'.tr(),
                          style: AppTextStyles.font14Bold.copyWith(
                            color: AppColors.red100,
                          ),
                        ),
                      ),

                    verticalSpacing(16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
