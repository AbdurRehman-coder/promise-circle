import 'package:flutter_svg/svg.dart';
import 'package:sbp_app/core/utils/responsive_config.dart';

import '../../../../core/theming/app_colors.dart';
import '../../../../core/utils/app_exports.dart';
import '../../../../core/constants/assets.dart';

class HeaderWithProgress extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback? onBack;
  final bool backButton;

  const HeaderWithProgress({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.onBack,
    this.backButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (backButton) ...{
          GestureDetector(
            onTap: () => onBack?.call(),
            child: SvgPicture.asset(
              Assets.svgArrowBackward,
              fit: BoxFit.fill,
              height: 24.h,
              width: 24.w,
            ),
          ),
          const SizedBox(width: 8),
        },
        Expanded(
          child: Row(
            children: List.generate(totalSteps, (index) {
              final isActive = index <= currentStep;
              return Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 3.5.w),
                  height: 6.h,
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.primaryBlackColor
                        : AppColors.grey300Color.withValues(alpha: 0.27),
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
