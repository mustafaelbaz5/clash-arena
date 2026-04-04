import 'package:flutter/material.dart';
import 'package:im_legends/core/utils/extensions/context_ext.dart';

import '../../../../../../core/utils/spacing.dart';
import '../../../../core/themes/app_texts_style.dart';

class ProfileSectionBody extends StatelessWidget {
  final String title;
  final List<Widget> items;

  const ProfileSectionBody({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(final BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: rw(16)),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: AppTextStyles.font16Bold.copyWith(
              color: context.customColors.textPrimary,
            ),
          ),
          ...items,
        ],
      ),
    );
  }
}
