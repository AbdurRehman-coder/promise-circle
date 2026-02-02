import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sbp_app/core/constants/assets.dart';
import 'package:sbp_app/core/services/notification_service.dart';
import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/core/utils/responsive_config.dart';
import 'package:sbp_app/core/utils/text_styles.dart';
import 'package:sbp_app/features/seven_day_challenge/presentation/screens/seven_day_challenge_screen.dart';
import 'package:sbp_app/features/seven_day_challenge/provider/challenge_provider.dart';
import 'package:sbp_app/features/shared/widgets/squiggly_container.dart';
import 'package:sbp_app/features/shared/widgets/w_app_safe_area.dart';
import 'package:sbp_app/features/shared/widgets/w_app_text_logo.dart';
import 'package:sbp_app/features/shared/widgets/w_primary_button.dart';

import '../../../../core/services/facebook_events_service.dart';

class ChallengeIntroScreen extends ConsumerWidget {
  const ChallengeIntroScreen({super.key});
  static const String routeName = '/challenge-intro';
  double degToRad(double deg) => deg * (3.141592653589793 / 180);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ResponsiveLayout.init(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: AppSafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    SizedBox(height: 36.h),
                    const Center(child: AppNameLogo()),
                    SizedBox(height: 44.h),
                    Image.asset(Assets.challengeIntroIllus, height: 200.h),
                    SizedBox(height: 32.h),
                    Text(
                      "The 7-Day\nPromise Reset",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.headingTextStyleBogart.copyWith(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      "As you start keeping promises,\nwe help you focus on the right ones.",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.mediumBodyTextStyle.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 32.h),
                    Transform.rotate(
                      angle: degToRad(-2.13),

                      child: SquigglyContainer(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.h,
                          vertical: 20.h,
                        ),
                        borderColor: Color(0xFF909090),
                        child: Row(
                          children: [
                            Icon(
                              Icons.heart_broken,
                              color: Colors.red,
                              size: 36.sp,
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Text(
                                "Most people don’t break promises because they don’t care.",
                                textAlign: TextAlign.start,
                                style: AppTextStyles.bodyTextStyleBogart
                                    .copyWith(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      height: 1.5,
                                    ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Transform.rotate(
                      angle: degToRad(2.45),
                      child: SquigglyContainer(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 20.h,
                        ),
                        borderColor: Color(0xFFF4BA64),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "They break them\nbecause they make too\nmany, make them too\nvague, or make them for\nthe wrong reasons.",
                                textAlign: TextAlign.start,
                                style: AppTextStyles.bodyTextStyleBogart
                                    .copyWith(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      height: 1.5,
                                    ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              "💬  💬  💬  💬\n💬  💬  💬  💬\n💬  💬  💬  💬\n💬  💬  💬  💬\n💬  💬  💬  💬",
                              style: TextStyle(fontSize: 16.sp),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 32.h),
                    Text(
                      "For the next 7 days, you’ll\nfocus on some core life\npromises.",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.headingTextStyleBogart.copyWith(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 32.h),
                    Text(
                      "You’ll make the promises that actually matter to you — and to the people and things most affected by your word.",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyTextStyleBogart.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 32.h),
                    SquigglyContainer(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 20.h,
                      ),
                      borderColor: Color(0xFF6CC163),
                      child: Column(
                        children: [
                          Text(
                            "Most people create\n2 to 3 promises a day.\nThere’s no rush.",
                            textAlign: TextAlign.center,
                            style: AppTextStyles.headingTextStyleBogart
                                .copyWith(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            "Clarity and Honesty\nare the goal.",
                            textAlign: TextAlign.center,
                            style: AppTextStyles.headingTextStyleBogart
                                .copyWith(
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF6CC163),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(height: 38.h),
                    PrimaryButton(
                      isLoading: ref.watch(challengeProvider).isLoading,
                      useOverlayLoader: true,
                      onPressed: () async {
                        bool? isGranted = await NotificationService()
                            .requestPermissions();

                        if (isGranted) {
                          await ref
                              .read(challengeProvider.notifier)
                              .startChallenge();
                          if (ref.read(challengeProvider).hasError) {
                            return;
                          }
                          final fbEvents = FacebookEventsService();

                          fbEvents.logEvent(
                            name: "seven_day_challenge_start",
                            parameters: {
                              'timestamp': DateTime.now().toIso8601String(),
                            },
                            ref: ref,
                            screenName: 'Seven Day Challenge Intro',
                          );
                          if (context.mounted) {
                            Navigator.pushReplacementNamed(
                              context,
                              SevenDayChallengeScreen.routeName,
                            );
                          }
                        }
                      },
                      text: "Start the Promise Reset",
                      icon: SvgPicture.asset(Assets.svgArrowForward),
                    ),
                    SizedBox(height: 12.h),
                    Center(
                      child: Text(
                        "You can’t keep what you haven’t clearly chosen.",
                        style: AppTextStyles.mediumBodyTextStyle.copyWith(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryBlackColor.withValues(
                            alpha: 0.8,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
