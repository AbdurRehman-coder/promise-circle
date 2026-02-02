import 'package:flutter/material.dart';
import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/core/utils/text_styles.dart';
import 'package:sbp_app/features/shared/widgets/squiggly_container.dart';

import '../../../core/utils/responsive_config.dart';

class SquigglyFrameWidget extends StatelessWidget {
  const SquigglyFrameWidget({
    super.key,
    this.titleText,
    required this.descriptionText,
    this.descriptionStartText,
    required this.frameBorderColor,
    this.title,
    this.padding,
    this.descriptionFontSize,
  });
  final String? titleText;
  final String descriptionText;
  final String? descriptionStartText;
  final Color frameBorderColor;
  final Widget? title;
  final EdgeInsets? padding;
  final double? descriptionFontSize;

  @override
  Widget build(BuildContext context) {
    return SquigglyContainer(
      backgroundColor: Colors.white,
      wavelength: 12,
      amplitude: 1.8,
      padding: padding ?? EdgeInsets.all(24),
      seed: 120,
      borderColor: frameBorderColor,
      child: SizedBox(
        width: double.infinity,

        child: Column(
          children: [
            if (titleText != null)
              Text(
                titleText!,
                style: AppTextStyles.bodyTextStyle.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: frameBorderColor,
                ),
                textAlign: TextAlign.center,
              ),
            if (title != null) title!,
            SizedBox(height: 10.h),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  if (descriptionStartText != null)
                    TextSpan(
                      text: descriptionStartText,
                      style: AppTextStyles.bodyTextStyleBogart.copyWith(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryBlackColor,
                      ),
                    ),
                  TextSpan(
                    text: descriptionText,
                    style: AppTextStyles.bodyTextStyleBogart.copyWith(
                      fontSize: descriptionFontSize ?? 18.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryBlackColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
