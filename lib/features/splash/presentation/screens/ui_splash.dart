import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sbp_app/core/constants/assets.dart';
import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/core/utils/responsive_config.dart';
import 'package:sbp_app/features/auth/presentation/screens/ui_main_signup.dart';
import 'package:sbp_app/features/auth/presentation/screens/sign_up_basic_info.dart';
import 'package:sbp_app/features/auth/provider/authentication_providr.dart';
import 'package:sbp_app/features/main_home/presentations/main_home_screen.dart';
import 'package:sbp_app/features/onboarding/presentation/screens/promise_profile_screen.dart';
import 'package:sbp_app/features/onboarding/presentation/screens/ui_onboarding.dart';
import 'package:sbp_app/features/promise/provider/promise_list_provider.dart';
import 'package:sbp_app/features/seven_day_challenge/presentation/screens/challenge_intro_screen.dart';
import 'package:sbp_app/features/seven_day_challenge/presentation/screens/seven_day_challenge_screen.dart';
import 'package:sbp_app/features/seven_day_challenge/provider/challenge_provider.dart';
import 'package:sbp_app/features/shared/providers/ai_examples_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});
  static const String routeName = '/';

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _wipeController;
  late Animation<double> _wipeAnimation;

  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((v) {
      _checkAuthAndNavigate();
    });
    super.initState();
    _wipeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _wipeAnimation = CurvedAnimation(
      parent: _wipeController,
      curve: Curves.easeInOutCubic,
    );

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _bounceAnimation =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.15), weight: 50),
          TweenSequenceItem(tween: Tween(begin: 1.15, end: 1.0), weight: 50),
        ]).animate(
          CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
        );

    _wipeController.forward().then((_) {
      _bounceController.forward();
    });
  }

  Future<void> _checkAuthAndNavigate() async {
    final authProviderNotifier = ref.read(authenticationProvider.notifier);
    final promiseProviderNotifier = ref.read(promisesProvider.notifier);
    final challengeProvderNotifier = ref.read(challengeProvider.notifier);
    final aiExamplesProviderNotifier = ref.read(
      aiExamplesControllerProvider.notifier,
    );

    await Future.wait([
      authProviderNotifier.getUserSubscription(),
      promiseProviderNotifier.fetchPromises(),
    ]);
    await authProviderNotifier.initFuture;
    final authState = ref.read(authenticationProvider);
    if (authState.isAuthenticated) {
      await challengeProvderNotifier.loadChallenge();
    }

    if (!mounted) return;
    if (authState.isOnboardingCompleted) {
      await aiExamplesProviderNotifier.init(
        authState.onboardingData!.onboardingResult,
      );
    }
    final promisesState = ref.read(promisesProvider);
    final challengeState = ref.read(challengeProvider);
    final user = authState.authUser?.user;

    if (!authState.isAuthenticated) {
      final route = !authState.isOnboardingCompleted
          ? UIOnboardingScreen.routeName
          : UiMainSignup.routeName;
      Navigator.of(context).pushReplacementNamed(
        route,
        arguments: route == UiMainSignup.routeName
            ? {
                'onboarding': authState.onboardingData!.onboardingResult,
                'show_celebration': false,
              }
            : null,
      );
      return;
    }

    if (user?.username == null || user!.username!.isEmpty) {
      Navigator.of(context).pushReplacementNamed(
        SignUpBasicInfoScreen.routeName,
        arguments: user?.email ?? '',
      );
      return;
    }

    if (!promisesState.hasPromises) {
      Navigator.of(context).pushReplacementNamed(
        PromiseProfileScreen.routeName,
        arguments: authState.authUser!.user.onboarding,
      );
      return;
    }

    // final route = InvitePhoneNoScreen.routeName;
    log(challengeState.isUpdatedToday.toString());
    final route = authState.hasSubscription
        ? challengeState.isChallengeCompleted
              ? HomeDashboardPage.routeName
              : challengeState.isChallengeCreated
              ? challengeState.isUpdatedToday
                    ? HomeDashboardPage.routeName
                    : SevenDayChallengeScreen.routeName
              : ChallengeIntroScreen.routeName
        : HomeDashboardPage.routeName;

    Navigator.of(context).pushReplacementNamed(route);

    // if (!authState.isAuthenticated) {
    //   Navigator.of(context).pushReplacementNamed(InviteCodeScreen.routeName);
    //   return;
    // }

    // final user = authState.authUser!.user;

    // if (user.username == null || user.username!.isEmpty) {
    //   Navigator.of(context).pushReplacementNamed(
    //     SignUpBasicInfoScreen.routeName,
    //     arguments: user.email ?? '',
    //   );
    //   return;
    // }

    // if (!(user.onboarding?.completed ?? false)) {
    //   Navigator.of(context).pushReplacementNamed(UIWelcomeScreen.routeName);
    //   return;
    // }

    // if (promisesState.promises.isEmpty) {
    //   Navigator.of(context).pushReplacementNamed(
    //     UIWelcomeScreen.routeName,
    //     arguments: {
    //       'onboarding': user.onboarding,
    //       'show_make_promise_button': true,
    //     },
    //   );
    //   return;
    // }

    // Navigator.of(context).pushReplacement(
    //   MaterialPageRoute(builder: (_) => const HomeDashboardPage()),
    // );
  }

  @override
  void dispose() {
    _wipeController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ScaleTransition(
                  scale: _bounceAnimation,
                  child: SizeTransition(
                    sizeFactor: _wipeAnimation,
                    axis: Axis.horizontal,
                    axisAlignment: -1.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: SvgPicture.asset(
                        Assets.svgAppNameIcon,
                        width: 220.h,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
