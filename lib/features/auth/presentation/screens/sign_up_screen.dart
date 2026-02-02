import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/core/utils/responsive_config.dart';
import 'package:sbp_app/core/utils/text_styles.dart';
import 'package:sbp_app/core/utils/validators.dart';
import 'package:sbp_app/features/shared/widgets/bottom_height_widget.dart';
import 'package:sbp_app/features/shared/widgets/w_primary_button.dart';
import 'package:sbp_app/features/auth/models/sign_up_request_model.dart';
import 'package:sbp_app/features/auth/presentation/widgets/privacy_policy.dart';
import 'package:sbp_app/features/auth/provider/authentication_providr.dart';
import 'package:sbp_app/features/shared/widgets/back_button.dart';
import 'package:sbp_app/features/shared/widgets/flushbar.dart';
import 'package:sbp_app/features/shared/widgets/input_textfield_label.dart';
import 'package:sbp_app/features/shared/widgets/screen_template.dart';
import 'package:sbp_app/core/constants/assets.dart';
import 'package:sbp_app/features/auth/presentation/screens/verificcation_code_screen.dart';

import '../../../../core/utils/app_exports.dart'
    show SystemChrome, SystemUiOverlayStyle;

class SignUpScreen extends StatefulWidget {
  static const String routeName = '/sign-up';
  static String routePath = '/sign-up';

  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final ValueNotifier<bool> _passwordVisible = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _confirmPasswordVisible = ValueNotifier<bool>(true);

  ValueNotifier<bool> isPasswordValid = ValueNotifier<bool>(false);
  ValueNotifier<bool> isEmailValid = ValueNotifier<bool>(false);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  initState() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,

        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _passwordVisible.dispose();
    _confirmPasswordVisible.dispose();
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
              'Create an account',
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
                  keyboardType: TextInputType.emailAddress,
                  isObscure: value,
                  onChange: (value) {
                    validatePassword(value);
                  },
                  validator: Validators.validatePassword,
                );
              },
            ),
            SizedBox(height: 7.h),
            Text(
              "Use 8 or more characters with a mix of letters, numbers & symbols",
              style: AppTextStyles.bodyTextStyle.copyWith(
                color: AppColors.greysColor,
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.4,
              ),
            ),
            SizedBox(height: 16.h),
            ValueListenableBuilder(
              valueListenable: _confirmPasswordVisible,
              builder: (context, value, child) {
                return BuildInputFieldLabel(
                  onChange: (value) {
                    validatePassword(value);
                  },
                  label: 'Confirm Password',
                  hintText: '••••••••••••••',
                  controller: _confirmPasswordController,
                  keyboardType: TextInputType.phone,
                  isObscure: value,
                  sufixIcon: GestureDetector(
                    onTap: () => _confirmPasswordVisible.value =
                        !_confirmPasswordVisible.value,
                    child: Icon(
                      value
                          ? Icons.visibility_off_outlined
                          : Icons.remove_red_eye_outlined,
                    ),
                  ),
                  validator: (value) => Validators.confirmPassword(
                    value,
                    _passwordController.text,
                  ),
                );
              },
            ),
            SizedBox(height: 16.h),
            const Spacer(),
            ValueListenableBuilder(
              valueListenable: isEmailValid,
              builder: (context, emailValid, child) {
                return ValueListenableBuilder(
                  valueListenable: isPasswordValid,
                  builder: (context, value, child) {
                    return Consumer(
                      builder: (context, ref, child) {
                        final provider = ref.watch(authenticationProvider);
                        return PrimaryButton(
                          text: 'Verify Email',
                          isLoading: provider.isLoading,
                          enabled: value && emailValid,
                          onPressed: () => signUp(ref, context),
                          icon: SvgPicture.asset(
                            Assets.svgArrowForward,
                            height: 20.h,
                            width: 24.w,
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
            SizedBox(height: 16.h),
            const PrivacyPolicy(),
            BottomHeightWidget(),
          ],
        ),
      ),
    );
  }

  void validatePassword(value) {
    (_passwordController.text.isNotEmpty &&
                _passwordController.text == _confirmPasswordController.text) &&
            _passwordController.text.length >= 8 &&
            containNumberAndSymbol(_passwordController.text)
        ? isPasswordValid.value = true
        : isPasswordValid.value = false;
  }

  bool containNumberAndSymbol(String password) {
    final regex = RegExp(r'^(?=.*[0-9])(?=.*[!@#\$%^&*(),.?":{}|<>]).+$');
    return regex.hasMatch(password);
  }

  bool isValidEmail(String email) {
    return EmailValidator.validate(email.trim());
  }

  void signUp(WidgetRef ref, BuildContext context) async {
    final inviteCode = ref.read(authenticationProvider).inviteCode;
    await ref
        .read(authenticationProvider.notifier)
        .signUp(
          SignUpRequestModel(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            role: 'user',
            inviteCode: inviteCode,
          ),
          ref,
        );

    if (!context.mounted) return;

    final state = ref.read(authenticationProvider);

    if (state.error != null) {
      FlashMessage.showError(context, state.error!);
      return;
    }

    if (state.authUser != null) {
      Navigator.pushNamed(context, VerificationCodeScreen.routeName);
    }
  }
}
