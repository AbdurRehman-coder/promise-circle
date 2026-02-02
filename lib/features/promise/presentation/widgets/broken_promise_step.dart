import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/core/utils/text_styles.dart';
import 'package:sbp_app/features/promise/presentation/widgets/step_description_dynamic_text.dart'
    show StepDescriptionDynamicText;
import 'package:sbp_app/features/shared/widgets/squiggly_frame_widget.dart';
import 'package:sbp_app/features/shared/widgets/w_app_text_logo.dart';
import 'package:sbp_app/features/shared/widgets/w_custom_form_field.dart';
import 'package:sbp_app/features/promise/provider/promise_controller.dart';
import 'package:sbp_app/features/shared/widgets/staggered_column.dart';
import '../../../../core/utils/responsive_config.dart';
import '../../../shared/providers/ai_examples_provider.dart';

class BrokenStep extends ConsumerStatefulWidget {
  const BrokenStep({super.key});

  @override
  ConsumerState<BrokenStep> createState() => _BrokenStepState();
}

class _BrokenStepState extends ConsumerState<BrokenStep> {
  late FocusNode focusNode1;
  late FocusNode focusNode2;
  late FocusNode focusNode3;

  bool _showSecondField = false;
  bool _showThirdField = false;
  late final String brokenPromiseExample;
  @override
  void initState() {
    super.initState();
    brokenPromiseExample =
        ((ref.read(aiExamplesControllerProvider).value?.samplePromise) ??
                "I Promised that I’d be more consistent with exercise and wasn’t.")
            .substring(9);
    focusNode1 = FocusNode();
    focusNode2 = FocusNode();
    focusNode3 = FocusNode();

    final state = ref.read(promiseControllerProvider);
    if (state.brokenPromise1 != null &&
        state.brokenPromise1!.trim().isNotEmpty) {
      _showSecondField = true;
    }
    if (state.brokenPromise2 != null &&
        state.brokenPromise2!.trim().isNotEmpty) {
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
          Center(child: AppNameLogo()),
          SizedBox(height: 45.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  "So, what are a few promises you didn’t keep in 2025?",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.headingTextStyleBogart.copyWith(
                    fontSize: 32.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          StepDescriptionDynamicText(
            "Big or small... to yourself, your family or friends?",
          ),
          SizedBox(height: 16.h),
          SquigglyFrameWidget(
            titleText: "Example",
            descriptionStartText: "I Promised",
            descriptionText: brokenPromiseExample,
            frameBorderColor: const Color(0xFF3E92E5),
          ),
          SizedBox(height: 32.h),

          // --- FIELD 1 ---
          _buildField(
            "What’s the first one you missed?",
            state.brokenPromise1, // Direct from provider
            focusNode: focusNode1,
            hintText: "Share the very first one that comes to mind",
            expand: true,
            textAction: TextInputAction.next,
            onChanged: (v) {
              controller.setBrokenPromise(1, v);
            },
            onSubmitted: (v) {
              if (v.trim().isNotEmpty) {
                // 1. Latch Focus to prevent keyboard close
                focusNode1.requestFocus();

                // 2. Show next field
                setState(() {
                  _showSecondField = true;
                });

                controller.setBrokenPromise(1, v);

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
                  "What’s another one that comes to mind?",
                  state.brokenPromise2, // Direct from provider
                  focusNode: focusNode2,
                  optional: true,
                  hintText: "Yup, its time to get it out of your head",
                  expand: true,
                  textAction: TextInputAction.next,
                  onChanged: (v) {
                    controller.setBrokenPromise(2, v);
                  },
                  onSubmitted: (v) {
                    if (v.trim().isNotEmpty) {
                      focusNode2.requestFocus(); // Latch

                      setState(() {
                        _showThirdField = true;
                      });

                      controller.setBrokenPromise(2, v);

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
                  "Add one more if it feels helpful",
                  state.brokenPromise3, // Direct from provider
                  focusNode: focusNode3,
                  optional: true,
                  hintText: "That one that you always seem to miss",
                  expand: true,
                  textAction: TextInputAction.done,
                  onChanged: (v) {
                    controller.setBrokenPromise(3, v);
                  },
                  onSubmitted: (v) {
                    controller.setBrokenPromise(3, v);
                  },
                ),
              ],
            ),
          ),

          SizedBox(height: 16.h),
          Row(
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
                  "There’s no judgment here, just honesty. This helps clear space so you can make a promise that actually sticks.",
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
    bool optional = false,
    String? hintText,
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
            if (optional) ...[
              Text(
                " (optional)",
                style: AppTextStyles.bodyTextStyle.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryBlackColor.withValues(alpha: .3),
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: 8.h),
        CustomTextField(
          initialValue: initialValue,
          hintText: hintText ?? "Why does this matter?",
          maxLines: 1,
          maxLength: 100,
          showCounterText: false,
          expand: expand,
          focusNode: focusNode,
          textCapitalization: TextCapitalization.sentences,
          filledColor: AppColors.whiteColor,
          onChange: onChanged,
          onFieldSubmitted: onSubmitted,
          textInputAction: textAction,
        ),
      ],
    );
  }
}
