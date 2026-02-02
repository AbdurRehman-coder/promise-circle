import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';
import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/core/utils/responsive_config.dart';
import 'package:sbp_app/core/utils/text_styles.dart';
import 'package:sbp_app/features/shared/widgets/bottom_height_widget.dart';
import 'package:sbp_app/features/shared/widgets/w_primary_button.dart';
import 'package:sbp_app/features/auth/provider/authentication_providr.dart';
import 'package:sbp_app/features/shared/widgets/back_button.dart';
import 'package:sbp_app/features/shared/widgets/flushbar.dart';
import 'package:sbp_app/features/shared/widgets/screen_template.dart';
import 'package:sbp_app/features/auth/presentation/screens/sign_up_basic_info.dart';

class VerificationCodeScreen extends ConsumerStatefulWidget {
  static const String routeName = '/verification-code';
  static String routePath = '/verification-code';
  final String? email;

  const VerificationCodeScreen({super.key, this.email});

  @override
  ConsumerState<VerificationCodeScreen> createState() =>
      _VerificationCodeScreenState();
}

class _VerificationCodeScreenState
    extends ConsumerState<VerificationCodeScreen> {
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
      border: Border.all(color: Colors.indigo.shade500, width: 2.w),
    );

    return ScreenTemplate(
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BackButtonWidget(),
          SizedBox(height: 16.h),

          Text(
            'Verification Code',
            style: AppTextStyles.headingTextStyleBogart.copyWith(
              color: AppColors.blackColor,
              fontSize: 32.sp,
              letterSpacing: 0.9,
            ),
          ),

          SizedBox(height: 32.h),
          Text(
            'We have sent the verification code to your email address',
            style: TextStyle(fontSize: 14.sp, color: Colors.black54),
          ),
          SizedBox(height: 16.h),

          Center(
            child: Pinput(
              length: 5,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: focusedPinTheme,
              inputFormatters: [],
              showCursor: true,
              onChanged: (val) {
                setState(() {
                  code = val;
                });
              },
              onCompleted: (val) {
                setState(() {
                  code = val;
                });
              },
            ),
          ),
          SizedBox(height: 20.h),

          const Spacer(),

          Consumer(
            builder: (context, ref, _) {
              final provider = ref.watch(authenticationProvider);

              return PrimaryButton(
                text: "Confirm",
                enabled: code.length == 5,
                isLoading: provider.isLoading,
                onPressed: () {
                  verifyEmail(ref, code, context);
                },
              );
            },
          ),

          BottomHeightWidget(),
        ],
      ),
    );
  }

  void verifyEmail(WidgetRef ref, String code, BuildContext context) async {
    await ref
        .read(authenticationProvider.notifier)
        .verifyEmail(code, email: widget.email);
    final state = ref.read(authenticationProvider);

    if (!context.mounted) return;

    if (state.error != null) {
      if (state.error == "Forbidden") {
        FlashMessage.showError(context, "Invalid code");
      } else {
        FlashMessage.showError(context, state.error!);
      }
      return;
    }

    if (state.authUser?.user.emailVerified ?? false) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        SignUpBasicInfoScreen.routeName,
        (route) => false,
        arguments: state.authUser?.user.email ?? '',
      );
    }
  }
}
