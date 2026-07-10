import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../../../core/ui/dialogs/app_dialogs.dart';
import '../../../core/utils/extensions/context_ext.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../logic/cubit/match_request_cubit.dart';
import 'widgets/create_match_request_sheet.dart';

/// Replaces the old direct-insert "Add Match" flow: submitting here creates
/// a match_request that the opponent must accept before it counts, instead
/// of writing straight into `matches`.
class CreateMatchRequestScreen extends StatelessWidget {
  const CreateMatchRequestScreen({super.key, required this.controller});

  final PersistentTabController controller;

  @override
  Widget build(final BuildContext context) {
    // Needs its own Scaffold: this screen is embedded directly as a bottom
    // nav tab (no ancestor Scaffold), but showErrorSnackBar requires a
    // ScaffoldMessenger with a registered Scaffold to present into.
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(title: 'add_match.add_match'.tr()),
            Expanded(
              child: BlocListener<MatchRequestCubit, MatchRequestState>(
                listener: (final context, final state) {
                  if (state is MatchRequestActionFailure) {
                    debugPrint(
                      'MatchRequestActionFailure: ${state.error.message}',
                    );
                    context.showErrorSnackBar(state.error.message);
                  }
                },
                child: SingleChildScrollView(
                  child: CreateMatchRequestSheet(
                    onSuccess: () {
                      AppDialogs.showSuccess(
                        context,
                        message:
                            'Match request sent — waiting for your opponent to accept.',
                        onPressed: () => controller.jumpToTab(0),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
