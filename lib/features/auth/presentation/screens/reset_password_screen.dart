import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/core/utils/text_styles.dart';
import 'package:sbp_app/core/utils/validators.dart';
import 'package:sbp_app/features/shared/widgets/w_primary_button.dart';
import 'package:sbp_app/features/auth/presentation/screens/password_reset_success_screen.dart';
import 'package:sbp_app/features/auth/provider/authentication_providr.dart';
import 'package:sbp_app/features/shared/widgets/back_button.dart';
import 'package:sbp_app/features/shared/widgets/flushbar.dart';
import 'package:sbp_app/features/shared/widgets/input_textfield_label.dart';
import 'package:sbp_app/features/shared/widgets/screen_template.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const String routeName = '/forgot-password/reset';
  static String routePath = '/forgot-password/reset';

  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final ValueNotifier<bool> _newPasswordVisible = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _confirmPasswordVisible = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _isPasswordValid = ValueNotifier<bool>(false);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _newPasswordVisible.dispose();
    _confirmPasswordVisible.dispose();
    _isPasswordValid.dispose();
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
              'Change password',
              style: AppTextStyles.headingTextStyleBogart.copyWith(
                color: AppColors.blackColor,
                fontSize: 32,
                letterSpacing: 0.9,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Enter your new password',
              style: AppTextStyles.bodyTextStyle.copyWith(
                fontSize: 14,
                color: AppColors.greyColor,
              ),
            ),
            const SizedBox(height: 24),
            ValueListenableBuilder(
              valueListenable: _newPasswordVisible,
              builder: (context, value, child) {
                return BuildInputFieldLabel(
                  label: 'New password',
                  hintText: '••••••••••••••',
                  controller: _newPasswordController,
                  isObscure: value,
                  onChange: (val) => validatePasswords(),
                  validator: Validators.validatePassword,
                );
              },
            ),
            const SizedBox(height: 7),
            Text(
              "Use 8 or more characters with a mix of letters, numbers & symbols",
              style: AppTextStyles.bodyTextStyle.copyWith(
                color: AppColors.greysColor,
                fontSize: 11,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 16),
            ValueListenableBuilder(
              valueListenable: _confirmPasswordVisible,
              builder: (context, value, child) {
                return BuildInputFieldLabel(
                  label: 'Confirm new password',
                  hintText: '••••••••••••••',
                  controller: _confirmPasswordController,
                  isObscure: value,
                  onChange: (val) => validatePasswords(),
                  validator: (value) => Validators.confirmPassword(
                    value,
                    _newPasswordController.text,
                  ),
                );
              },
            ),
            SizedBox(height: 20,),
            const Spacer(),
            Consumer(
              builder: (context, ref, child) {
                final provider = ref.watch(authenticationProvider);
                return ValueListenableBuilder(
                  valueListenable: _isPasswordValid,
                  builder: (context, isValid, child) {
                    return PrimaryButton(
                      text: 'Confirm',
                      isLoading: provider.isLoading,
                      enabled: isValid,
                      onPressed: () => resetPassword(ref, context),
                    );
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

  void validatePasswords() {
    if (_newPasswordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _newPasswordController.text == _confirmPasswordController.text &&
        _newPasswordController.text.length >= 8 &&
        containsNumberAndSymbol(_newPasswordController.text)) {
      _isPasswordValid.value = true;
    } else {
      _isPasswordValid.value = false;
    }
  }

  bool containsNumberAndSymbol(String password) {
    final regex = RegExp(r'^(?=.*[0-9])(?=.*[!@#\$%^&*(),.?":{}|<>]).+$');
    return regex.hasMatch(password);
  }

  void resetPassword(WidgetRef ref, BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(authenticationProvider.notifier).resetPassword(
          _newPasswordController.text,
          _confirmPasswordController.text,
        );

    if (!context.mounted) return;

    final state = ref.read(authenticationProvider);
    if (state.error != null) {
      FlashMessage.showError(context, state.error!);
      return;
    }

    Navigator.pushNamed(context, PasswordResetSuccessScreen.routeName);
  }
}

