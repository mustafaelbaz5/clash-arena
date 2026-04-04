import 'package:flutter/material.dart';

class LocalizationManager {
  LocalizationManager._();

  static const String translationsPath = 'assets/lang';
  static const Locale fallbackLocale = Locale('en');

  static const List<Locale> supportedLocales = [Locale('en'), Locale('ar')];
}
