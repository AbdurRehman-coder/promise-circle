import 'package:flutter/material.dart';
import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/core/utils/text_styles.dart';

import '../../../core/utils/responsive_config.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final String hintText;
  final int maxLines;
  final String? Function(String?)? validator;
  final Color? filledColor;
  final bool isObscure;
  final Widget? sufixIcon;
  final ValueChanged<String>? onChange;
  final bool readOnly;
  final TextCapitalization textCapitalization;
  final TextStyle? style;
  final int? maxLength;
  final bool? showCounterText;
  final Function()? onTap;
  final TextAlign? alignment;
  final bool expand;
  final EdgeInsets? scrollPadding;
  final FocusNode? focusNode;
  // 1. We keep this to control the button icon (Next vs Done)
  final TextInputAction? textInputAction;
  final bool autoFocus;

  // 2. We add this callback in case you want custom logic later
  final void Function(String)? onFieldSubmitted;

  const CustomTextField({
    super.key,
    this.controller,
    this.initialValue,
    this.hintText = "What's one thing you liked or didn't like about the app?",
    this.maxLines = 4,
    this.validator,
    this.filledColor,
    this.scrollPadding,
    this.maxLength,
    this.isObscure = false,
    this.sufixIcon,
    this.onChange,
    this.focusNode,
    this.showCounterText = true,
    this.readOnly = false,
    this.textCapitalization = TextCapitalization.none,
    this.style,
    this.onTap,
    this.expand = false,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
    this.alignment,
    this.autoFocus = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool visible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: widget.focusNode,
      initialValue: widget.controller == null ? widget.initialValue : null,
      obscureText: widget.isObscure && !visible,
      readOnly: widget.readOnly,
      autofocus: widget.autoFocus,
      controller: widget.controller,
      maxLength: widget.maxLength,
      minLines: widget.maxLines,
      textAlign: widget.alignment ?? TextAlign.start,
      maxLines: widget.expand ? null : widget.maxLines,
      scrollPadding: widget.scrollPadding ?? const EdgeInsets.all(20.0),
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: widget.onChange,
      textCapitalization: widget.textCapitalization,
      onTap: widget.onTap,

      textInputAction: widget.textInputAction ?? TextInputAction.next,

      onFieldSubmitted: (value) {
        if (widget.onFieldSubmitted != null) {
          widget.onFieldSubmitted!(value);
        } else {
          if (widget.textInputAction == TextInputAction.next) {
            FocusScope.of(context).focusInDirection(TraversalDirection.right);
          }
        }
      },

      decoration: InputDecoration(
        counterText: widget.showCounterText! ? null : "",
        suffixIcon: widget.isObscure
            ? GestureDetector(
                onTap: () => setState(() => visible = !visible),
                child: Icon(
                  visible
                      ? Icons.visibility_off_outlined
                      : Icons.remove_red_eye_outlined,
                  color: Colors.black.withValues(alpha: .8),
                ),
              )
            : widget.sufixIcon,
        filled: widget.filledColor != null,
        fillColor: widget.filledColor,
        hintText: widget.hintText,
        hintStyle: AppTextStyles.bodyTextStyle.copyWith(
          fontSize: 15.sp,
          fontWeight: FontWeight.w400,
          color: const Color(0xffAAAAAE),
          height: 25 / 14,
        ),
        errorStyle: AppTextStyles.bodyTextStyle.copyWith(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          height: 25 / 14,
          color: AppColors.errorColor,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
          borderSide: const BorderSide(color: Color(0xffE3E3E4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: AppColors.secondaryBlueColor,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
          borderSide: const BorderSide(color: AppColors.errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
          borderSide: const BorderSide(color: AppColors.errorColor, width: 1.5),
        ),
      ),
      style:
          widget.style ??
          AppTextStyles.bodyTextStyle.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            height: 25 / 14,
          ),
    );
  }
}
