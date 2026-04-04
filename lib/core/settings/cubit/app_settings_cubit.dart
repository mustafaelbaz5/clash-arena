import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'app_settings_state.dart';

class AppSettingsCubit extends HydratedCubit<AppSettingsState> {
  AppSettingsCubit() : super(AppSettingsState.initial());

  static const _themeKey = 'themeMode';
  static const _localeKey = 'locale';

  void updateTheme(final ThemeMode mode) {
    emit(state.copyWith(themeMode: mode));
  }

  void toggleTheme() {
    final next =
        state.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    emit(state.copyWith(themeMode: next));
  }

  void updateLocale(final BuildContext context, final Locale locale) {
    context.setLocale(locale); // easy_localization handles translation files
    emit(state.copyWith(locale: locale));
  }

  void toggleLocale(final BuildContext context) {
    final next = state.isArabic ? const Locale('en') : const Locale('ar');
    updateLocale(context, next);
  }

  // ── HydratedBloc Serialization ────────────────────────────────────────────

  @override
  AppSettingsState? fromJson(final Map<String, dynamic> json) {
    try {
      final themeMode = _themeFromString(json[_themeKey] as String?);
      final locale = Locale(json[_localeKey] as String? ?? 'en');
      return AppSettingsState(themeMode: themeMode, locale: locale);
    } catch (_) {
      return AppSettingsState.initial();
    }
  }

  @override
  Map<String, dynamic>? toJson(final AppSettingsState state) {
    return {
      _themeKey: _themeToString(state.themeMode),
      _localeKey: state.locale.languageCode,
    };
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  ThemeMode _themeFromString(final String? value) {
    return switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  String _themeToString(final ThemeMode mode) {
    return switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
  }
}
