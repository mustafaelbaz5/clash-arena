import 'package:flutter/material.dart';
import '../../../../core/utils/spacing.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_texts_style.dart';
import '../../data/models/match_history_card_model.dart';

class ScoreDisplay extends StatelessWidget {
  final MatchHistoryCardModel match;

  const ScoreDisplay({super.key, required this.match});

  @override
  Widget build(final BuildContext context) {
    return Row(
      children: [
        Text(
          '${match.winnerScore}',
          style: AppTextStyles.fontBold.copyWith(
            color: AppColors.green100,
            fontSize: rf(24),
          ),
        ),
        const Text('    -    ', style: AppTextStyles.fontBold),
        Text(
          '${match.loserScore}',
          style: AppTextStyles.fontRegular.copyWith(
            fontSize: rf(20),
          ),
        ),
      ],
    );
  }
}
