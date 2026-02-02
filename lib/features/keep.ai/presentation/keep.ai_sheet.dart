import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sbp_app/core/utils/text_styles.dart';
import 'package:sbp_app/features/shared/widgets/bottom_height_widget.dart';
import 'package:sbp_app/features/shared/widgets/w_app_text_logo.dart';
import 'package:sbp_app/features/shared/widgets/w_primary_button.dart';

import '../../../core/constants/assets.dart';
import '../../../core/theming/app_colors.dart';
import '../../../core/utils/responsive_config.dart';

class KeepAiSheet extends StatelessWidget {
  const KeepAiSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Container(
      height: screenHeight * 0.9,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      child: Column(
        children: [
          SizedBox(height: 12.h),
          Container(
            height: 5.h,
            width: 40.w,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          SizedBox(height: 32.h),

          const AppNameLogo(),

          SizedBox(height: 44.h),

          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: SvgPicture.asset(
                    Assets.svgBottomBarMainIcon,
                    width: 36.w,
                    height: 36.w,
                  ),
                ),

                SizedBox(width: 16.w),

                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(20.r),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.r),
                        topRight: Radius.circular(20.r),
                        bottomRight: Radius.circular(20.r),
                        bottomLeft: Radius.circular(20.r),
                      ),
                    ),
                    child: RichText(
                      text: TextSpan(
                        style: AppTextStyles.bodyTextStyleBogart.copyWith(
                          color: Colors.black,
                          fontSize: 16.sp,
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                        ),
                        children: const [
                          TextSpan(text: "Hey, I'm "),
                          TextSpan(
                            text: "Keep.ai",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text:
                                ", but you can call me Keep for short. Congrats on making your One Promise for 2026! I'm going to be helping you manage everything from the Promises you make to when and how you keep them. When I know enough, I'll start making suggestions to help you keep them even better!",
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          PrimaryButton(
            text: "Okay",
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          BottomHeightWidget(),
        ],
      ),
    );
  }
}
