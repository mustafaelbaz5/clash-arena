import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:im_legends/core/utils/extensions/context_ext.dart';

import '../../../../core/themes/app_texts_style.dart';
import '../../../../core/utils/spacing.dart';
import '../../logic/cubit/add_match_cubit.dart';

class ScoreInputField extends StatelessWidget {
  final Color accentColor;
  final bool isWinner;

  const ScoreInputField({
    super.key,
    required this.accentColor,
    required this.isWinner,
  });

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<AddMatchCubit, AddMatchState>(
      buildWhen: (final prev, final curr) => isWinner
          ? prev.winnerScore != curr.winnerScore
          : prev.loserScore != curr.loserScore,
      builder: (final context, final state) {
        final score = isWinner ? state.winnerScore : state.loserScore;
        final cubit = context.read<AddMatchCubit>();

        final isDecrementEnabled = score > 0;
        final isIncrementEnabled = isWinner ? true : cubit.canIncrementLoser();

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: rh(56),
          width: rw(320),
          padding: EdgeInsets.symmetric(horizontal: rw(12)),
          decoration: BoxDecoration(
            color: context.customColors.background,
            borderRadius: BorderRadius.circular(rr(16)),
            border: Border.all(color: accentColor.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildControlButton(
                context,
                icon: Icons.remove_rounded,
                isEnabled: isDecrementEnabled,
                onTap: () {
                  if (isWinner) {
                    cubit.updateWinnerScore(-1);
                  } else {
                    cubit.updateLoserScore(-1);
                  }
                },
              ),
              const Spacer(),
              Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Text(
                    score.toString(),
                    key: ValueKey(score),
                    style: AppTextStyles.font20Bold.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.customColors.textPrimary,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              _buildControlButton(
                context,
                icon: Icons.add_rounded,
                isEnabled: isIncrementEnabled,
                onTap: () {
                  if (isWinner) {
                    cubit.updateWinnerScore(1);
                  } else {
                    cubit.updateLoserScore(1);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildControlButton(
    final BuildContext context, {
    required final IconData icon,
    required final bool isEnabled,
    required final VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: isEnabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: rh(36),
        width: rw(36),
        decoration: BoxDecoration(
          color: isEnabled
              ? accentColor.withValues(alpha: 0.3)
              : accentColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          size: rf(20),
          color: isEnabled
              ? context.customColors.textPrimary
              : context.customColors.textSecondary.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}
