import 'package:flutter/material.dart';
import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/core/utils/responsive_config.dart';

class AppTextStyles {
  static TextStyle headingTextStyle = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 32.sp,
    height: 57 / 40,
    letterSpacing: 0,
    fontFamily: "Inter",
  );
  static TextStyle headingTextStyleBogart = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 32.sp,
    height: 1.2,
    letterSpacing: -1,
    fontFamily: "Bogart",
  );

  static TextStyle bodyTextStyleBogart = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16.sp,
    height: 22 / 18,
    letterSpacing: 0,
    fontFamily: "Bogart",
  );

  static TextStyle bodyTextStyle = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16.sp,
    height: 22 / 18,
    letterSpacing: 0,
    fontFamily: "Inter",
  );
  static TextStyle boldBodyTextStyle = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 14.sp,
    height: 22 / 18,
    letterSpacing: 0,
    fontFamily: "Inter",
    color: AppColors.primaryBlackColor.withValues(alpha: 0.75),
  );
  static TextStyle semiBoldBodyTextStyle = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 14.sp,
    height: 22 / 18,
    letterSpacing: 0,
    fontFamily: "Inter",
    color: AppColors.primaryBlackColor.withValues(alpha: 0.75),
  );
  static TextStyle mediumBodyTextStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 14.sp,
    height: 22 / 18,
    letterSpacing: 0,
    fontFamily: "Inter",
    color: AppColors.primaryBlackColor.withValues(alpha: 0.75),
  );

  static TextStyle buttonTextStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 16.sp,
    height: 24 / 18,
    letterSpacing: 0,
    color: AppColors.whiteColor,
    fontFamily: "Inter",
  );
}
