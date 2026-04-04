import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();
  // ##Design Colors
  static const Color primary50 = Color(0xffb5d8c5);
  static const Color primary100 = Color(0xff91c6a9);
  static const Color primary200 = Color(0xff409b69); // ← main primary
  static const Color primary300 = Color(0xff20643f);
  static const Color primary400 = Color(0xff0f3d26);

  static const Color secondary50 = Color(0xffc5cae9);
  static const Color secondary100 = Color(0xff9fa8da);
  static const Color secondary200 = Color(0xff3f51b5); // ← main secondary
  static const Color secondary300 = Color(0xff283593);
  static const Color secondary400 = Color(0xff1a237e);

  // ##White And Black Colors
  static const Color white = Color(0xffffffff);
  static const Color grey50 = Color(0xffeceff3);
  static const Color grey100 = Color(0xffdfe1e7);
  static const Color grey200 = Color(0xffc1c7d0);
  static const Color grey300 = Color(0xffa4acb9);
  static const Color grey400 = Color(0xff818898);
  static const Color grey500 = Color(0xff666d80);
  static const Color grey600 = Color(0xff36394a);
  static const Color grey700 = Color(0xff272835);
  static const Color grey800 = Color(0xff262730);
  static const Color black = Color(0xff000000);

  //  ##GREEN — Success
  static const Color green0 = Color(0xfff0fdf4);
  static const Color green50 = Color(0xffdcfce7);
  static const Color green100 = Color(0xffbbf7d0);
  static const Color green200 = Color(0xff22c55e); // ← main
  static const Color green300 = Color(0xff16a34a);
  static const Color green400 = Color(0xff15803d);

  // ##RED — Error
  static const Color red0 = Color(0xfffff1f2);
  static const Color red50 = Color(0xffffe4e6);
  static const Color red100 = Color(0xfffecdd3);
  static const Color red200 = Color(0xffef4444); // ← main
  static const Color red300 = Color(0xffdc2626);
  static const Color red400 = Color(0xffb91c1c);

  // ##AMBER — Warning
  static const Color amber0 = Color(0xfffffbeb);
  static const Color amber50 = Color(0xfffef3c7);
  static const Color amber100 = Color(0xfffde68a);
  static const Color amber200 = Color(0xfff59e0b); // ← main
  static const Color amber300 = Color(0xffd97706);
  static const Color amber400 = Color(0xffb45309);

  // ##BLUE — Info
  static const Color blue0 = Color(0xffeff6ff);
  static const Color blue50 = Color(0xffdbeafe);
  static const Color blue100 = Color(0xffbfdbfe);
  static const Color blue200 = Color(0xff3b82f6); // ← main
  static const Color blue300 = Color(0xff2563eb);
  static const Color blue400 = Color(0xff1d4ed8);

  // ##Status Colors
  static const Color success = Color(0xFF00B894);
  static const Color warning = Color(0xFFFDAA5D);
  static const Color error = Color(0xFFE74C3C);
  static const Color info = Color(0xFF74B9FF);

  // ##BACKGROUND
  static const Color backgroundLight = Color(0xfff9fafb);
  static const Color backgroundDark = Color(0xff1C1D21);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary100, primary200, primary300],
  );
}
