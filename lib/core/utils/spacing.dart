import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

SizedBox verticalSpacing(final double height) => SizedBox(height: height.h);
SizedBox horizontalSpacing(final double width) => SizedBox(width: width.w);

double rh(final double height) => height.h;
double rw(final double width) => width.w;

double rf(final double fontSize) => fontSize.sp;
double rr(final double radius) => radius.r;
