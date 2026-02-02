import 'package:flutter/material.dart';
import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/core/utils/text_styles.dart';
import 'package:sbp_app/features/shared/widgets/w_primary_button.dart';
import 'package:sbp_app/features/shared/widgets/screen_template.dart';
import 'package:sbp_app/features/auth/presentation/screens/login_screen.dart';

class PasswordResetSuccessScreen extends StatelessWidget {
  static const String routeName = '/forgot-password/success';
  static String routePath = '/forgot-password/success';

  const PasswordResetSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 130),
          Image.asset(
            'assets/png/forget_password_success_img.png',
            width: 100,
            height: 110,
          ),
          const SizedBox(height: 40),
          Text(
            'Password changed',
            style: AppTextStyles.headingTextStyleBogart.copyWith(
              color: AppColors.blackColor,
              fontSize: 32,
              letterSpacing: 0.9,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Your password has been updated successfully',
              style: AppTextStyles.bodyTextStyle.copyWith(
                fontSize: 14,
                color: AppColors.greyColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(),
          PrimaryButton(
            text: 'Login',
            onPressed: () {
              Navigator.popUntil(
                context,
                ModalRoute.withName(LoginScreen.routeName),
              );
            },
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
