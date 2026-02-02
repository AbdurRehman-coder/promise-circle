import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/core/utils/responsive_config.dart';
import 'package:sbp_app/core/utils/text_styles.dart';
import 'package:sbp_app/features/promise/presentation/widgets/step_description_dynamic_text.dart';
import 'package:sbp_app/features/shared/providers/ai_examples_provider.dart';
import 'package:sbp_app/features/shared/widgets/squiggly_frame_widget.dart';
import 'package:sbp_app/features/shared/widgets/w_custom_form_field.dart';
import 'package:sbp_app/features/promise/provider/promise_controller.dart';
import 'package:sbp_app/features/shared/widgets/staggered_column.dart';

class TextInputStep extends ConsumerWidget {
  final int stepIndex;
  final String title;
  final String description;
  final List<TextInputField> fields;

  const TextInputStep({
    super.key,
    required this.stepIndex,
    required this.title,
    required this.description,
    required this.fields,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initialValue = ref.read(promiseControllerProvider).breakCost;
    final String promiseCostExample =
        ref.read(aiExamplesControllerProvider).value?.breakCost ??
        "If I don’t keep this promise, I’ll keep feeling low on energy and frustrated that my body isn’t where i need it.";
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: StaggeredColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.headingTextStyleBogart,
            ),
          ),
          SizedBox(height: 10.h),
          StepDescriptionDynamicText(description),
          SizedBox(height: 16.h),
          SquigglyFrameWidget(
            titleText: "Example",
            descriptionText: promiseCostExample,
            frameBorderColor: Color(0xFFE47239),
          ),
          SizedBox(height: 16.h),
          ...fields.map((field) {
            return Padding(
              padding: EdgeInsets.only(top: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (field.label != null) ...[
                    Text(
                      field.label!,
                      style: AppTextStyles.bodyTextStyle.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryBlackColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  CustomTextField(
                    initialValue: initialValue,
                    hintText: field.hint,
                    maxLines: 1,
                    expand: true,
                    maxLength: 200,
                    showCounterText: false,
                    filledColor: AppColors.whiteColor,
                    textCapitalization: TextCapitalization.sentences,
                    onChange: (value) => ref
                        .read(promiseControllerProvider.notifier)
                        .setBreakCost(value),
                    textInputAction: fields.indexOf(field) == fields.length - 1
                        ? TextInputAction.next
                        : TextInputAction.next,
                  ),
                ],
              ),
            );
          }),
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
                  "Take a minute to think about what breaking it is costing you now and will continue to cost you in the future.",
                  style: AppTextStyles.mediumBodyTextStyle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TextInputField {
  final String key;
  final String? label;
  final String hint;
  const TextInputField({required this.key, this.label, required this.hint});
}
