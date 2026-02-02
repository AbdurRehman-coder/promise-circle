import 'package:country_phone_validator/country_phone_validator.dart';
import 'package:dio/dio.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sbp_app/core/services/app_services.dart';
import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/core/utils/responsive_config.dart';
import 'package:sbp_app/core/utils/text_styles.dart';
import 'package:sbp_app/features/shared/widgets/w_primary_button.dart';
import 'package:sbp_app/features/auth/models/phone_model.dart';
import 'package:sbp_app/features/auth/presentation/widgets/internal_phone_widget.dart';
import 'package:sbp_app/features/invite/presentation/screens/success_invitation_screen.dart';
import 'package:sbp_app/features/invite/provider/invite_provider.dart';
import 'package:sbp_app/features/invite/services/invite_service.dart';
import 'package:sbp_app/features/shared/widgets/back_button.dart';
import 'package:sbp_app/features/shared/widgets/flushbar.dart';
import 'package:sbp_app/features/shared/widgets/input_textfield_label.dart';
import 'package:sbp_app/features/shared/widgets/screen_template.dart';

class RequestEarlyAccessScreen extends StatefulWidget {
  static const String routeName = '/request-early-access';
  static String routePath = '/request-early-access';
  const RequestEarlyAccessScreen({super.key});

  @override
  State<RequestEarlyAccessScreen> createState() =>
      _RequestEarlyAccessScreenState();
}

class _RequestEarlyAccessScreenState extends State<RequestEarlyAccessScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  String? _phoneError;
  ValueNotifier<bool> isFormValid = ValueNotifier(false);
  PhoneNumber? _phoneNumber;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
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
              'Request Invite Code',
              style: AppTextStyles.headingTextStyleBogart.copyWith(
                color: AppColors.blackColor,
                fontSize: 30.sp,
                letterSpacing: 0.9,
              ),
            ),
            SizedBox(height: 12.h),
            Padding(
              padding: EdgeInsets.only(right: 50.w),
              child: Text(
                'Right now, we are rolling out the Promises app to a limited group. Join the waitlist to join this group.',
                style: AppTextStyles.bodyTextStyle.copyWith(
                  color: AppColors.primaryBlackColor.withAlpha(120),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  height: 1.5,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            BuildInputFieldLabel(
              label: 'Full Name',
              hintText: 'Enter your full name',
              controller: _nameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Name is required';
                }
                if (value.length < 3) {
                  return 'Name is too short';
                }
                return null;
              },
              onChange: (_) => _checkGlobalValidity(),
            ),
            SizedBox(height: 16.h),
            BuildInputFieldLabel(
              label: 'Email',
              hintText: 'example@host.com',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                if (value == null || value.isEmpty) {
                  return 'Email is required';
                }
                if (!emailRegex.hasMatch(value)) {
                  return 'Enter a valid email address';
                }
                return null;
              },
              onChange: (_) => _checkGlobalValidity(),
            ),
            SizedBox(height: 16.h),
            Text(
              'Mobile Number',
              style: AppTextStyles.bodyTextStyle.copyWith(fontSize: 14.sp),
            ),
            SizedBox(height: 8.h),
            InternationalPhoneInputWidget(
              controller: _mobileController,
              errorText: _phoneError,
              onChanged: (phone) {
                _phoneNumber = phone;
                _validatePhone();
                _checkGlobalValidity();
              },
            ),
            SizedBox(height: 16.h),
            const Spacer(),
            Consumer(
              builder: (context, ref, child) {
                final loading = ref.watch(inviteLoadingProvider);
                return ValueListenableBuilder(
                  valueListenable: isFormValid,
                  builder: (context, isValid, child) => PrimaryButton(
                    text: 'Get Invite Code',
                    enabled: isValid,
                    isLoading: loading,
                    onPressed: () {
                      if (isValid) {
                        requestEarlyAccess(ref);
                      }
                    },
                  ),
                );
              },
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  void _validatePhone() {
    setState(() {
      if (_mobileController.text.isEmpty || _phoneNumber == null) {
        _phoneError = "Phone number is required";
        return;
      }

      bool isValid = CountryUtils.validatePhoneNumber(
        _mobileController.text,
        _phoneNumber!.dialCode!,
      );

      if (!isValid) {
        _phoneError = "Invalid number for ${_phoneNumber!.isoCode}";
      } else {
        _phoneError = null;
      }
    });
  }

  void _checkGlobalValidity() {
    bool nameValid = _nameController.text.length >= 3;
    bool emailValid = EmailValidator.validate(_emailController.text.trim());

    bool phoneValid = false;
    if (_phoneNumber != null && _mobileController.text.isNotEmpty) {
      phoneValid = CountryUtils.validatePhoneNumber(
        _mobileController.text,
        _phoneNumber!.dialCode!,
      );
    }

    if (nameValid && emailValid && phoneValid) {
      isFormValid.value = true;
    } else {
      isFormValid.value = false;
    }
  }

  void requestEarlyAccess(WidgetRef ref) async {
    if (!_formKey.currentState!.validate() || !isFormValid.value) return;

    final loadingNotifier = ref.read(inviteLoadingProvider.notifier);
    loadingNotifier.setLoading(true);

    try {
      final services = locator.get<InviteService>();
      final result = await services.requestEarlyAccess(
        mobileNumber: _phoneNumber == null ? "" : _phoneNumber!.completeNumber.trim(),
        email: _emailController.text.trim(),
        name: _nameController.text.trim(),
      );

      if (result) {
        if (!mounted) return;
        // Pushes forward and removes the form from history
        Navigator.pushReplacementNamed(
          context,
          SuccessInvitationScreen.routeName,
        );
      } else {
        FlashMessage.showError(
          context,
          "Something went wrong. Please try again.",
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final status = e.response?.statusCode;
        if (status == 409) {
          FlashMessage.showError(context, "Email already on the waitlist");
        }
      }
    } catch (e) {
      FlashMessage.showError(context, "Something went wrong on early access");
    } finally {
      loadingNotifier.setLoading(false);
    }
  }
}
