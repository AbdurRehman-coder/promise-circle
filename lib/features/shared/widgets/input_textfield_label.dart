import 'package:flutter/material.dart';
import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/core/utils/responsive_config.dart';
import 'package:sbp_app/core/utils/text_styles.dart';
import 'package:sbp_app/features/shared/widgets/w_custom_form_field.dart';

class BuildInputFieldLabel extends StatelessWidget {
  const BuildInputFieldLabel({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.keyboardType,
    this.isObscure = false,
    this.sufixIcon,
    this.onChange,
    this.readOnly = false,
    this.validator,
    this.onTap,
    this.textInputAction,
    this.maxlines,
    this.isOptional = false,
  });

  final String label;
  final String hintText;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool isObscure;
  final Widget? sufixIcon;
  final ValueChanged<String>? onChange;
  final bool readOnly;
  final String? Function(String?)? validator;
  final Function()? onTap;
  final int? maxlines;
  final TextInputAction? textInputAction;
  final bool isOptional;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: AppTextStyles.bodyTextStyle.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.blackColor,
            ),
            children: [
              if (isOptional)
                TextSpan(
                  text: ' (Optional)',
                  style: AppTextStyles.bodyTextStyle.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.greyColor,
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        CustomTextField(
          filledColor: AppColors.whiteColor,
          controller: controller,
          hintText: hintText,
          maxLines: maxlines ?? 1,
          isObscure: isObscure,
          sufixIcon: sufixIcon,
          textInputAction: textInputAction,
          onChange: onChange,
          readOnly: readOnly,
          validator: validator,
          onTap: onTap,
        ),
      ],
    );
  }
}
