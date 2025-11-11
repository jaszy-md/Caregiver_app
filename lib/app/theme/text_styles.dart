import 'package:flutter/material.dart';
import 'colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const headline = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 32,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryDarkGreen,
  );

  static const body = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 16,
    color: AppColors.primaryDarkGreen,
  );

  static const caption = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 14,
    color: AppColors.primaryLightGreen,
  );
}
