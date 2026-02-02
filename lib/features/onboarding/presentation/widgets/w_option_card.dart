import 'package:sbp_app/core/utils/responsive_config.dart';

import '../../../../core/theming/app_colors.dart';
import '../../../../core/utils/app_exports.dart';
import '../../../../core/utils/text_styles.dart';
import '../../model/onboarding_step.dart';

class OptionCard extends StatelessWidget {
  final OptionItem item;
  final bool isListItem;
  final bool isSelected;

  const OptionCard({
    super.key,
    required this.item,
    required this.isSelected,
    required this.isListItem,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: isSelected
              ? AppColors.secondaryBlueColor
              : AppColors.whiteColor,
          width: 2.w,
        ),
      ),
      child: isListItem
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (item.icon.isNotEmpty) ...[
                  Text(
                    item.icon,
                    style: TextStyle(fontSize: 20.sp, fontFamily: ''),
                  ),
                  SizedBox(width: 8.w),
                ],
                Text(
                  item.title,
                  style: AppTextStyles.bodyTextStyle.copyWith(
                    fontSize: 14.sp,
                    color: isSelected
                        ? AppColors.secondaryBlueColor
                        : AppColors.primaryBlackColor,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.secondaryBlueColor
                        : Colors.transparent,
                    shape: BoxShape.circle,
                    border: BoxBorder.all(
                      color: isSelected
                          ? AppColors.secondaryBlueColor
                          : AppColors.grey200Color,
                    ),
                  ),
                  child: Icon(Icons.check, size: 14.sp, color: Colors.white),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.icon, style: TextStyle(fontSize: 24.sp)),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.secondaryBlueColor
                            : Colors.transparent,
                        shape: BoxShape.circle,
                        border: BoxBorder.all(
                          color: isSelected
                              ? AppColors.secondaryBlueColor
                              : AppColors.grey200Color,
                        ),
                      ),
                      child: Icon(
                        Icons.check,
                        size: 14.sp,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Text(
                  item.title,
                  style: AppTextStyles.bodyTextStyle.copyWith(
                    fontSize: 16.sp,
                    color: isSelected
                        ? AppColors.secondaryBlueColor
                        : AppColors.primaryBlackColor,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ],
            ),
    );
  }
}
