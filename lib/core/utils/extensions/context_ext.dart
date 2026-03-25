import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../themes/custom_colors.dart';

// ─── Theme ───────────────────────────────────────────────────────────────────

extension ThemeExt on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;
  CustomColors get customColors => theme.customColors;
  bool get isDarkMode => theme.brightness == Brightness.dark;
}

extension CustomColorsExtension on ThemeData {
  CustomColors get customColors => brightness == Brightness.light
      ? CustomColors.light()
      : CustomColors.dark();
}

// ─── MediaQuery ───────────────────────────────────────────────────────────────

extension MediaQueryExt on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  bool get isKeyboardVisible => MediaQuery.viewInsetsOf(this).bottom > 0;
}

// ─── Locale & Font ───────────────────────────────────────────────────────────

extension LocaleExt on BuildContext {
  Locale get currentLocale => EasyLocalization.of(this)!.locale;
  bool get isArabic => currentLocale.languageCode == 'ar';
}

// ─── SnackBar ─────────────────────────────────────────────────────────────────

extension SnackBarExt on BuildContext {
  void hideKeyboard() => FocusScope.of(this).unfocus();

  void showSnackBar(
    final String message, {
    final Duration duration = const Duration(seconds: 3),
    final SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: Text(message), duration: duration, action: action),
    );
  }

  void showErrorSnackBar(final String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: colorScheme.error,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void showSuccessSnackBar(final String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

// ─── Navigation ───────────────────────────────────────────────────────────────

extension NavigationExt on BuildContext {
  Future<T?> push<T>(final Widget page) =>
      Navigator.push(this, MaterialPageRoute(builder: (final _) => page));

  Future<T?> pushReplacement<T, TO>(final Widget page, {final TO? result}) =>
      Navigator.pushReplacement(
        this,
        MaterialPageRoute(builder: (final _) => page),
        result: result,
      );

  Future<T?> pushAndRemoveAll<T>(final Widget page) =>
      Navigator.pushAndRemoveUntil(
        this,
        MaterialPageRoute(builder: (final _) => page),
        (final _) => false,
      );

  void pop<T>([final T? result]) {
    if (mounted) Navigator.pop(this, result);
  }

  Future<T?> pushNamed<T>(final String routeName, {final Object? arguments}) =>
      Navigator.pushNamed(this, routeName, arguments: arguments);

  Future<T?> pushReplacementNamed<T, TO>(
    final String routeName, {
    final Object? arguments,
    final TO? result,
  }) => Navigator.pushReplacementNamed(
    this,
    routeName,
    arguments: arguments,
    result: result,
  );

  Future<T?> pushNamedAndRemoveAll<T>(
    final String routeName, {
    final Object? arguments,
  }) => Navigator.pushNamedAndRemoveUntil(
    this,
    routeName,
    (final _) => false,
    arguments: arguments,
  );
}
