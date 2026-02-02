import 'package:flutter/material.dart';
import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/core/utils/responsive_config.dart';
import 'package:sbp_app/core/utils/text_styles.dart' show AppTextStyles;

class StepDescriptionDynamicText extends StatelessWidget {
  const StepDescriptionDynamicText(this.text, {super.key, this.textAlign});

  final String text;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Text(
        text,
        textAlign: textAlign ?? TextAlign.center,
        style: AppTextStyles.boldBodyTextStyle.copyWith(
          color: AppColors.primaryBlackColor.withValues(alpha: 0.75),
        ),
      ),
    );
  }
}
