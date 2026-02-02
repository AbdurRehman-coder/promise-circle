import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/core/utils/responsive_config.dart';
import 'package:sbp_app/core/utils/text_styles.dart';
import 'package:sbp_app/core/utils/validators.dart';
import 'package:sbp_app/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:sbp_app/features/shared/widgets/bottom_height_widget.dart';
import 'package:sbp_app/features/shared/widgets/w_primary_button.dart';
import 'package:sbp_app/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:sbp_app/features/auth/presentation/screens/verificcation_code_screen.dart';
import 'package:sbp_app/features/auth/provider/authentication_providr.dart';
import 'package:sbp_app/features/shared/widgets/back_button.dart';
import 'package:sbp_app/features/shared/widgets/flushbar.dart';
import 'package:sbp_app/features/shared/widgets/input_textfield_label.dart';
import 'package:sbp_app/features/shared/widgets/screen_template.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';
  static String routePath = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ValueNotifier<bool> _passwordVisible = ValueNotifier<bool>(true);

  ValueNotifier<bool> isPasswordValid = ValueNotifier<bool>(false);
  ValueNotifier<bool> isEmailValid = ValueNotifier<bool>(false);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordVisible.dispose();
    isPasswordValid.dispose();
    isEmailValid.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      widget: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const BackButtonWidget(),
            SizedBox(height: 16.h),
            Text(
              'Welcome back!',
              style: AppTextStyles.headingTextStyleBogart.copyWith(
                color: AppColors.blackColor,
                fontSize: 32.sp,
                letterSpacing: 0.9,
              ),
            ),
            SizedBox(height: 20.h),

            BuildInputFieldLabel(
              label: 'Email',
              hintText: 'example@host.com',
              controller: _emailController,
              onChange: (value) {
                isEmailValid.value = isValidEmail(value);
              },
              validator: Validators.validateEmail,
            ),
            SizedBox(height: 16.h),
            ValueListenableBuilder(
              valueListenable: _passwordVisible,
              builder: (context, value, child) {
                return BuildInputFieldLabel(
                  label: 'Password',
                  hintText: '••••••••••••••',
                  controller: _passwordController,
                  // keyboardType: TextInputType.visiblePassword,
                  isObscure: value,
                  onChange: (value) {
                    isPasswordValid.value = value.isNotEmpty;
                  },
                  sufixIcon: GestureDetector(
                    onTap: () =>
                        _passwordVisible.value = !_passwordVisible.value,
                    child: Icon(
                      value
                          ? Icons.visibility_off_outlined
                          : Icons.remove_red_eye_outlined,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 16.h),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, ForgotPasswordScreen.routeName);
              },
              child: Text(
                'Forgot your password?',
                style: AppTextStyles.mediumBodyTextStyle.copyWith(
                  fontSize: 14.sp,
                  color: AppColors.primaryBlackColor,
                ),
              ),
            ),
            SizedBox(height: 20.h),

            const Spacer(),

            ValueListenableBuilder(
              valueListenable: isEmailValid,
              builder: (context, emailValid, child) {
                return ValueListenableBuilder(
                  valueListenable: isPasswordValid,
                  builder: (context, passwordValid, child) {
                    return Consumer(
                      builder: (context, ref, child) {
                        final provider = ref.watch(authenticationProvider);
                        return PrimaryButton(
                          text: 'Login',
                          isLoading: provider.isLoading,
                          enabled: emailValid && passwordValid,
                          onPressed: () {
                            login(ref, context);
                          },
                          // icon: SvgPicture.asset(
                          //   Assets.svgArrowForward,
                          //   height: 20.h,
                          //   width: 24.w,
                          // ),
                        );
                      },
                    );
                  },
                );
              },
            ),

            SizedBox(height: 20.h),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don’t have an account?',
                    style: AppTextStyles.bodyTextStyle.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.greyColor,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  InkWell(
                    onTap: () {
                      // Navigate back to Signup screen
                      Navigator.pushReplacementNamed(
                        context,
                        SignUpScreen.routeName,
                      );
                    },
                    child: Text(
                      'Sign up',
                      style: AppTextStyles.bodyTextStyle.copyWith(
                        color: AppColors.secondaryBlueColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            BottomHeightWidget(),
          ],
        ),
      ),
    );
  }

  bool isValidEmail(String email) {
    return EmailValidator.validate(email.trim());
  }

  void login(WidgetRef ref, BuildContext  context) async {
    try {
      await ref
          .read(authenticationProvider.notifier)
          .login(
            _emailController.text.trim(),
            _passwordController.text.trim(),
            ref,
            context,
          );

      if (!context.mounted) return;

      final state = ref.read(authenticationProvider);

      if (state.error != null) {
        if ((state.error ?? "").toLowerCase().contains("email not verified")) {
          Navigator.pushNamed(
            context,
            VerificationCodeScreen.routeName,
            arguments: _emailController.text.trim(),
          );
        } else {
          FlashMessage.showError(context, state.error!);
        }

        return;
      }
    } catch (e) {
      if (!context.mounted) return;
      Navigator.pushNamed(context, VerificationCodeScreen.routeName);
    }
  }
}
