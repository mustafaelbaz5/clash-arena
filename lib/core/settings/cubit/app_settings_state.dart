import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../themes/app_font_family.dart';

class AppSettingsState extends Equatable {
  final ThemeMode themeMode;
  final Locale locale;

  const AppSettingsState({required this.themeMode, required this.locale});
  bool get isArabic => locale.languageCode == 'ar';
  bool get isEnglish => locale.languageCode == 'en';

  /// Default state
  factory AppSettingsState.initial() =>
      const AppSettingsState(themeMode: ThemeMode.system, locale: Locale('en'));

  /// Font family derived from locale — no manual switching needed
  String get fontFamily =>
      isArabic ? AppFontFamily.tajawal : AppFontFamily.inter;

  AppSettingsState copyWith({
    final ThemeMode? themeMode,
    final Locale? locale,
  }) {
    return AppSettingsState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
    );
  }

  @override
  List<Object?> get props => [themeMode, locale];
}
