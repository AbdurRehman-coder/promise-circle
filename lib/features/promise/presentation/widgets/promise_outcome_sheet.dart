import 'package:flutter_svg/flutter_svg.dart';
import 'package:sbp_app/features/promise/models/promise_model.dart';

import '../../../../core/constants/assets.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/utils/app_exports.dart';
import '../../../../core/utils/responsive_config.dart';
import '../../../../core/utils/text_styles.dart';
import '../../../shared/widgets/w_primary_button.dart';
import 'promise_reflection_sheet.dart';

class PromiseOutcomeSheet extends StatelessWidget {
  final bool isKept;
  final PromiseModel promise;
  const PromiseOutcomeSheet({super.key, required this.isKept, required this.promise});

  @override
  Widget build(BuildContext context) {
    final imageAsset = isKept
        ? Assets.svgKeptPromiseIllus
        : Assets.svgBrokePromiseIllus;

    final title = isKept ? "Congratulations!" : "It’s okay.";

    final subTitleHeadline = isKept
        ? "You kept your Promise."
        : "You didn’t keep your\nPromise — yet.";

    final description = isKept
        ? "That’s one step closer to your best self."
        : "Progress isn’t linear. Reset, and try again today.";

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      child: Column(
        children: [
          SizedBox(height: 12.h),
          Container(
            height: 5.h,
            width: 40.w,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          const Spacer(flex: 2),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: SvgPicture.asset(
              imageAsset,
              fit: BoxFit.contain,
              height: 330.h,
            ),
          ),

          const Spacer(flex: 2),

          Text(
            title,
            style: AppTextStyles.headingTextStyleBogart.copyWith(
              fontSize: 32.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryBlackColor,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            subTitleHeadline,
            textAlign: TextAlign.center,
            style: AppTextStyles.headingTextStyleBogart.copyWith(
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryBlackColor,
              height: 1.2,
            ),
          ),
          SizedBox(height: 26.h),
          Text(
            description,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyTextStyle.copyWith(
              fontSize: 14.sp,
              color: AppColors.primaryBlackColor,
              fontWeight: FontWeight.w500,
            ),
          ),

          const Spacer(flex: 2),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 32.h),
            child: SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showReflectionSheet(context);
                },

                text: "Add a Quick Reflection",
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showReflectionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child:  ReflectionSheet(promise: promise,),
      ),
    );
  }
}
