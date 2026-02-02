import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.backgroundColor,
      primaryColor: AppColors.primaryBlackColor,
      canvasColor: Colors.transparent,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryBlackColor),
      fontFamily: 'Inter',
    );
  }
}
