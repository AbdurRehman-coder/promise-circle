import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/core/utils/text_styles.dart';
import 'package:sbp_app/features/promise/presentation/widgets/step_description_dynamic_text.dart';
import 'package:sbp_app/features/shared/providers/ai_examples_provider.dart';
import 'package:sbp_app/features/shared/widgets/squiggly_frame_widget.dart';
import 'package:sbp_app/features/shared/widgets/w_custom_form_field.dart';
import 'package:sbp_app/features/promise/provider/promise_controller.dart';
import 'package:sbp_app/features/shared/widgets/staggered_column.dart';
import '../../../../core/utils/responsive_config.dart';

class WhyStep extends ConsumerStatefulWidget {
  const WhyStep({super.key});

  @override
  ConsumerState<WhyStep> createState() => _WhyStepState();
}

class _WhyStepState extends ConsumerState<WhyStep> {
  late FocusNode focusNode1;
  late FocusNode focusNode2;
  late FocusNode focusNode3;
  late String promiseReasonExample;

  // Boolean flags to control visibility manually
  bool _showSecondField = false;
  bool _showThirdField = false;

  @override
  void initState() {
    super.initState();
    promiseReasonExample =
        ref.read(aiExamplesControllerProvider).value?.promiseReason ??
        "I want to have the daily energy it takes to live my most fulfilling life.";
    focusNode1 = FocusNode();
    focusNode2 = FocusNode();
    focusNode3 = FocusNode();

    // Check provider state to maintain visibility if revisiting the step
    final state = ref.read(promiseControllerProvider);
    if (state.reason1.trim().isNotEmpty) {
      _showSecondField = true;
    }
    if (state.reason2.trim().isNotEmpty) {
      _showThirdField = true;
    }
  }

  @override
  void dispose() {
    focusNode1.dispose();
    focusNode2.dispose();
    focusNode3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(promiseControllerProvider.notifier);
    final state = ref.watch(promiseControllerProvider);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: StaggeredColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "Why is keeping this promise important?",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.headingTextStyleBogart.copyWith(
                    fontSize: 32.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: StepDescriptionDynamicText(
                  "Share up to 3 reasons that inspire you.",
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          SquigglyFrameWidget(
            titleText: "Example",
            descriptionText: promiseReasonExample,
            frameBorderColor: const Color(0xFF3E92E5),
          ),
          SizedBox(height: 32.h),

          // --- FIELD 1 ---
          _buildField(
            "What’s the first reason that comes to mind?",
            state.reason1, // Direct from provider
            focusNode: focusNode1,
            hint: "What makes this meaningful to you",
            expand: true,
            textAction: TextInputAction.next,
            onChanged: (v) {
              controller.setReason(1, v);
            },
            onSubmitted: (v) {
              if (v.trim().isNotEmpty) {
                // 1. Latch Focus
                focusNode1.requestFocus();

                // 2. Show next field
                setState(() {
                  _showSecondField = true;
                });

                controller.setReason(1, v);

                // 3. Move focus to next field
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  focusNode2.requestFocus();
                });
              }
            },
          ),

          // --- FIELD 2 ---
          Visibility(
            visible: _showSecondField,
            child: StaggeredColumn(
              children: [
                SizedBox(height: 16.h),
                _buildField(
                  "What’s the next one you can think of?",
                  state.reason2, // Direct from provider
                  focusNode: focusNode2,
                  hint: "What else makes this worth keeping",
                  expand: true,
                  optional: true,
                  textAction: TextInputAction.next,
                  onChanged: (v) {
                    controller.setReason(2, v);
                  },
                  onSubmitted: (v) {
                    if (v.trim().isNotEmpty) {
                      focusNode2.requestFocus(); // Latch

                      setState(() {
                        _showThirdField = true;
                      });

                      controller.setReason(2, v);

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        focusNode3.requestFocus();
                      });
                    }
                  },
                ),
              ],
            ),
          ),

          // --- FIELD 3 ---
          Visibility(
            visible: _showThirdField,
            child: StaggeredColumn(
              children: [
                SizedBox(height: 16.h),
                _buildField(
                  "Is there one more reason you’d like to add?",
                  state.reason3, // Direct from provider
                  focusNode: focusNode3,
                  hint: "Give the big one you know you’re holding in",
                  optional: true,
                  expand: true,
                  textAction: TextInputAction.done,
                  onChanged: (v) {
                    controller.setReason(3, v);
                  },
                  onSubmitted: (v) {
                    controller.setReason(3, v);
                  },
                ),
              ],
            ),
          ),

          SizedBox(height: 16.h),
          Row(
            key: const ValueKey('sub-des'),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.access_time,
                size: 20.sp,
                color: AppColors.primaryBlackColor.withValues(alpha: 0.8),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  "Take a minute, this helps anchor your promise.",
                  style: AppTextStyles.mediumBodyTextStyle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildField(
    String label,
    String? initialValue, {
    required FocusNode focusNode,
    required Function(String) onSubmitted,
    required Function(String) onChanged,
    TextInputAction textAction = TextInputAction.next,
    String? hint,
    bool optional = false,
    bool expand = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: AppTextStyles.bodyTextStyle.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryBlackColor,
              ),
            ),
            if (optional)
              Text(
                " (optional)",
                style: AppTextStyles.bodyTextStyle.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryBlackColor.withValues(alpha: .3),
                ),
              ),
          ],
        ),
        SizedBox(height: 8.w),
        CustomTextField(
          initialValue: initialValue,
          hintText: hint ?? "Why does this matter?",
          maxLines: 1,
          expand: expand,
          maxLength: 100,
          textCapitalization: TextCapitalization.sentences,
          filledColor: AppColors.whiteColor,
          focusNode: focusNode,
          onChange: onChanged,
          onFieldSubmitted: onSubmitted,
          showCounterText: false,
          textInputAction: textAction,
        ),
      ],
    );
  }
}
