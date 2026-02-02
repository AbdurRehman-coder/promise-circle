import 'package:flutter/material.dart';
import 'package:sbp_app/core/utils/app_animations.dart';
import 'package:sbp_app/features/auth/presentation/screens/forgot_password_otp_screen.dart';
import 'package:sbp_app/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:sbp_app/features/auth/presentation/screens/login_screen.dart';
import 'package:sbp_app/features/auth/presentation/screens/password_reset_success_screen.dart';
import 'package:sbp_app/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:sbp_app/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:sbp_app/features/auth/presentation/screens/ui_main_signup.dart';
import 'package:sbp_app/features/auth/presentation/screens/verificcation_code_screen.dart';
import 'package:sbp_app/features/invite/presentation/screens/early_access_screen.dart';
import 'package:sbp_app/features/invite/presentation/screens/first_login_screen.dart';
import 'package:sbp_app/features/invite/presentation/screens/invitation_code_mismatch.dart';
import 'package:sbp_app/features/invite/presentation/screens/invite_code_screen.dart';
import 'package:sbp_app/features/invite/presentation/screens/success_invitation_screen.dart';
import 'package:sbp_app/features/main_home/presentations/main_home_screen.dart';
import 'package:sbp_app/features/onboarding/model/onboarding_result.dart';
import 'package:sbp_app/features/onboarding/presentation/screens/ui_onboarding.dart';
import 'package:sbp_app/features/onboarding/presentation/screens/ui_welcome.dart';
import 'package:sbp_app/features/profile/presentations/refund_screen.dart';
import 'package:sbp_app/features/profile/presentations/send_email.dart';
import 'package:sbp_app/features/profile/presentations/support_screen.dart';
import 'package:sbp_app/features/onboarding/presentation/screens/promise_profile_screen.dart';
import 'package:sbp_app/features/promise/presentation/screens/ui_promise_flow.dart';
import 'package:sbp_app/features/auth/presentation/screens/sign_up_basic_info.dart';
import 'package:sbp_app/features/splash/presentation/screens/ui_splash.dart';

import '../../features/invite/presentation/invite_phone_no_screen.dart';
import '../../features/promise/presentation/screens/my_one_promise_screen.dart';
import '../../features/promise/presentation/screens/regular_reminders_screen.dart';
import '../../features/seven_day_challenge/presentation/screens/challenge_intro_screen.dart';
import '../../features/seven_day_challenge/presentation/screens/seven_day_challenge_screen.dart';

class AppGenerateRoute {
  AppGenerateRoute._();

  static Route<dynamic>? generateRoute(RouteSettings setting) {
    switch (setting.name) {
      case SplashScreen.routeName:
        return _navigateScreen(const SplashScreen(), setting);
      case InviteCodeScreen.routeName:
        return _navigateScreen(const InviteCodeScreen(), setting);
      case SuccessInvitationScreen.routeName:
        return _navigateScreen(const SuccessInvitationScreen(), setting);
      case PromiseProfileScreen.routeName:
        final args = setting.arguments;
        OnboardingResult? onboarding;
        bool showFirstPromiseButton = true;
        if (args is Map) {
          onboarding = args['onboarding'];
          showFirstPromiseButton = args['show_first_promise_button'];
        } else {
          onboarding = args as OnboardingResult;
        }

        return _navigateScreen(
          PromiseProfileScreen(
            onboarding: onboarding!,
            showFirstPromiseButton: showFirstPromiseButton,
          ),
          setting,
        );
      case SupportScreen.routeName:
        return _navigateScreen(const SupportScreen(), setting);
      case HomeDashboardPage.routeName:
        return _navigateScreen(const HomeDashboardPage(), setting);
      case ChallengeIntroScreen.routeName:
        return _navigateScreen(const ChallengeIntroScreen(), setting);
      case SevenDayChallengeScreen.routeName:
        return _navigateScreen(const SevenDayChallengeScreen(), setting);
      case SendEmail.routeName:
        return _navigateScreen(const SendEmail(), setting);
      case RefundScreen.routeName:
        return _navigateScreen(const RefundScreen(), setting);
      case InviteCodeMisMatch.routeName:
        return _navigateScreen(const InviteCodeMisMatch(), setting);
      case RequestEarlyAccessScreen.routeName:
        return _navigateScreen(const RequestEarlyAccessScreen(), setting);
      case UiMainSignup.routeName:
        final args = setting.arguments as Map;
        final onboarding = args['onboarding'] as OnboardingResult;
        final showCelebration = args['show_celebration'] as bool;
        return _navigateScreen(
          UiMainSignup(
            onboarding: onboarding,
            showCelebration: showCelebration,
          ),
          setting,
        );
      case SignUpScreen.routeName:
        return _navigateScreen(const SignUpScreen(), setting);
      case LoginScreen.routeName:
        return _navigateScreen(const LoginScreen(), setting);
      case VerificationCodeScreen.routeName:
        final args = setting.arguments as String?;
        return _navigateScreen(VerificationCodeScreen(email: args), setting);
      case SignUpBasicInfoScreen.routeName:
        final args = setting.arguments as String;
        return _navigateScreen(SignUpBasicInfoScreen(email: args), setting);
      case ForgotPasswordScreen.routeName:
        return _navigateScreen(const ForgotPasswordScreen(), setting);
      case ForgotPasswordOtpScreen.routeName:
        final args = setting.arguments as String;
        return _navigateScreen(ForgotPasswordOtpScreen(email: args), setting);
      case ResetPasswordScreen.routeName:
        return _navigateScreen(const ResetPasswordScreen(), setting);
      case PasswordResetSuccessScreen.routeName:
        return _navigateScreen(const PasswordResetSuccessScreen(), setting);
      case UIOnboardingScreen.routeName:
        return _navigateScreen(const UIOnboardingScreen(), setting);
      case MyOnePromiseScreen.routeName:
        final args = setting.arguments as Map<String, dynamic>?;
        final promiseResult = args?['result'];
        final isNextInvite = args?['is_next_invite'];
        return _navigateScreen(
          MyOnePromiseScreen(result: promiseResult, isNextInvite: isNextInvite),
          setting,
        );
      case RegularRemindersScreen.routeName:
        final args = setting.arguments as Map<String, dynamic>?;
        final promiseResult = args?['promise'];
        return _navigateScreen(
          RegularRemindersScreen(promiseResult: promiseResult),
          setting,
        );
      case InvitePhoneNoScreen.routeName:
        return _navigateScreen(const InvitePhoneNoScreen(), setting);
      case UIWelcomeScreen.routeName:
        final args = setting.arguments as Map<String, dynamic>?;
        return _navigateScreen(UIWelcomeScreen(data: args), setting);
      case UIPromiseFlowScreen.routeName:
        final args = setting.arguments as Map<String, dynamic>?;
        final bool? isChallengePromise = args?['is_challenge_promise'];
        final String? dayKey = args?['day_key'];
        return _navigateScreen(
          UIPromiseFlowScreen(
            isChallengePromise: isChallengePromise ?? false,
            dayKey: dayKey ?? "",
          ),
          setting,
        );
      case FirstLoginScreen.routeName:
        final args = setting.arguments as String?;
        return _navigateScreen(FirstLoginScreen(code: args ?? ""), setting);

      default:
        return _navigateScreen(
          Scaffold(
            body: Center(
              child: Text(
                "No route defined for ${setting.name}",
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          setting,
        );
    }
  }

  static PageRouteBuilder _navigateScreen(
    Widget screen,
    RouteSettings settings,
  ) {
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) => screen,
      transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
        return AppAnimations.navigationTransition(animation, child);
      },
    );
  }
}
