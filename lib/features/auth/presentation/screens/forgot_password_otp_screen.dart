import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';
import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/core/utils/responsive_config.dart';
import 'package:sbp_app/core/utils/text_styles.dart';
import 'package:sbp_app/features/shared/widgets/w_primary_button.dart';
import 'package:sbp_app/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:sbp_app/features/auth/provider/authentication_providr.dart';
import 'package:sbp_app/features/shared/widgets/back_button.dart';
import 'package:sbp_app/features/shared/widgets/flushbar.dart';
import 'package:sbp_app/features/shared/widgets/screen_template.dart';

class ForgotPasswordOtpScreen extends ConsumerStatefulWidget {
  static const String routeName = '/forgot-password/verify-otp';
  static String routePath = '/forgot-password/verify-otp';
  const ForgotPasswordOtpScreen({super.key, required this.email});
  final String email;

  @override
  ConsumerState<ForgotPasswordOtpScreen> createState() =>
      _ForgotPasswordOtpScreenState();
}

class _ForgotPasswordOtpScreenState
    extends ConsumerState<ForgotPasswordOtpScreen> {
  String code = "";

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 76.w,
      height: 80.h,
      textStyle: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: Colors.grey.shade300, width: 2.w),
      ),
    );
    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Colors.indigo.shade500, width: 2),
    );

    return ScreenTemplate(
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BackButtonWidget(),
          const SizedBox(height: 24),
          Text(
            'Verification Code',
            style: AppTextStyles.headingTextStyleBogart.copyWith(
              color: AppColors.blackColor,
              fontSize: 32,
              letterSpacing: 0.9,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'We\'ve sent a verification code to your email address',
            style: AppTextStyles.bodyTextStyle.copyWith(
              fontSize: 14,
              color: AppColors.greyColor,
            ),
          ),
          const SizedBox(height: 32),
          Pinput(
            length: 5,

            defaultPinTheme: defaultPinTheme,
            focusedPinTheme: focusedPinTheme,
            inputFormatters: [],
            showCursor: true,
            onChanged: (val) => code = val,
            onCompleted: (val) => code = val,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          const SizedBox(height: 20),
          // TextButton(
          //   onPressed: () => resendCode(ref, context),
          //   child: Text(
          //     'Resend code',
          //     style: AppTextStyles.bodyTextStyle.copyWith(
          //       color: AppColors.secondaryBlueColor,
          //       fontSize: 14,
          //       fontWeight: FontWeight.w500,
          //     ),
          //   ),
          // ),
          const Spacer(),
          Consumer(
            builder: (context, ref, _) {
              final provider = ref.watch(authenticationProvider);

              return PrimaryButton(
                text: "Continue",
                isLoading: provider.isLoading,
                onPressed: () {
                  verifyCode(ref, code, context);
                },
              );
            },
          ),
          SizedBox(height: 16),
          PrimaryButton(
            text: "Resend code",
            textColor: AppColors.primaryBlackColor,
            isOutlined: true,
            onPressed: () {
              resendCode(ref, context);
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void verifyCode(WidgetRef ref, String code, BuildContext context) async {
    if (code.length != 5) {
      FlashMessage.showError(context, 'Please enter a valid 5-digit code');
      return;
    }

    await ref.read(authenticationProvider.notifier).verifyResetCode(code);
    final state = ref.read(authenticationProvider);

    if (!context.mounted) return;

    if (state.error != null) {
      FlashMessage.showError(context, state.error!);
      return;
    }
    Navigator.pop(context);

    Navigator.pushNamed(context, ResetPasswordScreen.routeName);
  }

  void resendCode(WidgetRef ref, BuildContext context) async {
    await ref
        .read(authenticationProvider.notifier)
        .forgotPassword(widget.email);
    final state = ref.read(authenticationProvider);

    if (!context.mounted) return;

    if (state.error != null) {
      FlashMessage.showError(context, state.error!);
      return;
    }

    FlashMessage.showSuccess(context, 'Verification code resent successfully');
  }
}
