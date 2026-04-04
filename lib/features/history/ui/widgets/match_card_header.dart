import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:im_legends/core/utils/extensions/context_ext.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_texts_style.dart';
import '../../../../core/utils/functions/date_formate.dart';

class MatchCardHeader extends StatelessWidget {
  final DateTime matchDate;

  const MatchCardHeader({super.key, required this.matchDate});

  @override
  Widget build(final BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            dateDetailedFormat(matchDate),
            style: AppTextStyles.font12Regular.copyWith(
              color: context.customColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Icon(Icons.sports_soccer, color: AppColors.primary300, size: 24.sp),
      ],
    );
  }
}
