import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/core/utils/text_styles.dart';
import 'package:sbp_app/features/shared/widgets/w_primary_button.dart';

import '../../../core/utils/responsive_config.dart';

class CustomCalendarBottomSheet extends StatefulWidget {
  final DateTime? initialDate;
  final DateTime? minDate;
  final DateTime? maxDate;
  final String title;

  const CustomCalendarBottomSheet({
    super.key,
    this.initialDate,
    this.minDate,
    this.maxDate,
    this.title = "Select date",
  });

  @override
  State<CustomCalendarBottomSheet> createState() =>
      _CustomCalendarBottomSheetState();
}

class _CustomCalendarBottomSheetState extends State<CustomCalendarBottomSheet> {
  late DateTime _displayedMonth;
  DateTime? _selectedDate;
  ViewMode _viewMode = ViewMode.calendar;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _displayedMonth = widget.initialDate ?? DateTime.now();
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
          bottom: MediaQuery.of(context).padding.bottom + 16.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.title,
                style: AppTextStyles.headingTextStyleBogart.copyWith(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 24.h),

            if (_viewMode == ViewMode.calendar)
              _buildCalendarView()
            else if (_viewMode == ViewMode.yearPicker)
              _buildYearPickerView()
            else
              _buildMonthPickerView(),

            SizedBox(height: 24.h),

            PrimaryButton(
              onPressed: () {
                if (_selectedDate != null) {
                  Navigator.pop(context, _selectedDate);
                }
              },
              text: 'Save',
              enabled: _selectedDate != null,
            ),
            SizedBox(height: 16.h),
            PrimaryButton(
              onPressed: () => Navigator.pop(context),
              text: 'Cancel',
              isOutlined: true,
              backgroundColor: AppColors.grey200Color,
              textColor: AppColors.blackColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarView() {
    return Column(
      children: [
        _buildNavigationHeader(),
        SizedBox(height: 20.h),
        _buildDayHeaders(),
        SizedBox(height: 8.h),
        _buildCalendarGrid(),
      ],
    );
  }

  Widget _buildNavigationHeader() {
    final monthYearText = DateFormat('MMMM yyyy').format(_displayedMonth);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _viewMode = ViewMode.yearPicker;
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  monthYearText,
                  style: AppTextStyles.bodyTextStyle.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlackColor,
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(
                  Icons.chevron_right,
                  size: 20.r,
                  color: AppColors.primaryBlackColor,
                ),
              ],
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: _canGoToPreviousMonth() ? _goToPreviousMonth : null,
              icon: Icon(Icons.arrow_back_ios, size: 20.r),
              color: AppColors.secondaryBlueColor,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            SizedBox(width: 16.w),
            IconButton(
              onPressed: _canGoToNextMonth() ? _goToNextMonth : null,
              icon: Icon(Icons.arrow_forward_ios, size: 20.r),
              color: AppColors.secondaryBlueColor,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDayHeaders() {
    const days = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: days.map((day) {
        return Expanded(
          child: Center(
            child: Text(
              day,
              style: AppTextStyles.bodyTextStyle.copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.greyColor,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendarGrid() {
    final daysInMonth = _getDaysInMonth();
    final firstDayOfMonth = DateTime(
      _displayedMonth.year,
      _displayedMonth.month,
      1,
    );
    final startingWeekday = firstDayOfMonth.weekday % 7;

    return SizedBox(
      height: 300.h,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          childAspectRatio: 1,
          mainAxisSpacing: 4.h,
          crossAxisSpacing: 4.w,
        ),
        itemCount: 42,
        itemBuilder: (context, index) {
          final dayIndex = index - startingWeekday;

          if (dayIndex < 0 || dayIndex >= daysInMonth) {
            return const SizedBox.shrink();
          }

          final day = dayIndex + 1;
          final date = DateTime(
            _displayedMonth.year,
            _displayedMonth.month,
            day,
          );
          final isSelected =
              _selectedDate != null &&
              date.year == _selectedDate!.year &&
              date.month == _selectedDate!.month &&
              date.day == _selectedDate!.day;

          final isEnabled = _isDateEnabled(date);

          return GestureDetector(
            onTap: isEnabled ? () => _selectDate(date) : null,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? AppColors.secondaryBlueColor.withOpacity(0.12)
                    : Colors.transparent,
              ),
              child: Center(
                child: Text(
                  '$day',
                  style: AppTextStyles.bodyTextStyle.copyWith(
                    fontSize: 16.sp,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? AppColors.secondaryBlueColor
                        : isEnabled
                        ? AppColors.primaryBlackColor
                        : AppColors.grey200Color,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildYearPickerView() {
    final currentYear = DateTime.now().year;
    final minYear = widget.minDate?.year ?? (currentYear - 100);
    final maxYear = widget.maxDate?.year ?? (currentYear + 100);

    final years = List.generate(
      maxYear - minYear + 1,
      (index) => minYear + index,
    ).reversed.toList();

    return SizedBox(
      height: 300.h,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 2.2,
          crossAxisSpacing: 8.w,
          mainAxisSpacing: 8.h,
        ),
        itemCount: years.length,
        itemBuilder: (context, index) {
          final year = years[index];
          final isSelected = year == _displayedMonth.year;

          return GestureDetector(
            onTap: () {
              setState(() {
                _displayedMonth = DateTime(year, _displayedMonth.month);
                _viewMode = ViewMode.monthPicker;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.secondaryBlueColor.withOpacity(0.12)
                    : AppColors.whiteColor,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isSelected
                      ? AppColors.secondaryBlueColor
                      : AppColors.grey200Color,
                  width: 1.w,
                ),
              ),
              child: Center(
                child: Text(
                  '$year',
                  style: AppTextStyles.bodyTextStyle.copyWith(
                    fontSize: 14.sp,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? AppColors.secondaryBlueColor
                        : AppColors.primaryBlackColor,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMonthPickerView() {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return SizedBox(
      height: 300.h,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2.2,
          crossAxisSpacing: 8.w,
          mainAxisSpacing: 8.h,
        ),
        itemCount: 12,
        itemBuilder: (context, index) {
          final month = index + 1;
          final isSelected = month == _displayedMonth.month;

          return GestureDetector(
            onTap: () {
              setState(() {
                _displayedMonth = DateTime(_displayedMonth.year, month);
                _viewMode = ViewMode.calendar;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.secondaryBlueColor.withOpacity(0.12)
                    : AppColors.whiteColor,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isSelected
                      ? AppColors.secondaryBlueColor
                      : AppColors.grey200Color,
                  width: 1.w,
                ),
              ),
              child: Center(
                child: Text(
                  months[index],
                  style: AppTextStyles.bodyTextStyle.copyWith(
                    fontSize: 13.sp,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? AppColors.secondaryBlueColor
                        : AppColors.primaryBlackColor,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  int _getDaysInMonth() {
    return DateTime(_displayedMonth.year, _displayedMonth.month + 1, 0).day;
  }

  bool _isDateEnabled(DateTime date) {
    if (widget.minDate != null && date.isBefore(widget.minDate!)) {
      return false;
    }
    if (widget.maxDate != null && date.isAfter(widget.maxDate!)) {
      return false;
    }
    return true;
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  bool _canGoToPreviousMonth() {
    if (widget.minDate == null) return true;
    final previousMonth = DateTime(
      _displayedMonth.year,
      _displayedMonth.month - 1,
    );
    return previousMonth.isAfter(
          widget.minDate!.subtract(const Duration(days: 1)),
        ) ||
        (previousMonth.year == widget.minDate!.year &&
            previousMonth.month == widget.minDate!.month);
  }

  bool _canGoToNextMonth() {
    if (widget.maxDate == null) return true;
    final nextMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1);
    return nextMonth.isBefore(widget.maxDate!.add(const Duration(days: 1))) ||
        (nextMonth.year == widget.maxDate!.year &&
            nextMonth.month == widget.maxDate!.month);
  }

  void _goToPreviousMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month - 1,
      );
    });
  }

  void _goToNextMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + 1,
      );
    });
  }
}

enum ViewMode { calendar, yearPicker, monthPicker }
