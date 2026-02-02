import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/core/utils/app_extensions.dart';
import 'package:sbp_app/core/utils/text_styles.dart';
import 'package:sbp_app/features/promise/presentation/widgets/step_description_dynamic_text.dart';
import 'package:sbp_app/features/shared/widgets/w_custom_form_field.dart';
import 'package:sbp_app/features/promise/models/option_model.dart';
import 'package:sbp_app/features/promise/provider/promise_controller.dart';
import 'package:sbp_app/features/shared/widgets/staggered_column.dart';

import '../../../../core/utils/responsive_config.dart' show SizeExtension;

class MultiSelectStep extends ConsumerWidget {
  final int stepIndex;
  final String title;
  final String description;
  final List<SelectOption> options;
  final bool needsNameInput;
  final bool needsCustomInput;

  const MultiSelectStep({
    super.key,
    required this.stepIndex,
    required this.title,
    required this.description,
    required this.options,
    this.needsNameInput = false,
    this.needsCustomInput = false,
  });

  Widget _buildField(
    String label,
    String? initialValue,
    Function(String) onChanged, {
    bool optional = false,
    String? hint,
    bool expand = false,
    bool isLast = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label.capitalize,
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
        SizedBox(height: 8.h),
        CustomTextField(
          initialValue: initialValue,
          hintText: hint ?? "Why does this matter?",
          maxLines: 1,
          expand: expand,
          showCounterText: false,
          maxLength: 100,
          textCapitalization: TextCapitalization.sentences,
          filledColor: AppColors.whiteColor,
          onChange: onChanged,
          textInputAction: isLast ? TextInputAction.next : TextInputAction.next,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(promiseControllerProvider);
    final controller = ref.read(promiseControllerProvider.notifier);

    final isWhoStep = stepIndex == 6;
    // final isFeelStep = stepIndex == 7;
    final selections = isWhoStep ? state.whoSelections : state.feelSelections;

    // Filter options to exclude "Other" if we are in the Feel step
    final displayOptions = isWhoStep
        ? options
        : options.where((element) => element.label != 'Other').toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: StaggeredColumn(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.headingTextStyleBogart.copyWith(
              fontSize: 32.sp,
            ),
          ),
          SizedBox(height: 20.h),
          StepDescriptionDynamicText(description),
          // Text.rich(
          //   TextSpan(
          //     // Common style for the whole paragraph
          //     style: AppTextStyles.bodyTextStyle.copyWith(
          //       fontWeight: FontWeight.w600,
          //       fontSize: 14.sp,
          //       color: AppColors.primaryBlackColor.withValues(alpha: 0.75),
          //     ),
          //     children: [
          //       // if (isFeelStep) ...[
          //       //   TextSpan(
          //       //     text: "Be honest. ",
          //       //     style: AppTextStyles.bodyTextStyle.copyWith(
          //       //       fontWeight: FontWeight.w600,
          //       //       fontSize: 14.sp,
          //       //       color: AppColors.primaryBlackColor,
          //       //     ),
          //       //   ),

          //       //   TextSpan(text: description.replaceFirst("Be honest. ", "")),
          //       // ] else ...[
          //       TextSpan(text: description),
          //       // ],
          //     ],
          //   ),
          //   textAlign: TextAlign.center,
          // ),
          SizedBox(height: 24.h),
          GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 3,
            ),
            // Use the length of the filtered list
            itemCount: displayOptions.length,
            itemBuilder: (context, index) {
              final option = displayOptions[index];

              // FIND THE ORIGINAL INDEX
              // We must find the index in the original 'options' list
              // so the controller updates the correct item in state.
              final originalIndex = options.indexOf(option);

              final isSelected = selections.contains(originalIndex);

              return GestureDetector(
                onTap: () {
                  if (isWhoStep) {
                    controller.toggleWhoOption(originalIndex, null);
                  } else {
                    controller.toggleFeelOption(originalIndex, null);
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(24.r),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.secondaryBlueColor
                          : AppColors.whiteColor,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ...[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Text(
                            option.icon,
                            style: TextStyle(fontSize: 20.sp, fontFamily: ''),
                          ),
                        ),
                      ],
                      Text(
                        option.label,
                        style: AppTextStyles.bodyTextStyle.copyWith(
                          color: isSelected
                              ? AppColors.secondaryBlueColor
                              : AppColors.primaryBlackColor,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          if (selections.isNotEmpty && isWhoStep) SizedBox(height: 32.h),
          if (needsNameInput)
            ...selections.where((i) => i != 0).map((i) {
              final rawLabel = options[i].label;
              final formattedLabel = rawLabel.toLowerCase().startsWith('my ')
                  ? "${rawLabel.substring(3)} Name"
                  : "$rawLabel Name";

              return Padding(
                padding: EdgeInsets.only(top: 16.h),
                child: _buildField(
                  formattedLabel,
                  state.whoNames[i],
                  (val) => controller.setWhoName(i, val),
                  optional: true,
                  hint: "Name",
                  expand: true,
                ),
              );
            }),

          // This block remains exactly the same to show the Other input field
          if (!isWhoStep)
            Padding(
              padding: EdgeInsets.only(top: 32.h),
              child: _buildField(
                "Other feeling",

                state.feelCustomValues[8],
                (val) => controller.setFeelCustomValue(8, val),
                hint: "Feeling",
                optional: false,
                expand: true,
                isLast: true,
              ),
            ),
          if (isWhoStep) SizedBox(height: 16.h),
          if (isWhoStep)
            Row(
              children: [
                Icon(
                  Icons.remove_red_eye_outlined,
                  size: 20.sp,
                  color: AppColors.primaryBlackColor.withValues(alpha: 0.5),
                ),
                SizedBox(width: 8.w),
                Text(
                  "Keeping this Promise will show up for them.",
                  textAlign: TextAlign.start,
                  style: AppTextStyles.mediumBodyTextStyle,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
