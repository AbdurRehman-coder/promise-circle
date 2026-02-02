import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/core/utils/responsive_config.dart';
import 'package:sbp_app/core/utils/text_styles.dart';
import 'package:sbp_app/features/shared/widgets/w_primary_button.dart';

class CustomTimeBottomSheet extends StatefulWidget {
  final TimeOfDay? initialTime;

  const CustomTimeBottomSheet({super.key, this.initialTime});

  @override
  State<CustomTimeBottomSheet> createState() => _CustomTimeBottomSheetState();
}

class _CustomTimeBottomSheetState extends State<CustomTimeBottomSheet> {
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialTime ?? TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 20.w,
          right: 20.w,
          top: 24.h,
          bottom: MediaQuery.of(context).padding.bottom + 32.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Pick a time',
                style: AppTextStyles.headingTextStyleBogart.copyWith(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBlackColor,
                ),
              ),
            ),
            SizedBox(height: 24.h),
            SizedBox(
              height: 200.h,
              child: CupertinoTheme(
                data: CupertinoThemeData(
                  textTheme: CupertinoTextThemeData(
                    dateTimePickerTextStyle: AppTextStyles
                        .headingTextStyleBogart
                        .copyWith(
                          fontSize: 20.sp,
                          color: AppColors.primaryBlackColor,
                        ),
                  ),
                ),
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,

                  initialDateTime: DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day,
                    _selectedTime.hour,
                    _selectedTime.minute,
                  ),
                  onDateTimeChanged: (DateTime newDateTime) {
                    setState(() {
                      _selectedTime = TimeOfDay.fromDateTime(newDateTime);
                    });
                  },
                  use24hFormat: false,
                ),
              ),
            ),
            SizedBox(height: 24.h),
            PrimaryButton(
              onPressed: () {
                Navigator.pop(context, _selectedTime);
              },
              text: 'Save',
            ),
            SizedBox(height: 16.h),
            PrimaryButton(
              onPressed: () => Navigator.pop(context),
              text: 'Cancel',
              isOutlined: true,
              backgroundColor: AppColors.grey200Color,
              textColor: AppColors.primaryBlackColor,
            ),
          ],
        ),
      ),
    );
  }
}
