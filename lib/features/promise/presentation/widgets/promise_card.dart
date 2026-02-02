import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/core/utils/responsive_config.dart';
import 'package:sbp_app/core/utils/text_styles.dart';
import 'package:sbp_app/core/constants/assets.dart';
import 'package:material_symbols_icons/symbols.dart';

class PromiseCard extends StatelessWidget {
  final String category;
  final String description;
  final Color color;
  final int keptCount;
  final bool isTrackingStarted;
  final Function()? onEdit;
  final Function()? onShare;
  final Function()? onTrack;

  const PromiseCard({
    super.key,
    required this.category,
    required this.description,
    required this.color,
    required this.keptCount,
    required this.isTrackingStarted,
    this.onEdit,
    this.onShare,
    this.onTrack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category,
                      style: AppTextStyles.headingTextStyleBogart.copyWith(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),

                    SizedBox(height: 8.h),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Column(
                children: [
                  SizedBox(
                    height: 36.h,
                    width: 36.w,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: SvgPicture.asset(
                            isTrackingStarted
                                ? Assets.svgPromiseKeptIcon
                                : Assets.svgPromiseEmptyIcon,
                          ),
                        ),
                        keptCount > 0
                            ? Positioned(
                                left: 0,
                                right: 0,
                                top: 14.h,
                                child: Center(
                                  child: SizedBox(
                                    height: 20.h,
                                    width: 20.w,
                                    child: FittedBox(
                                      child: Text(
                                        keptCount.toString(),
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 16.sp,

                                          fontWeight: FontWeight.w600,
                                          color: isTrackingStarted
                                              ? AppColors.whiteColor
                                              : AppColors.primaryBlackColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox.shrink(),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Streak",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 24.h),

          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  icon: Assets.svgEditIcon,
                  label: "Edit",
                  onTap: onEdit,
                  filled: false,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _ActionButton(
                  icon: Assets.svgShareIcon,
                  label: "Share",
                  onTap: onShare,
                  filled: true,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _ActionButton(
                  icon: "",
                  iconData: Symbols.history,
                  label: "Track",
                  onTap: onTrack,
                  filled: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String icon;
  final String label;
  final bool filled;
  final IconData? iconData;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.filled,
    this.iconData,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.w),
        decoration: BoxDecoration(
          color: filled ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconData != null
                ? Icon(iconData, color: Colors.white, weight: 500)
                : SvgPicture.asset(icon),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                color: filled ? Colors.white : Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
