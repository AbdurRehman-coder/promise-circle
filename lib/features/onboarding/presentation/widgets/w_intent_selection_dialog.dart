import 'package:flutter/material.dart';
import 'package:sbp_app/core/utils/responsive_config.dart';
import 'package:sbp_app/features/shared/widgets/bottom_height_widget.dart';
import 'package:sbp_app/features/shared/widgets/w_primary_button.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/utils/text_styles.dart';

class IntentSelectionBottomSheet extends StatefulWidget {
  final String title;
  final String icon;
  final List<String> intents;
  final List<String> previouslySelected;

  const IntentSelectionBottomSheet({
    super.key,
    required this.title,
    this.icon = '🚀',
    required this.intents,
    this.previouslySelected = const [],
  });

  @override
  State<IntentSelectionBottomSheet> createState() =>
      _IntentSelectionBottomSheetState();
}

class _IntentSelectionBottomSheetState
    extends State<IntentSelectionBottomSheet> {
  late List<bool> _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.intents
        .map((intent) => widget.previouslySelected.contains(intent))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Rocket Icon
            Text(widget.icon, style: TextStyle(fontSize: 40.sp)),
            SizedBox(height: 16.h),

            // Title
            Text(
              widget.title,
              style: AppTextStyles.bodyTextStyleBogart.copyWith(
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Where follow-through matters most",
                style: AppTextStyles.bodyTextStyle.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 8.h),

            // Intent Options
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(widget.intents.length, (index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _selected[index] = !_selected[index]);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 16.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(24.r),
                            border: Border.all(
                              color: _selected[index]
                                  ? AppColors.secondaryBlueColor
                                  : AppColors.backgroundColor,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.intents[index],
                                style: AppTextStyles.bodyTextStyle.copyWith(
                                  fontSize: 14.sp,
                                  color: _selected[index]
                                      ? AppColors.secondaryBlueColor
                                      : AppColors.primaryBlackColor,
                                  fontWeight: _selected[index]
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                ),
                              ),

                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: _selected[index]
                                      ? AppColors.secondaryBlueColor
                                      : Colors.transparent,
                                  shape: BoxShape.circle,
                                  border: BoxBorder.all(
                                    color: _selected[index]
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
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            SizedBox(height: 24.h),

            // Confirm Button
            PrimaryButton(
              onPressed: () {
                final selectedItems = <String>[];
                for (int i = 0; i < widget.intents.length; i++) {
                  if (_selected[i]) selectedItems.add(widget.intents[i]);
                }
                Navigator.pop(context, selectedItems);
              },
              text: 'Confirm',
            ),
            SizedBox(height: 16.h),

            // Cancel Button
            PrimaryButton(
              onPressed: () => Navigator.pop(context),
              text: 'Cancel',
              isOutlined: true,
              backgroundColor: AppColors.grey200Color,
              textColor: AppColors.blackColor,
            ),
            BottomHeightWidget(),
          ],
        ),
      ),
    );
  }
}
