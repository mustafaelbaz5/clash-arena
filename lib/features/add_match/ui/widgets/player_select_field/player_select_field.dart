import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:im_legends/core/utils/extensions/context_ext.dart';
import 'package:im_legends/features/add_match/logic/cubit/add_match_cubit.dart';

import '../../../../../core/utils/spacing.dart';
import 'player_field_avatar.dart';
import 'player_field_info.dart';
import 'players_bottom_sheet.dart';

class PlayerSelectField extends StatelessWidget {
  final void Function(String id, String name, String imageUrl) onSelected;
  final String hint;
  final String? selectedPlayerId;
  final String? selectedName;
  final String? selectedImageUrl;
  final String? excludedPlayer;
  final Color? accentColor;
  final bool isWinnerField;
  const PlayerSelectField({
    super.key,
    required this.onSelected,
    this.hint = 'Select Player',
    this.selectedPlayerId,
    this.selectedName,
    this.selectedImageUrl,
    this.excludedPlayer,
    this.accentColor,
    required this.isWinnerField,
  });

  void _showPlayerDialog(final BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => PlayerBottomSheet(
        excludedPlayer: excludedPlayer,
        isWinnerField: isWinnerField,
        onSelect: (final id, final name, final imageUrl) =>
            onSelected(id, name, imageUrl),
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    final bool isSelected = selectedPlayerId != null;

    return GestureDetector(
      onTap: () {
        context.read<AddMatchCubit>().getPlayersList();
        _showPlayerDialog(context);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.symmetric(vertical: rh(8)),
        padding: EdgeInsets.symmetric(horizontal: rw(16), vertical: rh(10)),
        height: rh(64),
        decoration: BoxDecoration(
          color: isSelected
              ? context.customColors.background.withAlpha(20)
              : context.customColors.background,
          borderRadius: BorderRadius.circular(rr(16)),
          border: Border.all(
            color: isSelected
                ? accentColor ?? context.customColors.textPrimary
                : context.customColors.border,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Player avatar
            PlayerFieldAvatar(
              isSelected: isSelected,
              imageUrl: selectedImageUrl,
            ),
            horizontalSpacing(12),

            // Player info
            Expanded(
              child: PlayerFieldInfo(selectedPlayer: selectedName, hint: hint),
            ),

            // Arrow indicator
            AnimatedRotation(
              turns: isSelected ? 0.5 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: isSelected
                    ? context.customColors.textPrimary
                    : context.customColors.textSecondary,
                size: rf(24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
