import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/core/utils/text_styles.dart';
import 'package:sbp_app/features/promise/presentation/widgets/step_description_dynamic_text.dart';
import 'package:sbp_app/features/promise/provider/promise_controller.dart';
import 'package:sbp_app/features/shared/widgets/squiggly_container.dart';
import 'package:sbp_app/features/shared/widgets/w_app_text_logo.dart';
import 'package:sbp_app/features/shared/widgets/w_primary_button.dart';
import 'package:sbp_app/features/shared/widgets/staggered_column.dart';

import '../../../../core/utils/responsive_config.dart';

class TransformStep extends ConsumerStatefulWidget {
  const TransformStep({super.key});

  @override
  ConsumerState<TransformStep> createState() => _TransformStepState();
}

class _TransformStepState extends ConsumerState<TransformStep> {
  @override
  void initState() {
    super.initState();
    // Background API call happens immediately but doesn't block the UI
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(promiseControllerProvider.notifier).transformBrokenOnes();
    });
  }

  int? sIndex;
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(promiseControllerProvider);
    final controller = ref.read(promiseControllerProvider.notifier);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: StaggeredColumn(
        children: [
          const Center(child: AppNameLogo()),
          SizedBox(height: 45.h),
          Text(
            "Want to keep any of those missed promises this year?",
            textAlign: TextAlign.center,
            style: AppTextStyles.headingTextStyleBogart.copyWith(
              fontSize: 32.sp,
            ),
          ),
          SizedBox(height: 16.h),
          StepDescriptionDynamicText(
            "This could be a good chance to recommit, especially if it means a lot to you.",
          ),
          SizedBox(height: 16.h),

          _buildBrokenCard(1, state.brokenPromise1 ?? "", controller),
          _buildBrokenCard(2, state.brokenPromise2 ?? "", controller),
          if (state.brokenPromise3?.isNotEmpty ?? false)
            _buildBrokenCard(3, state.brokenPromise3 ?? "", controller),

          SizedBox(height: 32.h),
          Text(
            "Or skip starting with Broken Promises.",
            textAlign: TextAlign.center,
            style: AppTextStyles.mediumBodyTextStyle,
          ),
        ],
      ),
    );
  }

  bool isClicked = false;
  Widget _buildBrokenCard(
    int index,
    String text,
    PromiseController controller,
  ) {
    if (text.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: SquigglyContainer(
        borderColor: Color(0xFF6258B5),
        // titleText: "BROKEN PROMISE #$index",
        // titleColor: const Color(0xFFD97474),
        // frameBorderColor: const Color(0xFFD97474),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            children: [
              Text(
                "MAKE A PROMISE",
                style: AppTextStyles.bodyTextStyle.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF6258B5),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 18.h),
              Text(
                text.trim(),
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyTextStyleBogart.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 20.h),
              PrimaryButton(
                text: "Make this my first Promise",
                isOutlined: true,
                isLoading: isClicked && sIndex == index,
                enabled: !(isClicked) && sIndex == null,
                useOverlayLoader: true,
                textColor: AppColors.primaryBlackColor,
                borderColor: AppColors.primaryBlackColor.withValues(
                  alpha: 0.15,
                ),

                onPressed: () async {
                  setState(() {
                    sIndex = index;
                    isClicked = true;
                  });
                  await controller.getPromiseExampleFromBroken(
                    ref,
                    showLoading: false,
                  );
                  if (controller.isBrokenPromisesTranform == true) {
                    controller.selectAndMapTransformed(index);
                    ref.read(promiseStepIndexProvider.notifier).state = 2;
                  } else {
                    ref
                        .read(promiseControllerProvider.notifier)
                        .transformBrokenCompleter!
                        .future
                        .then((v) {
                          controller.selectAndMapTransformed(index);
                          ref.read(promiseStepIndexProvider.notifier).state = 2;
                        });
                  }
                  setState(() {
                    sIndex = null;
                    isClicked = false;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
