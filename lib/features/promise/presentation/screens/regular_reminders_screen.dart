import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:sbp_app/core/constants/assets.dart';
import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/core/utils/responsive_config.dart';
import 'package:sbp_app/core/utils/text_styles.dart';
import 'package:sbp_app/features/promise/models/promise_result.dart';
import 'package:sbp_app/features/promise/provider/promise_list_provider.dart';
import 'package:sbp_app/features/promise/services/promise_services.dart';
import 'package:sbp_app/features/shared/providers/ai_examples_provider.dart';
import 'package:sbp_app/features/shared/widgets/w_primary_button.dart';
import '../../../../core/services/facebook_events_service.dart';
import '../../../../core/utils/app_extensions.dart';
import '../../../../main.dart';
import '../../../shared/widgets/back_button.dart';
import '../../../shared/widgets/flushbar.dart';
import '../../../shared/widgets/screen_template.dart';
import '../../../shared/widgets/squiggly_container.dart';
import '../../../shared/widgets/w_custom_calendar_bottom_sheet.dart';
import '../../../shared/widgets/w_custom_time_bottom_sheet.dart'
    show CustomTimeBottomSheet;
import '../widgets/keep_welcome_dialog.dart';
import 'promise_reminders_steps_screen.dart';

class RegularRemindersScreen extends StatefulWidget {
  static const String routeName = '/regular-reminders';
  final dynamic promiseResult;
  const RegularRemindersScreen({super.key, required this.promiseResult});

  @override
  State<RegularRemindersScreen> createState() => _RegularRemindersScreenState();
}

class _RegularRemindersScreenState extends State<RegularRemindersScreen> {
  String _selectedFrequency = 'Weekly';
  DateTime? _startDate;
  DateTime? _oneTimeDate;
  TimeOfDay? _selectedTime;
  bool _isLoading = false;

  final List<String> _selectedWeekDays = [];
  final List<int> _selectedMonthDays = [];
  bool isUpdating = false;

  @override
  void initState() {
    super.initState();
    _initFromExistingData();
  }

  void _initFromExistingData() {
    if (widget.promiseResult.reminders.isEmpty) {
      return;
    }
    isUpdating = true;
    final regularReminders = widget.promiseResult.reminders
        .where((r) => r.reminderType != 'STEP')
        .toList();

    if (regularReminders.isEmpty) return;

    final reminder = regularReminders.first;

    if (reminder.startDate != null) {
      _startDate = DateTime.tryParse(reminder.startDate!);
    } else if (reminder.startDate != null) {
      _startDate = DateTime.tryParse(reminder.startDate!);
    }

    if (reminder.keepTime != null) {
      _selectedTime = _floatToTime(reminder.keepTime!);
    }

    switch (reminder.reminderType) {
      case 'ONE_TIME':
        _selectedFrequency = 'One Time';
        if (reminder.keepDate != null) {
          _oneTimeDate = DateTime.tryParse(reminder.keepDate!);
        } else {
          _oneTimeDate = _startDate;
        }
        break;
      case 'WEEKLY':
        _selectedFrequency = 'Weekly';
        if (reminder.keepDays != null) {
          final d = (reminder.keepDays as List<int>)
              .map((dayInt) => _intToDay(dayInt))
              .toList();
          _selectedWeekDays.clear();
          _selectedWeekDays.addAll(d);
        }
        break;
      case 'MONTHLY':
        _selectedFrequency = 'Monthly';
        if (reminder.keepDays != null) {
          _selectedMonthDays.clear();
          _selectedMonthDays.addAll(reminder.keepDays!);
        }
        break;
    }
  }

  String _intToDay(int day) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    if (day >= 0 && day < days.length) return days[day];
    return 'Mon';
  }

  TimeOfDay _floatToTime(double value) {
    int hour = value.floor();
    int minute = ((value - hour) * 60).round();
    return TimeOfDay(hour: hour, minute: minute);
  }

  double _timeToFloat(TimeOfDay time) {
    return time.hour + (time.minute / 60.0);
  }

  int _mapDayToInt(String day) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days.indexOf(day);
  }

  Map<String, dynamic>? _buildBaseReminderPayload() {
    if (_startDate == null) {
      FlashMessage.showError(context, "Please select a start date");
      return null;
    }

    final floatTime = _timeToFloat(
      _selectedTime ?? const TimeOfDay(hour: 21, minute: 0),
    );
    final isoStartDate = _startDate!.toIso8601String();

    if (_selectedFrequency == 'One Time') {
      if (_oneTimeDate == null) {
        FlashMessage.showError(context, "Please select a keep date");
        return null;
      }
      return {
        "reminderType": "ONE_TIME",
        "startDate": isoStartDate,
        "keepDate": _oneTimeDate!.toIso8601String(),
        "keepTime": double.parse(floatTime.toStringAsFixed(2)),
      };
    } else if (_selectedFrequency == 'Weekly') {
      if (_selectedWeekDays.isEmpty) {
        FlashMessage.showError(context, "Please select at least one day");
        return null;
      }
      return {
        "reminderType": "WEEKLY",
        "startDate": isoStartDate,
        "keepDays": _selectedWeekDays.map((e) => _mapDayToInt(e)).toList(),
        "keepTime": double.parse(floatTime.toStringAsFixed(2)),
      };
    } else if (_selectedFrequency == 'Monthly') {
      if (_selectedMonthDays.isEmpty) {
        FlashMessage.showError(context, "Please select at least one date");
        return null;
      }
      return {
        "reminderType": "MONTHLY",
        "startDate": isoStartDate,
        "keepDays": _selectedMonthDays,
        "keepTime": double.parse(floatTime.toStringAsFixed(2)),
      };
    }
    return null;
  }

  String _getFrequencySubtitle() {
    if (_selectedFrequency == 'One Time' && _oneTimeDate != null) {
      return "${_oneTimeDate!.month}/${_oneTimeDate!.day}/${_oneTimeDate!.year}";
    }
    if (_selectedFrequency == 'Weekly') return _selectedWeekDays.join(", ");
    if (_selectedFrequency == 'Monthly') {
      return _selectedMonthDays.map((e) => "${e}th").join(", ");
    }
    return "";
  }

  Future<void> showKeepIntroDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const KeepWelcomeDialog(),
    );
  }

  Future<void> _onAddPromiseReminder(WidgetRef ref) async {
    final reminder = _buildBaseReminderPayload();
    if (!isUpdating) {
      final fbEvents = FacebookEventsService();
      fbEvents.logEvent(
        name: 'promise_tracking_start',
        parameters: {'timestamp': DateTime.now().toIso8601String()},
        ref: ref,
        screenName: "Promise Tracking(Reminders)",
      );
    }
    if (reminder == null) return;
    setState(() => _isLoading = true);
    try {
      await GetIt.I<PromiseServices>().updatePromiseReminders(
        promiseId: widget.promiseResult.id,
        payload: {
          "reminders": [reminder],
        },
      );
      if (mounted) {
        final updatedReminder = ReminderResult.fromJson(reminder);

        widget.promiseResult.reminders.removeWhere(
          (r) => r.reminderType != 'STEP',
        );
        widget.promiseResult.reminders.add(updatedReminder);
        ref.read(promisesProvider.notifier).fetchPromises();
        Navigator.pop(navigatorKey.currentContext!);

        showKeepIntroDialog(context);
        // FlashMessage.showSuccess(
        //   context,
        //   "Your promise tracking has been ${isUpdating ? "updated" : "started"}!",
        // );
      }
    } catch (e) {
      if (mounted) FlashMessage.showError(context, "Error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _onBreakIntoSteps(WidgetRef ref) async {
    final reminder = _buildBaseReminderPayload();
    if (reminder == null) return;
    await ref
        .read(aiExamplesControllerProvider.notifier)
        .generatReminderActionSteps(widget.promiseResult.description);

    final stepsRemnders = widget.promiseResult.reminders
        .where((r) => r.reminderType == "STEP")
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PromiseSetupScreen(
          promiseId: widget.promiseResult.id,
          baseReminderData: reminder,
          promise: widget.promiseResult,
          existingSteps: stepsRemnders.isEmpty
              ? []
              : stepsRemnders[0].stepReminders,
          summaryContext: PromiseSummaryContext(
            title: "Your Promise\nCheck-Ins",
            startDate:
                "${_startDate!.month}/${_startDate!.day}/${_startDate!.year}",
            frequencyTitle: _selectedFrequency,
            frequencySubtitle: _getFrequencySubtitle(),
            completionTime: _selectedTime != null
                ? _formatTime(_selectedTime!)
                : "9:00 PM",
          ),
        ),
      ),
    );
  }

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('hh:mm a').format(dt);
  }

  Widget _buildSectionDivider(BuildContext context, String title) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Colors.black12, thickness: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.65,
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                style: AppTextStyles.headingTextStyleBogart.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlackColor,
                ),
              ),
            ),
          ),
        ),
        const Expanded(child: Divider(color: Colors.black12, thickness: 1)),
      ],
    );
  }

  Widget _buildStarDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(color: Colors.black12, thickness: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SvgPicture.asset(
            Assets.svgTwinkleStarsBlackIcon,
            height: 20.h,
            width: 20.w,
          ),
        ),
        const Expanded(child: Divider(color: Colors.black12, thickness: 1)),
      ],
    );
  }

  String _cleanDescription(String desc) {
    String cleaned = desc;
    if (cleaned.toLowerCase().startsWith('i promise')) {
      cleaned = cleaned.substring(9).trim();
    }
    return cleaned;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      widget: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: BackButtonWidget(),
              ),
            ),
            SquigglyContainer(
              borderColor: const Color(0xFF6CC163),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 25.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildSectionDivider(
                      context,
                      (widget.promiseResult.categories ?? [])
                          .map((e) => (e as String).capitalizeA.trim())
                          .join(" • "),
                    ),
                    SizedBox(height: 26.h),
                    Text(
                      'I Promise',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.headingTextStyleBogart.copyWith(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryBlackColor,
                      ),
                    ),
                    Text(
                      _cleanDescription(widget.promiseResult.description ?? ""),
                      textAlign: TextAlign.center,
                      style: AppTextStyles.headingTextStyleBogart.copyWith(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryBlackColor,
                      ),
                    ),
                    SizedBox(height: 32.h),
                    _buildStarDivider(),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              "And You’re Off!",
              style: AppTextStyles.headingTextStyleBogart.copyWith(
                fontSize: 32.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "You’ve set your promise.",
              style: AppTextStyles.bodyTextStyle.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryBlackColor.withValues(alpha: 0.8),
                height: 1.5,
              ),
            ),
            Text(
              "Choose when you want to begin and how often you'd like us to check in and support you.",
              style: AppTextStyles.bodyTextStyle.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryBlackColor.withValues(alpha: 0.8),

                height: 1.5,
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 24.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF9F5EF),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.black.withValues(alpha: 0.15),
                  width: 1.3,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      children: [
                        Center(
                          child: SizedBox(
                            height: 210.h,
                            child: Image.asset(
                              Assets.reminderIllus,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),
                        _buildQuestionHeader(
                          'When do you want to start\nkeeping this promise?',
                        ),
                        SizedBox(height: 16.h),
                        _buildInputField(
                          text: _startDate != null
                              ? "${_startDate!.month}/${_startDate!.day}/${_startDate!.year}"
                              : "MM/DD/YYYY",
                          icon: Assets.svgCalendarIcon,
                          onTap: () => _pickDate(isStart: true),
                        ),
                        SizedBox(height: 32.h),
                        _buildQuestionHeader(
                          'How often would you like\ncheck-ins?',
                        ),
                        SizedBox(height: 16.h),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Row(
                            children: [
                              Expanded(child: _buildToggleContent("One Time")),
                              Expanded(
                                child: _buildToggleContent(
                                  "Weekly",
                                  isRecommended: true,
                                ),
                              ),
                              Expanded(child: _buildToggleContent("Monthly")),
                            ],
                          ),
                        ),
                        SizedBox(height: 24.h),
                        if (_selectedFrequency == 'One Time')
                          _buildOneTimeView(),
                        if (_selectedFrequency == 'Weekly') _buildWeeklyView(),
                        if (_selectedFrequency == 'Monthly')
                          _buildMonthlyView(),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                  Divider(
                    color: AppColors.primaryBlackColor.withValues(alpha: 0.2),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      children: [
                        SizedBox(height: 20.h),
                        _buildQuestionHeader(
                          'By what time should we check in each day?',
                        ),
                        SizedBox(height: 16.h),
                        _buildInputField(
                          text: _selectedTime != null
                              ? _formatTime(_selectedTime!)
                              : "09:00 PM",
                          isDropdown: true,
                          onTap: _pickTime,
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          "*Pick a time that feels realistic—this is when we’ll check in, not rush you.",
                          style: AppTextStyles.bodyTextStyle.copyWith(
                            fontSize: 14.sp,
                            height: 1.4,
                            color: AppColors.primaryBlackColor.withValues(
                              alpha: 0.8,
                            ),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.h),
            Consumer(
              builder: (context, ref, child) => PrimaryButton(
                onPressed: () => _onAddPromiseReminder(ref),
                text: '${isUpdating ? "Update" : "Set"} Check-Ins',
                isLoading: _isLoading,
                height: 56.h,
              ),
            ),
            SizedBox(height: 20.h),
            Center(
              child: Text(
                "Want more support?",
                style: AppTextStyles.bodyTextStyle.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Consumer(
              builder: (context, ref, child) => PrimaryButton(
                onPressed: () => _onBreakIntoSteps(ref),
                text: 'Break this Promise into steps',
                textColor: AppColors.primaryBlackColor,
                // backgroundColor: Colors.white,
                isLoading: ref.watch(aiExamplesControllerProvider).isLoading,
                borderColor: Colors.black12,
                isOutlined: true,
                height: 56.h,
              ),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleContent(String label, {bool isRecommended = false}) {
    final isSelected = _selectedFrequency == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFrequency = label),
      child: Container(
        height: 56.h,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlackColor : Colors.transparent,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: AppTextStyles.bodyTextStyle.copyWith(
                fontSize: 14.sp,
                color: isSelected ? Colors.white : AppColors.primaryBlackColor,
              ),
            ),
            if (isRecommended)
              Text(
                "Recommended",
                style: AppTextStyles.bodyTextStyle.copyWith(
                  fontSize: 8.sp,
                  color: isSelected ? Colors.white70 : Colors.grey,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOneTimeView() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Pick one date to check on this promise.",
        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
      ),
      SizedBox(height: 16.h),
      _buildInputField(
        text: _oneTimeDate != null
            ? "${_oneTimeDate!.month}/${_oneTimeDate!.day}/${_oneTimeDate!.year}"
            : "MM/DD/YYYY",
        icon: Assets.svgCalendarIcon,
        onTap: () => _pickDate(isStart: false),
      ),
    ],
  );

  Widget _buildWeeklyView() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Which days should we check in?",
        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
      ),
      SizedBox(height: 16.h),
      Row(
        children: [
          Expanded(child: _buildWeekDayPill("Mon")),
          SizedBox(width: 8.w),
          Expanded(child: _buildWeekDayPill("Tue")),
          SizedBox(width: 8.w),
          Expanded(child: _buildWeekDayPill("Wed")),
        ],
      ),
      SizedBox(height: 12.h),
      Row(
        children: [
          Expanded(child: _buildWeekDayPill("Thu")),
          SizedBox(width: 8.w),
          Expanded(child: _buildWeekDayPill("Fri")),
          SizedBox(width: 8.w),
          Expanded(child: _buildWeekDayPill("Sat")),
        ],
      ),
      SizedBox(height: 12.h),
      _buildWeekDayPill("Sun"),
      SizedBox(height: 12.h),
      Text(
        "You can choose multiple days for a week.",
        style: AppTextStyles.bodyTextStyle.copyWith(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.primaryBlackColor.withValues(alpha: 0.8),

          height: 1.5,
        ),
      ),
    ],
  );

  Widget _buildMonthlyView() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Which days should we check in?",
        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
      ),
      SizedBox(height: 20.h),
      Center(
        child: Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: List.generate(30, (i) {
            final d = i + 1;
            final isS = _selectedMonthDays.contains(d);
            return GestureDetector(
              onTap: () => setState(
                () => isS
                    ? _selectedMonthDays.remove(d)
                    : _selectedMonthDays.add(d),
              ),
              child: Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                    color: isS ? AppColors.blueColor : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    "$d",
                    style: TextStyle(
                      color: isS
                          ? AppColors.blueColor
                          : AppColors.primaryBlackColor,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
      SizedBox(height: 12.h),
      Text(
        "You can choose multiple days for a month.",
        style: AppTextStyles.bodyTextStyle.copyWith(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.primaryBlackColor.withValues(alpha: 0.8),

          height: 1.5,
        ),
      ),
    ],
  );

  Widget _buildQuestionHeader(String text) => Text(
    text,
    style: AppTextStyles.headingTextStyleBogart.copyWith(
      fontSize: 24.sp,
      fontWeight: FontWeight.w500,
    ),
  );

  Widget _buildInputField({
    required String text,
    String? icon,
    bool isDropdown = false,
    required VoidCallback onTap,
  }) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.black.withOpacity(0.15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14.sp,
                color: text.contains("MM/DD")
                    ? Colors.grey[400]
                    : AppColors.primaryBlackColor,
              ),
            ),
          ),
          if (icon != null) SvgPicture.asset(icon, height: 20.h),
          if (isDropdown)
            Icon(Icons.keyboard_arrow_down, color: Colors.black54),
        ],
      ),
    ),
  );

  Widget _buildWeekDayPill(String day) {
    final isS = _selectedWeekDays.contains(day);
    return GestureDetector(
      onTap: () => setState(
        () => isS ? _selectedWeekDays.remove(day) : _selectedWeekDays.add(day),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isS ? AppColors.blueColor : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            day,
            style: TextStyle(
              color: isS ? AppColors.blueColor : AppColors.primaryBlackColor,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate({required bool isStart}) async {
    final DateTime? p = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => CustomCalendarBottomSheet(
        minDate: DateTime.now(),

        initialDate: _startDate ?? DateTime.now(),
      ),
    );
    if (p != null) setState(() => isStart ? _startDate = p : _oneTimeDate = p);
  }

  Future<void> _pickTime() async {
    final TimeOfDay? p = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,

      builder: (_) => CustomTimeBottomSheet(initialTime: _selectedTime),
    );
    if (p != null) setState(() => _selectedTime = p);
  }
}
