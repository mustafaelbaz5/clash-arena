import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clash_arena/core/utils/functions/refresh_page.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../../../../core/models/match_model.dart';
import '../../../../core/ui/dialogs/app_dialogs.dart';
import '../../../../core/ui/loaders/overlay_loader.dart';
import '../../../../core/utils/spacing.dart';
import '../../../../core/widgets/custom_text_button.dart';
import '../../logic/cubit/add_match_cubit.dart';

class AddMatchBlocConsumer extends StatelessWidget {
  const AddMatchBlocConsumer({super.key, required this.controller});

  final PersistentTabController controller;

  @override
  Widget build(final BuildContext context) {
    return BlocConsumer<AddMatchCubit, AddMatchState>(
      listener: (final context, final state) {
        if (state.isSuccess) {
          AppDialogs.showSuccess(
            context,
            message: "add_match.add_match_success".tr(),
            onPressed: () {
              context.read<AddMatchCubit>().resetMatchData();
              controller.jumpToTab(0); // ← jump to Home
            },
          );
        }
      },
      builder: (final context, final state) {
        final isEnabled = context.read<AddMatchCubit>().canSubmit();
        return OverlayLoader(
          isLoading: state.isLoading,
          child: SizedBox(
            width: rw(280),
            child: CustomTextButton(
              size: CustomButtonSize.large,
              isDisabled: !isEnabled,
              text: "add_match.add".tr(),
              onPressed: isEnabled
                  ? () {
                      final match = MatchModel(
                        winnerId: state.winnerId!,
                        loserId: state.loserId!,
                        winnerScore: state.winnerScore,
                        loserScore: state.loserScore,
                      );
                      context.read<AddMatchCubit>().addMatch(match);
                      refreshData(context);
                    }
                  : null,
            ),
          ),
        );
      },
    );
  }
}
