import 'package:flutter/material.dart';
import 'package:im_legends/core/utils/extensions/context_ext.dart';

import '../../themes/app_colors.dart';
import '../../themes/app_texts_style.dart';
import '../../utils/spacing.dart';

class OverlayLoader extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? message;

  const OverlayLoader({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
  });

  @override
  Widget build(final BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: AbsorbPointer(
              absorbing: true,
              child: Container(
                color: context.customColors.background.withValues(alpha: 0.8),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(
                        color: AppColors.primary300,
                      ),
                      if (message != null) ...[
                        verticalSpacing(16),
                        Text(
                          message!,
                          style: AppTextStyles.font16Regular.copyWith(
                            color: context.customColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
