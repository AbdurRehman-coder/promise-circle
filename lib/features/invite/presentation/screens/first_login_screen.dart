import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sbp_app/core/utils/responsive_config.dart';
import 'package:sbp_app/core/utils/text_styles.dart';
import 'package:sbp_app/features/main_home/presentations/main_home_screen.dart';
import 'package:sbp_app/features/shared/widgets/w_app_text_logo.dart';
import 'package:sbp_app/features/shared/widgets/w_primary_button.dart';
import 'package:sbp_app/features/auth/provider/authentication_providr.dart';
import 'package:sbp_app/core/constants/assets.dart';

import '../../../seven_day_challenge/presentation/screens/challenge_intro_screen.dart';
import '../../../seven_day_challenge/presentation/screens/seven_day_challenge_screen.dart';
import '../../../seven_day_challenge/provider/challenge_provider.dart'
    show ChallengeStateX, challengeProvider;
import '../../../shared/widgets/w_app_safe_area.dart';

class FirstLoginScreen extends ConsumerStatefulWidget {
  static const String routeName = '/first-time-login';
  static const String routePath = '/first-time-login';

  final String code;

  const FirstLoginScreen({super.key, required this.code});

  @override
  ConsumerState<FirstLoginScreen> createState() => _FirstLoginScreenState();
}

class _FirstLoginScreenState extends ConsumerState<FirstLoginScreen> {
  bool _isLoading = false;

  Future<void> _handleNavigation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = ref.read(authenticationProvider.notifier);
      authProvider.setInviteCode(widget.code);
      authProvider.getUserSubscription();

      await ref.read(challengeProvider.notifier).loadChallenge();

      if (!mounted) return;

      final challengeState = ref.read(challengeProvider);

      if (challengeState.hasError) {
        return;
      }

      final route = challengeState.isChallengeCompleted
          ? HomeDashboardPage.routeName
          : challengeState.isChallengeCreated
          ? challengeState.isUpdatedToday
                ? HomeDashboardPage.routeName
                : SevenDayChallengeScreen.routeName
          : ChallengeIntroScreen.routeName;

      Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppSafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40.h),
              const AppNameLogo(),
              SizedBox(height: 40.h),
              SvgPicture.asset(Assets.svgHandClapping, height: 265.h),
              SizedBox(height: 30.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Congratulations',
                    style: AppTextStyles.headingTextStyleBogart.copyWith(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text('🎉', style: TextStyle(fontSize: 32.sp)),
                ],
              ),
              SizedBox(height: 44.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Column(
                  children: [
                    Text.rich(
                      TextSpan(
                        style: AppTextStyles.bodyTextStyleBogart.copyWith(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        children: [
                          const TextSpan(
                            text: 'You’ve taken the most important step to ',
                          ),
                          const TextSpan(
                            text: 'Stop Breaking Promises.',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
              Text(
                'This year you’ll make better promises, keep them, share them — and find communities built around the same promises you keep.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyTextStyleBogart.copyWith(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              SizedBox(height: 10.h),
              PrimaryButton(
                fullWidth: true,
                text: 'Make More Promises',
                icon: SvgPicture.asset(
                  Assets.svgArrowForward,
                  height: 20.h,
                  width: 24.w,
                ),
                isLoading: _isLoading,
                useOverlayLoader: true,
                onPressed: _isLoading ? () {} : _handleNavigation,
                iconLeading: false,
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }
}
