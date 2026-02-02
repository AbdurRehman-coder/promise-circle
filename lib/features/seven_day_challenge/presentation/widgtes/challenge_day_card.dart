import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/core/utils/responsive_config.dart';
import 'package:sbp_app/core/utils/text_styles.dart';
import 'package:sbp_app/features/shared/widgets/w_app_text_logo.dart';
import '../../models/seven_day_challenge_model.dart';
import '../../utils/challenge_utils.dart';
import 'challenge_examples_section.dart';

class ChallengeDayCard extends StatelessWidget {
  final int dayIndex;
  final ChallengeDayContent content;
  final AnimationController animationController;

  const ChallengeDayCard({
    super.key,
    required this.dayIndex,
    required this.content,
    required this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ChallengeHeader(dayIndex: dayIndex),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          decoration: BoxDecoration(
            color: ChallengeUtils.getDayColor(dayIndex),
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Column(
            children: [
              Text(
                content.title,
                textAlign: TextAlign.center,
                style: AppTextStyles.headingTextStyleBogart.copyWith(
                  color: AppColors.primaryBlackColor,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 34.h),
              SizedBox(
                height: 300.h,
                child: SvgPicture.asset(
                  ChallengeUtils.getDayIllustration(dayIndex),
                  fit: BoxFit.contain,
                  placeholderBuilder: (context) =>
                      const Center(child: CircularProgressIndicator()),
                ),
              ),
              SizedBox(height: 34.h),
              if (content.prompt != null) ...[
                Text(
                  content.prompt!,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.headingTextStyleBogart.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryBlackColor,
                  ),
                ),
                SizedBox(height: 16.h),
              ],
              if (dayIndex != 6)
                Text(
                  content.body,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.mediumBodyTextStyle.copyWith(
                    color: AppColors.primaryBlackColor.withOpacity(0.85),
                    fontSize: 14.sp,
                  ),
                ),
              if (dayIndex == 5) ...[
                SizedBox(height: 34.h),
                Text(
                  "Limit yourself to just one today.",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.mediumBodyTextStyle.copyWith(
                    color: AppColors.primaryBlackColor.withOpacity(0.85),
                    fontSize: 12.sp,
                  ),
                ),
              ],
              if (content.examples.isNotEmpty && dayIndex != 6) ...[
                SizedBox(height: 34.h),
                Text(
                  "EXAMPLE",
                  style: AppTextStyles.boldBodyTextStyle.copyWith(
                    color: ChallengeUtils.getBorderColorForDay(dayIndex),
                    fontSize: 12.sp,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 16.h),
              ],
              ChallengeExamplesSection(
                content: content,
                dayIndex: dayIndex,
                animationController: animationController,
              ),
              if (dayIndex == 6) ...[
                SizedBox(height: 16.h),
                Text(
                  content.body,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.mediumBodyTextStyle.copyWith(
                    color: AppColors.primaryBlackColor.withOpacity(0.85),
                    fontSize: 14.sp,
                  ),
                ),
              ],
              
              SizedBox(height: 34.h),
              Text(
                content.bottomCopy,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyTextStyleBogart.copyWith(
                  fontSize: 14.sp,
                  color: AppColors.primaryBlackColor.withOpacity(0.85),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5.h),
            ],
          ),
        ),
      ],
    );
  }
}

class _ChallengeHeader extends StatelessWidget {
  final int dayIndex;

  const _ChallengeHeader({required this.dayIndex});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 36.h),
        AppNameLogo(),
        SizedBox(height: 24.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: const Color(0xFFF3E6D3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            "Day $dayIndex",
            style: AppTextStyles.boldBodyTextStyle.copyWith(
              color: const Color(0xFF8E8475),
              fontSize: 12.sp,
              letterSpacing: 0.5,
            ),
          ),
        ),
        SizedBox(height: 12.h),
      ],
    );
  }
}