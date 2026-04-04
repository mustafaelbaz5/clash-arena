import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:im_legends/core/settings/cubit/app_settings_cubit.dart';

void switchLanguage(final BuildContext context) {
  context.read<AppSettingsCubit>().toggleLocale(context);
}

/// Switch Theme between Light and Dark
void switchTheme(final BuildContext context) {
  context.read<AppSettingsCubit>().toggleTheme();
}
