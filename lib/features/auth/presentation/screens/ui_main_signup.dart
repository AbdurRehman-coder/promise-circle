import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sbp_app/core/utils/text_styles.dart';
import 'package:sbp_app/features/onboarding/model/onboarding_result.dart';
import 'package:sbp_app/features/shared/widgets/bottom_height_widget.dart';
import 'package:sbp_app/features/shared/widgets/promise_profile_detail_widget.dart';
import 'package:sbp_app/core/utils/responsive_config.dart';
import 'package:sbp_app/features/auth/presentation/screens/login_screen.dart';
import 'package:sbp_app/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:sbp_app/features/auth/provider/authentication_providr.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/utils/app_exports.dart';
import '../../../shared/widgets/w_app_safe_area.dart';
import '../../../shared/widgets/w_primary_button.dart';
import '../../../../core/constants/assets.dart';

class UiMainSignup extends ConsumerStatefulWidget {
  static const String routeName = '/ui-main-signup';
  static String routePath = '/ui-main-signup';
  final OnboardingResult onboarding;
  final bool showCelebration;

  const UiMainSignup({
    super.key,
    required this.onboarding,
    required this.showCelebration,
  });

  @override
  ConsumerState<UiMainSignup> createState() => _UiMainSignupState();
}

class _UiMainSignupState extends ConsumerState<UiMainSignup> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _showUnlockInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Unlock Your Promise Profile",
                style: AppTextStyles.headingTextStyleBogart.copyWith(
                  fontSize: 22.sp,
                  color: AppColors.primaryBlackColor,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.h),
              Text(
                "Create an account to save your progress and start keeping your promises.",
                style: AppTextStyles.semiBoldBodyTextStyle.copyWith(
                  fontSize: 14.sp,
                  color: AppColors.greyColor,
                  fontWeight: FontWeight.normal,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(8.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  child: Text(
                    "Okay",
                    style: AppTextStyles.semiBoldBodyTextStyle.copyWith(
                      fontSize: 16.sp,
                      color: AppColors.primaryBlackColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: AppSafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SizedBox(height: 40.h),
              // AppNameLogo(),
              // Expanded(
              //   child: Padding(
              //     padding: EdgeInsets.symmetric(vertical: 16.h),
              //     child: Column(
              //       children: [

              //         Expanded(
              //           child: CarouselSlider.builder(
              //             carouselController: _carouselController,
              //             itemCount: _onboardingData.length,

              //             itemBuilder: (context, index, realIndex) {
              //               return Column(
              //                 mainAxisAlignment: MainAxisAlignment.end,
              //                 children: [
              //                   Padding(
              //                     padding: EdgeInsets.symmetric(horizontal: 20.w),
              //                     child: Align(
              //                       alignment: Alignment.bottomCenter,
              //                       child: SizedBox(
              //                         height:
              //                             (_onboardingData[index]['height']!
              //                                     as num)
              //                                 .toDouble(),
              //                         width: double.infinity,
              //                         child: Image.asset(
              //                           _onboardingData[index]['image']!,
              //                           fit: BoxFit.fill,
              //                           // gaplessPlayback: true,
              //                         ),
              //                       ),
              //                     ),
              //                   ),
              //                   SizedBox(height: 24.h),
              //                   Text(
              //                     _onboardingData[index]['text']!,
              //                     textAlign: TextAlign.center,
              //                     style: AppTextStyles.headingTextStyleBogart
              //                         .copyWith(
              //                           fontWeight: FontWeight.w600,
              //                           color: AppColors.primaryBlackColor,
              //                           height: 1.2,
              //                         ),
              //                   ),
              //                 ],
              //               );
              //             },
              //             options: CarouselOptions(
              //               autoPlay: true,
              //               autoPlayInterval: const Duration(seconds: 3),
              //               autoPlayAnimationDuration: const Duration(
              //                 milliseconds: 800,
              //               ),
              //               viewportFraction: 1.0,
              //               enableInfiniteScroll: true,

              //               height: double.infinity,
              //               onPageChanged: (index, reason) {
              //                 setState(() {
              //                   _currentIndex = index;
              //                 });
              //               },
              //             ),
              //           ),
              //         ),

              //         SizedBox(height: 24.h),
              //         AnimatedSmoothIndicator(
              //           activeIndex: _currentIndex,
              //           count: _onboardingData.length,
              //           onDotClicked: (index) {
              //             _carouselController.animateToPage(index);
              //           },
              //           effect: ExpandingDotsEffect(
              //             activeDotColor: AppColors.primaryBlackColor,
              //             dotColor: AppColors.grey200Color,
              //             dotHeight: 8.h,
              //             dotWidth: 8.w,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              SizedBox(height: 15.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    PromiseProfileDetailWidget(
                      onboarding: widget.onboarding,
                      showPromiseExample: false,
                      showCelebration: widget.showCelebration,
                      isSliderLocked: true,
                    ),
                    SizedBox(height: 16.h),
                    InkWell(
                      onTap: () => _showUnlockInfoDialog(context),
                      borderRadius: BorderRadius.circular(99.w),
                      child: Container(
                        height: 56.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(99.w),
                          border: Border.all(
                            color: Colors.grey.shade100,
                            width: 1.w,
                          ),
                        ),
                        child: Text(
                          "🔓  Unlock Your Full Promise Profile",
                          style: AppTextStyles.semiBoldBodyTextStyle.copyWith(
                            fontSize: 14.sp,
                            color: AppColors.primaryBlackColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24.r),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 20.h),
                      Row(
                        children: [
                          Expanded(
                            child: PrimaryButton(
                              text: "Login",
                              backgroundColor: AppColors.primaryBlackColor,
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  LoginScreen.routeName,
                                );
                              },
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: PrimaryButton(
                              text: "Sign up",
                              borderColor: const Color(0xffE2E1E0),
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  SignUpScreen.routeName,
                                );
                              },
                              backgroundColor: AppColors.whiteColor,
                              textColor: AppColors.primaryBlackColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      PrimaryButton(
                        text: "Continue with Google",
                        icon: SvgPicture.asset(
                          Assets.svgGoogleIcon,
                          width: 24.w,
                          height: 24.h,
                          fit: BoxFit.fill,
                        ),
                        isLoading: ref
                            .watch(authenticationProvider)
                            .googleLoading,
                        useOverlayLoader: true,
                        iconLeading: true,
                        borderColor: const Color(0xffE2E1E0),
                        onPressed: () {
                          ref
                              .read(authenticationProvider.notifier)
                              .signInWithGoogle(ref, context);
                        },
                        backgroundColor: AppColors.whiteColor,
                        textColor: AppColors.primaryBlackColor,
                      ),
                      if (Platform.isIOS) SizedBox(height: 16.h),
                      if (Platform.isIOS)
                        PrimaryButton(
                          text: "Continue with Apple",
                          icon: Icon(
                            Icons.apple,
                            color: Colors.black,
                            size: 24.w,
                          ),
                          useOverlayLoader: true,
                          iconLeading: true,
                          isLoading: ref
                              .watch(authenticationProvider)
                              .appleLoading,
                          borderColor: const Color(0xffE2E1E0),
                          onPressed: () {
                            ref
                                .read(authenticationProvider.notifier)
                                .signInWithApple(ref, context);
                          },
                          backgroundColor: AppColors.whiteColor,
                          textColor: AppColors.primaryBlackColor,
                        ),
                      BottomHeightWidget(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
