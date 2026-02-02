import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sbp_app/core/constants/assets.dart';
import 'package:sbp_app/core/constants/promise_profile_data.dart';
import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/core/utils/responsive_config.dart';
import 'package:sbp_app/core/utils/text_styles.dart';
import 'package:sbp_app/features/onboarding/presentation/screens/ui_onboarding.dart';
import 'package:sbp_app/features/onboarding/presentation/screens/promise_profile_screen.dart';
import 'package:sbp_app/features/shared/widgets/w_app_text_logo.dart';
import 'package:sbp_app/features/shared/widgets/w_primary_button.dart';

import '../../../shared/widgets/w_app_safe_area.dart';

class UIWelcomeScreen extends StatefulWidget {
  const UIWelcomeScreen({super.key, this.data});
  final Map<String, dynamic>? data;
  // ADDED ROUTE NAME
  static const String routeName = '/welcome';

  @override
  State<UIWelcomeScreen> createState() => _UIWelcomeScreenState();
}

class _UIWelcomeScreenState extends State<UIWelcomeScreen> {
  late final ScrollController _scrollController;
  static const double _scrollSpeed = 50.0;

  final List<MapEntry<String, String>> _sliderList = promiseProfileAvatarMap
      .entries
      .toList();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  void _startAutoScroll() {
    if (_scrollController.hasClients) {
      final double currentOffset = _scrollController.offset;
      final double targetOffset = currentOffset + 10000.0;

      final int durationInSeconds =
          ((targetOffset - currentOffset) / _scrollSpeed).round();

      _scrollController
          .animateTo(
            targetOffset,
            duration: Duration(seconds: durationInSeconds),
            curve: Curves.linear,
          )
          .then((_) {
            if (mounted) {
              _startAutoScroll();
            }
          });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double itemWidth = MediaQuery.of(context).size.width * 0.5;

    return Scaffold(
      body: AppSafeArea(
        child: Column(
          children: [
            SizedBox(height: 40.h),
            const Center(child: AppNameLogo()),
            SizedBox(height: 36.h),

            SizedBox(
              height: 230.h,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final item = _sliderList[index % _sliderList.length];

                  return SizedBox(
                    width: itemWidth,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 22.h,
                          horizontal: 8.w,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.secondaryBlueColor,
                              AppColors.secondaryBlueColor,
                              AppColors.secondaryBlueColor.withValues(
                                alpha: 0.3,
                              ),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              item.key,
                              textAlign: TextAlign.center,
                              style: AppTextStyles.bodyTextStyleBogart.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 24.sp,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 22.h),
                            Expanded(
                              child: item.key == "Competitor"
                                  ? Image.asset(
                                      Assets.pngCompetitorOnboardingResult,
                                      fit: BoxFit.contain,
                                    )
                                  : SvgPicture.asset(
                                      item.value,
                                      fit: BoxFit.contain,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 25.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  Text(
                    "Your Promise Profile\n is the real reason why\n you make and break\n promises.",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.headingTextStyleBogart.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  Text(
                    "This quiz will help you identify your Promise Profile™ out of 8 types. \n\nIt’s the first step in your journey\n to Promise Circles.",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyTextStyleBogart.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 22.sp,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: PrimaryButton(
                text: 'Discover my Promise Profile™',
                onPressed: () {
                  if (widget.data != null) {
                    Navigator.pushNamed(
                      context,
                      arguments: widget.data,
                      PromiseProfileScreen.routeName,
                    );
                  } else {
                    Navigator.pushNamed(context, UIOnboardingScreen.routeName);
                  }
                },
                icon: SvgPicture.asset(
                  Assets.svgArrowForward,
                  height: 20.h,
                  width: 24.w,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }
}
