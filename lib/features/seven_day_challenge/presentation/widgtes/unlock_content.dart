import 'package:flutter/material.dart';
import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/core/utils/responsive_config.dart';
import 'package:sbp_app/core/utils/text_styles.dart';

class UnlockContent extends StatelessWidget {
  const UnlockContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 24.h),
        Text(
          "Tracking Is Now Unlocked",
          style: AppTextStyles.headingTextStyleBogart.copyWith(
            color: AppColors.primaryBlackColor,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16.h),
        Text(
          "You’ve done the hard part.",
          style: AppTextStyles.bodyTextStyleBogart.copyWith(
            color: AppColors.textSecondaryColor,
            fontSize: 18.sp,
          ),
        ),
        SizedBox(height: 32.h),
        Text(
          "For the last 7 days, you didn’t rush to improve.\n\nYou slowed down.\n\nYou named what matters.\n\nYou chose your promises intentionally.\n\nTracking isn’t about control.\nIt’s about protecting what you’ve already chosen.",
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyTextStyle.copyWith(
            color: AppColors.textSecondaryColor,
          ),
        ),
        SizedBox(height: 32.h),
      ],
    );
  }
}