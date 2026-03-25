import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:im_legends/core/utils/extensions/context_ext.dart';

import '../../../core/router/routes.dart';
import '../../../core/themes/app_texts_style.dart';
import '../../../core/ui/dialogs/app_dialogs.dart';
import '../../../core/ui/loaders/overlay_loader.dart';
import '../../../core/utils/spacing.dart';
import '../logic/cubit/auth_cubit.dart';
import 'widgets/sign_up_form.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (final context, final state) {
            if (state is AuthError) {
              AppDialogs.showError(context, message: state.error.message);
            }
          },
          builder: (final context, final state) {
            return OverlayLoader(
              isLoading: state is AuthLoading,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: rw(16),
                  vertical: rh(8),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      verticalSpacing(40),
                      Text(
                        'auth.sign_up_title'.tr(),
                        style: AppTextStyles.font20Bold,
                      ),
                      verticalSpacing(32),
                      const SignUpForm(),
                      verticalSpacing(8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'auth.already_have_account'.tr(),
                            style: AppTextStyles.font12Regular,
                          ),
                          GestureDetector(
                            onTap: () => context.pushReplacementNamed(
                              Routes.loginScreen,
                            ),
                            child: Text(
                              'auth.login'.tr(),
                              style: AppTextStyles.font12SemiBold.copyWith(
                                color: context.customColors.info,
                                decorationThickness: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                      verticalSpacing(16),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
