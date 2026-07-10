import 'package:flutter/material.dart';
import '../app_texts_style.dart';

import '../app_colors.dart';

ThemeData getLightTheme() {
  return ThemeData(
    brightness: Brightness.light,

    // ─── Text ─────────────────────────────────────────────────────────────
    textTheme: ThemeData.light().textTheme.apply(
      bodyColor: AppColors.black,
      displayColor: AppColors.black,
    ),

    // ─── Elevated Button ──────────────────────────────────────────────────
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary200,
        foregroundColor: AppColors.white,
        disabledBackgroundColor: AppColors.grey100,
        disabledForegroundColor: AppColors.grey400,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: AppTextStyles.font16Bold,
      ),
    ),

    // ─── Text Button ──────────────────────────────────────────────────────
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary200,
        textStyle: AppTextStyles.font16Bold,
      ),
    ),

    // ─── Outlined Button ──────────────────────────────────────────────────
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary200,
        side: const BorderSide(color: AppColors.primary200),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: AppTextStyles.font16Bold,
      ),
    ),

    // ─── Input Decoration ─────────────────────────────────────────────────
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: WidgetStateColor.resolveWith((final states) {
        if (states.contains(WidgetState.focused)) return AppColors.primary50;
        return AppColors.white;
      }),
      hintStyle: AppTextStyles.font16Regular.copyWith(color: AppColors.grey400),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.grey200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.grey200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primary200),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.red200),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.red300),
      ),
    ),

    // ─── Card ─────────────────────────────────────────────────────────────
    cardTheme: CardThemeData(
      color: AppColors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.grey100),
      ),
    ),

    // ─── Divider ──────────────────────────────────────────────────────────
    dividerTheme: const DividerThemeData(
      color: AppColors.grey100,
      thickness: 1,
    ),

    // ─── Icon ─────────────────────────────────────────────────────────────
    iconTheme: const IconThemeData(color: AppColors.grey700),
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary200,
      brightness: Brightness.light,
      primary: AppColors.primary200,
      onPrimary: AppColors.white,
      secondary: AppColors.secondary200,
      onSecondary: AppColors.white,
      surface: AppColors.white,
      onSurface: AppColors.black,
      error: AppColors.red200,
      onError: AppColors.white,
    ).copyWith(surface: AppColors.backgroundLight),
  );
}
