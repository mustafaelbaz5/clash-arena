import 'package:flutter/material.dart';
import 'package:im_legends/core/utils/extensions/context_ext.dart';

import '../../../../../core/themes/app_texts_style.dart';

class PlayerFieldInfo extends StatelessWidget {
  final String? selectedPlayer;
  final String hint;

  const PlayerFieldInfo({super.key, this.selectedPlayer, required this.hint});

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 300),
          style: AppTextStyles.font14Regular.copyWith(
            color: context.customColors.textPrimary,
          ),
          child: Text(
            selectedPlayer ?? hint,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
