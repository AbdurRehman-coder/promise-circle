import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/core/utils/responsive_config.dart';
import 'package:sbp_app/core/utils/text_styles.dart';
import 'package:sbp_app/features/shared/widgets/squiggly_container.dart';
import '../../../promise/provider/promise_list_provider.dart';
import '../../models/seven_day_challenge_model.dart';
import '../../utils/challenge_utils.dart';
import 'staggered_item.dart';

class ChallengeExamplesSection extends ConsumerWidget {
  final ChallengeDayContent content;
  final int dayIndex;
  final AnimationController animationController;

  const ChallengeExamplesSection({
    super.key,
    required this.content,
    required this.dayIndex,
    required this.animationController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (dayIndex == 6) {
      return Padding(
        padding: EdgeInsets.only(top: 12.h),
        child: Row(
          children: [
            for (int i = 0; i < content.examples.length; i++) ...[
              if (i > 0) SizedBox(width: 12.w),
              Expanded(
                child: StaggeredItem(
                  index: i,
                  animationController: animationController,
                  child: SizedBox(
                    height: 60.h,
                    child: SquigglyContainer(
                      borderColor: const Color(0xFFBEA479),
                      child: Center(
                        child: Text(
                          content.examples[i],
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyTextStyleBogart.copyWith(
                            color: AppColors.primaryBlackColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    }

    if (dayIndex == 7) {
      final promiseListProvider = ref.read(promisesProvider);
      return Padding(
        padding: EdgeInsets.only(top: 34.h),
        child: Row(
          children: [
            Expanded(
              child: StaggeredItem(
                index: 0,
                animationController: animationController,
                child: SizedBox(
                  height: 80.h,
                  child: SquigglyContainer(
                    borderColor: const Color(0xFF7B5CAB),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.h,
                    ),
                    child: Column(
                      children: [
                        Text(
                          promiseListProvider.promisesCount.toString(),
                          style: AppTextStyles.bodyTextStyleBogart.copyWith(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "Total Promise\nCreated",
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyTextStyle.copyWith(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryBlackColor.withValues(
                              alpha: 0.7,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: StaggeredItem(
                index: 1,
                animationController: animationController,
                child: SizedBox(
                  height: 80.h,
                  child: SquigglyContainer(
                    borderColor: const Color(0xFF7B5CAB),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.h,
                    ),
                    child: Column(
                      children: [
                        Text(
                          promiseListProvider.promiseCategoriesCount.toString(),
                          style: AppTextStyles.bodyTextStyleBogart.copyWith(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "Categories\nTouched",
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyTextStyle.copyWith(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryBlackColor.withValues(
                              alpha: 0.7,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Default list animation
    return Column(
      children: content.examples.asMap().entries.map((entry) {
        int index = entry.key;
        String example = entry.value;

        return StaggeredItem(
          index: index,
          animationController: animationController,
          child: Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: SquigglyContainer(
              borderColor: ChallengeUtils.getBorderColorForDay(dayIndex),
              padding: EdgeInsets.symmetric(vertical: 14.5.h),
              child: Text(
                example,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyTextStyleBogart.copyWith(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
