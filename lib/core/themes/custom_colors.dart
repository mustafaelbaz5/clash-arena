import 'package:flutter/material.dart';
import 'app_colors.dart';

/// CustomColors — semantic theme tokens
/// ─────────────────────────────────────
/// These are theme-aware colors used across widgets.
/// Always access via: Theme.of(context).customColors
///
/// Light/Dark values are set in [_light()] and [_dark()] factories.

class CustomColors {
  // ─── Text ─────────────────────────────────────
  final Color textPrimary;
  final Color textSecondary;
  final Color textHint;
  final Color textDisabled;
  final Color textInverse; // text on dark/primary backgrounds

  // ─── Background ───────────────────────────────
  final Color background;
  final Color backgroundSecondary; // cards, sheets, etc.
  final Color backgroundInverse;

  // ─── Surface / Container ──────────────────────
  final Color surface;
  final Color surfaceVariant; // slightly different surface

  // ─── Border & Divider ─────────────────────────
  final Color border;
  final Color divider;

  // ─── Icon ─────────────────────────────────────
  final Color iconPrimary;
  final Color iconSecondary;

  // ─── Status ───────────────────────────────────
  final Color success;
  final Color successBackground;
  final Color warning;
  final Color warningBackground;
  final Color error;
  final Color errorBackground;
  final Color info;
  final Color infoBackground;

  const CustomColors._({
    required this.textPrimary,
    required this.textSecondary,
    required this.textHint,
    required this.textDisabled,
    required this.textInverse,
    required this.background,
    required this.backgroundSecondary,
    required this.backgroundInverse,
    required this.surface,
    required this.surfaceVariant,
    required this.border,
    required this.divider,
    required this.iconPrimary,
    required this.iconSecondary,
    required this.success,
    required this.successBackground,
    required this.warning,
    required this.warningBackground,
    required this.error,
    required this.errorBackground,
    required this.info,
    required this.infoBackground,
  });

  factory CustomColors.light() {
    return const CustomColors._(
      // Text
      textPrimary: AppColors.black,
      textSecondary: AppColors.grey600,
      textHint: AppColors.grey400,
      textDisabled: AppColors.grey300,
      textInverse: AppColors.white,

      // Background
      background: AppColors.backgroundLight,
      backgroundSecondary: AppColors.grey50,
      backgroundInverse: AppColors.black,

      // Surface
      surface: AppColors.white,
      surfaceVariant: AppColors.grey100,

      // Border & Divider
      border: AppColors.grey200,
      divider: AppColors.grey100,

      // Icon
      iconPrimary: AppColors.grey700,
      iconSecondary: AppColors.grey400,

      // Status
      success: AppColors.green200,
      successBackground: AppColors.green0,
      warning: AppColors.amber200,
      warningBackground: AppColors.amber0,
      error: AppColors.red200,
      errorBackground: AppColors.red0,
      info: AppColors.blue200,
      infoBackground: AppColors.blue0,
    );
  }

  factory CustomColors.dark() {
    return const CustomColors._(
      // Text
      textPrimary: AppColors.white,
      textSecondary: AppColors.grey300,
      textHint: AppColors.grey500,
      textDisabled: AppColors.grey600,
      textInverse: AppColors.black,

      // Background
      background: AppColors.backgroundDark,
      backgroundSecondary: AppColors.grey800,
      backgroundInverse: AppColors.white,

      // Surface
      surface: AppColors.grey800,
      surfaceVariant: AppColors.grey700,

      // Border & Divider
      border: AppColors.grey600,
      divider: AppColors.grey700,

      // Icon
      iconPrimary: AppColors.grey200,
      iconSecondary: AppColors.grey500,

      // Status
      success: AppColors.green200,
      successBackground: AppColors.green400,
      warning: AppColors.amber200,
      warningBackground: AppColors.amber400,
      error: AppColors.red200,
      errorBackground: AppColors.red400,
      info: AppColors.blue200,
      infoBackground: AppColors.blue400,
    );
  }
}
