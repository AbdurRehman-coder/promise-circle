import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:sbp_app/core/services/facebook_events_service.dart'
    show FacebookEventsService;
import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/core/utils/responsive_config.dart';
import 'package:sbp_app/core/utils/text_styles.dart';
import 'package:sbp_app/features/promise/models/promise_result.dart';
import 'package:sbp_app/features/promise/services/promise_services.dart';
import 'package:sbp_app/features/shared/providers/ai_examples_provider.dart';
import 'package:sbp_app/features/shared/widgets/back_button.dart';
import 'package:sbp_app/features/shared/widgets/squiggly_frame_widget.dart';
import 'package:sbp_app/features/shared/widgets/w_custom_form_field.dart'
    show CustomTextField;
import '../../../shared/widgets/flushbar.dart';
import '../../../shared/widgets/screen_template.dart';
import '../../../shared/widgets/w_primary_button.dart' show PrimaryButton;
import '../../provider/promise_list_provider.dart';
import '../widgets/keep_welcome_dialog.dart';

class PromiseSummaryContext {
  final String title,
      startDate,
      frequencyTitle,
      frequencySubtitle,
      completionTime;
  PromiseSummaryContext({
    required this.title,
    required this.startDate,
    required this.frequencyTitle,
    required this.frequencySubtitle,
    required this.completionTime,
  });
}

class PromiseSetupScreen extends StatefulWidget {
  final String promiseId;
  final Map<String, dynamic> baseReminderData;
  final PromiseSummaryContext summaryContext;
  final List<ReminderStepResult>? existingSteps;
  final dynamic promise;

  const PromiseSetupScreen({
    super.key,
    required this.promiseId,
    required this.baseReminderData,
    required this.summaryContext,
    required this.promise,
    this.existingSteps,
  });

  @override
  State<PromiseSetupScreen> createState() => _PromiseSetupScreenState();
}

class _PromiseSetupScreenState extends State<PromiseSetupScreen> {
  final _s1 = TextEditingController(),
      _s2 = TextEditingController(),
      _s3 = TextEditingController();
  String? _r1 = '1 Hour Before', _r2 = '1 Day Before', _r3 = '1 Week Before';
  bool _isLoading = false;
  // bool _isupdating = false;

  @override
  void initState() {
    super.initState();
    _populateExistingData();
  }

  void _populateExistingData() {
    if (widget.existingSteps != null && widget.existingSteps!.isNotEmpty) {
      // _isupdating = true;
      final steps = widget.existingSteps!;
      if (steps.isNotEmpty) {
        _s1.text = steps[0].text;
        _r1 = steps[0].offset;
      }
      if (steps.length > 1) {
        _s2.text = steps[1].text;
        _r2 = steps[1].offset;
      }
      if (steps.length > 2) {
        _s3.text = steps[2].text;
        _r3 = steps[2].offset;
      }
    }
  }

  Future<void> showKeepIntroDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const KeepWelcomeDialog(),
    );
  }

  Future<void> _onLockInSupport(WidgetRef ref) async {
    if (_s1.text.trim().isEmpty) {
      FlashMessage.showError(context, "Please fill in Step 1 to proceed.");
      return;
    }

    setState(() => _isLoading = true);
    final List<Map<String, dynamic>> stepReminders = [];

    void addStep(TextEditingController controller, String? offset) {
      if (controller.text.trim().isNotEmpty && offset != null) {
        stepReminders.add({"text": controller.text.trim(), "offset": offset});
      }
    }

    addStep(_s1, _r1);
    addStep(_s2, _r2);
    addStep(_s3, _r3);

    final payload = {
      "reminders": [
        widget.baseReminderData,
        if (stepReminders.isNotEmpty)
          {"reminderType": "STEP", "stepReminders": stepReminders},
      ],
    };

    try {
      if (widget.promise.reminders == null ||
          widget.promise.reminders.isEmpty) {
        final fbEvents = FacebookEventsService();
        fbEvents.logEvent(
          name: 'promise_tracking_start',
          parameters: {'timestamp': DateTime.now().toIso8601String()},
          ref: ref,
          screenName: "Promise Tracking(Reminders)",
        );
      }
      await GetIt.I<PromiseServices>().updatePromiseReminders(
        promiseId: widget.promiseId,
        payload: payload,
      );
      if (mounted) {
        widget.promise.reminders.clear();
        widget.promise.reminders.addAll(
          (payload['reminders'] as List<dynamic>).map(
            (r) => ReminderResult.fromJson(r),
          ),
        );
        ref.read(promisesProvider.notifier).fetchPromises();
        // FlashMessage.showSuccess(
        //   context,
        //   "Your promise tracking with step reminders has been ${_isupdating ? "updated" : "added"}!",
        // );
        Navigator.of(context)
          ..pop()
          ..pop();
        showKeepIntroDialog(context);
      }
    } catch (e) {
      if (mounted) FlashMessage.showError(context, "Error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _s1.dispose();
    _s2.dispose();
    _s3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double badgeOff = 24.0.h;

    return ScreenTemplate(
      widget: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 20.h),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: BackButtonWidget(),
            ),
          ),
          SummaryCard(data: widget.summaryContext),
          SizedBox(height: 16.h),
          Text(
            "Let’s set this up for success",
            style: AppTextStyles.headingTextStyleBogart.copyWith(
              fontSize: 24.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "What would make this promise easier to keep?",
            style: AppTextStyles.bodyTextStyle.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10.h),
          const ExampleCard(),
          _DashedConnector(label: "Start simple", badgeLeftOffset: badgeOff),
          StepInputCard(
            stepNumber: 1,
            title: "One small action",
            controller: _s1,
            dropdownValue: _r1,
            onDropdownChanged: (v) => setState(() => _r1 = v),
            badgeLeftOffset: badgeOff,
          ),
          _DashedConnector(
            label: "Only if it helps",
            badgeLeftOffset: badgeOff,
          ),
          StepInputCard(
            stepNumber: 2,
            title: "What would help next?",
            controller: _s2,
            dropdownValue: _r2,
            onDropdownChanged: (v) => setState(() => _r2 = v),
            badgeLeftOffset: badgeOff,
          ),
          _DashedConnector(label: "Optional", badgeLeftOffset: badgeOff),
          StepInputCard(
            stepNumber: 3,
            title: "Anything else?",
            controller: _s3,
            dropdownValue: _r3,
            onDropdownChanged: (v) => setState(() => _r3 = v),
            badgeLeftOffset: badgeOff,
          ),
          _FinalConnector(badgeLeftOffset: badgeOff),
          Consumer(
            builder: (context, ref, child) => PrimaryButton(
              onPressed: _isLoading ? () {} : () => _onLockInSupport(ref),
              text: "Lock In Support",
              isLoading: _isLoading,
              height: 56.h,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            "You don't need to fill every step.\nFewer steps often work better.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.primaryBlackColor.withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }
}

class StepInputCard extends StatelessWidget {
  final int stepNumber;
  final String title;
  final TextEditingController controller;
  final String? dropdownValue;
  final ValueChanged<String?> onDropdownChanged;
  final double badgeLeftOffset;
  const StepInputCard({
    super.key,
    required this.stepNumber,
    required this.title,
    required this.controller,
    required this.dropdownValue,
    required this.onDropdownChanged,
    required this.badgeLeftOffset,
  });

  @override
  Widget build(BuildContext context) {
    final style = AppTextStyles.bodyTextStyle.copyWith(
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      height: 25 / 14,
    );
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: 20.h),
          padding: EdgeInsets.fromLTRB(20.w, 32.h, 20.w, 20.h),
          decoration: BoxDecoration(
            color: const Color(0xFFF9F5EF),
            borderRadius: BorderRadius.circular(20.w),
            border: Border.all(color: Colors.black12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.headingTextStyleBogart.copyWith(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 12.h),
              CustomTextField(
                controller: controller,
                hintText: "Type here...",
                filledColor: Colors.white,
                maxLines: 1,

                // style: style,
              ),
              SizedBox(height: 16.h),
              Text(
                "Start Gentle Nudge",

                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black45,

                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: const Color(0xffE3E3E4)),
                ),
                alignment: Alignment.center,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    isExpanded: true,
                    isDense: true,
                    padding: EdgeInsets.zero,
                    dropdownColor: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    style: style,
                    items:
                        [
                              '1 Hour Before',
                              '1 Day Before',
                              '2 Days Before',
                              '1 Week Before',
                            ]
                            .map(
                              (v) => DropdownMenuItem(
                                value: v,
                                child: Text(
                                  v,
                                  style: TextStyle(
                                    color: AppColors.primaryBlackColor,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                    onChanged: onDropdownChanged,
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: -5.h,
          left: badgeLeftOffset.w,
          child: Container(
            width: 52.w,
            height: 52.w,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE0DCD7), width: 4.w),
            ),
            child: Center(
              child: Text("$stepNumber", style: TextStyle(fontSize: 18.sp)),
            ),
          ),
        ),
      ],
    );
  }
}

class _DashedConnector extends StatelessWidget {
  final String label;
  final double badgeLeftOffset;
  const _DashedConnector({required this.label, required this.badgeLeftOffset});
  @override
  Widget build(BuildContext context) {
    final x = badgeLeftOffset.w + 25.w - 0.75.w;
    return SizedBox(
      height: 80.h,
      child: Stack(
        children: [
          Positioned(
            left: x,
            top: 0,
            bottom: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                4,
                (i) => Container(
                  width: 3.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlackColor.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(3),
                  ),

                  margin: EdgeInsets.symmetric(vertical: 2.h),
                ),
              ),
            ),
          ),
          Positioned(
            left: x + 26.w,
            top: 0,
            bottom: 0,
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black45,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FinalConnector extends StatelessWidget {
  final double badgeLeftOffset;
  const _FinalConnector({required this.badgeLeftOffset});
  @override
  Widget build(BuildContext context) {
    final x = badgeLeftOffset.w + 25.w - 0.75.w;
    return SizedBox(
      height: 80.h,
      child: Stack(
        children: [
          Positioned(
            left: x,
            top: 0,
            bottom: 0,
            child: Center(
              child: Container(
                height: 50.h,
                width: 3.w,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlackColor.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
          Positioned(
            left: x + 26.w,
            top: 0,
            bottom: 0,
            child: Center(
              child: Text(
                "Keep it!",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBlackColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final PromiseSummaryContext data;

  const SummaryCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: 24.h),
          padding: EdgeInsets.fromLTRB(24.w, 40.h, 24.w, 24.h),
          decoration: BoxDecoration(
            color: const Color(0xFFF9F5EF),
            borderRadius: BorderRadius.circular(24.w),
            border: Border.all(
              color: AppColors.primaryBlackColor.withValues(alpha: 0.15),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.title,
                style: AppTextStyles.headingTextStyleBogart.copyWith(
                  fontSize: 32.sp,
                  height: 1.1,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBlackColor,
                ),
              ),
              SizedBox(height: 24.h),
              _label("Start Keeping on"),
              _value(data.startDate),
              SizedBox(height: 20.h),
              _label("How Often"),
              _value(data.frequencyTitle),
              if (data.frequencySubtitle.isNotEmpty) ...[
                SizedBox(height: 4.h),
                Text(
                  data.frequencySubtitle,
                  style: AppTextStyles.headingTextStyleBogart.copyWith(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.primaryBlackColor.withValues(alpha: 0.8),
                  ),
                ),
              ],
              SizedBox(height: 20.h),
              _label("Check-in by"),
              _value(data.completionTime),
            ],
          ),
        ),
        Positioned(
          top: -5.h,
          left: 24.w,
          child: Container(
            width: 52.w,
            height: 52.w,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE0DCD7), width: 4.w),
            ),
            child: const Center(
              child: Text("🌟", style: TextStyle(fontSize: 18)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _label(String text) => Text(
    text,
    style: AppTextStyles.bodyTextStyle.copyWith(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      color: AppColors.primaryBlackColor.withValues(alpha: 0.85),
    ),
  );

  Widget _value(String text) => Padding(
    padding: EdgeInsets.only(top: 6.0.h),
    child: Text(
      text,
      style: AppTextStyles.headingTextStyleBogart.copyWith(
        fontSize: 26.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.primaryBlackColor,
      ),
    ),
  );
}

class ExampleCard extends StatelessWidget {
  const ExampleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final steps = ref.read(aiExamplesControllerProvider).value?.actionSteps;
        final s1 = steps == null || steps.isEmpty
            ? "Search for fun things to do this week"
            : steps[0];
        final s2 = steps == null || steps.isEmpty
            ? "Ask my girlfriend what days she's free"
            : steps[1];

        final s3 = steps == null || steps.isEmpty
            ? "Make the reservation"
            : steps[2];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: SquigglyFrameWidget(
            titleText: "Example",
            descriptionText: "$s1.\n$s2.\n$s3.\nKeep it.",
            descriptionFontSize: 16.sp,
            frameBorderColor: const Color(0xFF6CC163),
          ),
        );
      },
    );
  }
}
