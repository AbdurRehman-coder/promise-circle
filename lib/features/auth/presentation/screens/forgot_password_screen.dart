import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/core/utils/text_styles.dart';
import 'package:sbp_app/core/utils/validators.dart';
import 'package:sbp_app/features/shared/widgets/w_primary_button.dart';
import 'package:sbp_app/features/auth/presentation/screens/forgot_password_otp_screen.dart';
import 'package:sbp_app/features/auth/provider/authentication_providr.dart';
import 'package:sbp_app/features/shared/widgets/back_button.dart';
import 'package:sbp_app/features/shared/widgets/flushbar.dart';
import 'package:sbp_app/features/shared/widgets/input_textfield_label.dart';
import 'package:sbp_app/features/shared/widgets/screen_template.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const String routeName = '/forgot-password';
  static String routePath = '/forgot-password';

  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // _emailController.addListener(() {
    //   setState(() {});
    // });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      widget: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BackButtonWidget(),
            const SizedBox(height: 16),
            Text(
              'Forgot password',
              style: AppTextStyles.headingTextStyleBogart.copyWith(
                color: AppColors.blackColor,
                fontSize: 32,
                letterSpacing: 0.9,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Enter the email associated with your account. We\'ll send you the reset instructions.',
              style: AppTextStyles.bodyTextStyle.copyWith(
                fontSize: 14,
                color: AppColors.greyColor,
              ),
            ),
            const SizedBox(height: 24),
            BuildInputFieldLabel(
              label: 'Email',
              hintText: 'example@host.com',
              controller: _emailController,
              validator: Validators.validateEmail,
              onChange: (value) => setState(() {}),
            ),
            const SizedBox(height: 20),
            const Spacer(),
            Consumer(
              builder: (context, ref, child) {
                final provider = ref.watch(authenticationProvider);
                return PrimaryButton(
                  enabled: _emailController.text.trim().isNotEmpty,
                  text: 'Reset Password',
                  isLoading: provider.isLoading,
                  onPressed: () {
                    sendResetEmail(ref, context);
                  },
                );
              },
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  void sendResetEmail(WidgetRef ref, BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    await ref
        .read(authenticationProvider.notifier)
        .forgotPassword(_emailController.text.trim());

    if (!context.mounted) return;

    final state = ref.read(authenticationProvider);
    if (state.error != null) {
      FlashMessage.showError(context, state.error!);
      return;
    }

    FlashMessage.showSuccess(context, 'Password reset email sent successfully');

    Navigator.pushNamed(
      context,
      ForgotPasswordOtpScreen.routeName,
      arguments: _emailController.text.trim(),
    );
  }
}
