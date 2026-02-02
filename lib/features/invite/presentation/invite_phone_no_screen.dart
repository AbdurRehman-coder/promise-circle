import 'package:country_phone_validator/country_phone_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/core/utils/helper_functions.dart';
import 'package:sbp_app/core/utils/text_styles.dart';
import 'package:sbp_app/features/auth/models/user_model.dart';
import 'package:sbp_app/features/auth/presentation/widgets/internal_phone_widget.dart';
import 'package:sbp_app/features/auth/services/auth_services.dart';
import 'package:sbp_app/features/shared/widgets/w_primary_button.dart';
import 'package:sbp_app/features/auth/provider/authentication_providr.dart';
import 'package:sbp_app/features/shared/widgets/back_button.dart';
import 'package:sbp_app/features/shared/widgets/screen_template.dart';

import '../../../core/services/app_services.dart';
import '../../../core/utils/responsive_config.dart';
import '../../auth/models/phone_model.dart';
import '../services/invite_service.dart';

class InvitePhoneNoScreen extends StatefulWidget {
  static const String routeName = '/invite-phone';

  const InvitePhoneNoScreen({super.key});

  @override
  State<InvitePhoneNoScreen> createState() => _InvitePhoneNoScreenState();
}

class _InvitePhoneNoScreenState extends State<InvitePhoneNoScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  String? _phoneError;
  ValueNotifier<bool> isFormValid = ValueNotifier(false);
  PhoneNumber? _phoneNumber;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _phoneController.dispose();
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
            SizedBox(height: 16.h),
            Text(
              'Phone number',
              style: AppTextStyles.headingTextStyleBogart.copyWith(
                color: AppColors.blackColor,
                fontSize: 32.sp,
                letterSpacing: 0.9,
              ),
            ),
            SizedBox(height: 32.h),
            Text(
              'Enter your phone number to get invite code.',
              style: AppTextStyles.bodyTextStyle.copyWith(
                fontSize: 14.sp,
                color: AppColors.greyColor,
              ),
            ),
            SizedBox(height: 16.h),
            InternationalPhoneInputWidget(
              controller: _phoneController,
              errorText: _phoneError,
              onChanged: (phone) {
                _phoneNumber = phone;
                _validatePhone();
              },
            ),
            SizedBox(height: 20.h),
            const Spacer(),
            Consumer(
              builder: (context, ref, child) {
                final isButtonLoading = _isLoading;

                return PrimaryButton(
                  enabled:
                      _phoneController.text.trim().isNotEmpty &&
                      !isButtonLoading,
                  text: 'Confirm',
                  isLoading: isButtonLoading,
                  useOverlayLoader: true,
                  onPressed: () {
                    _confirm(ref, context);
                  },
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
      if (_phoneController.text.isEmpty || _phoneNumber == null) {
        _phoneError = "Phone number is required";
        return;
      }

      bool isValid = CountryUtils.validatePhoneNumber(
        _phoneController.text,
        _phoneNumber!.dialCode!,
      );

      if (!isValid) {
        _phoneError = "Invalid number for ${_phoneNumber!.isoCode}";
      } else {
        _phoneError = null;
      }
    });
  }

  Future<void> _confirm(WidgetRef ref, BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    if (_phoneError != null) return;

    setState(() {
      _isLoading = true;
    });
    final authstate = ref.read(authenticationProvider);

    try {
      final user = authstate.authUser?.user;

      locator.get<AuthServices>().requestBasicInfo(
        User(phone: _phoneNumber?.completeNumber ?? ""),
      );

      locator.get<InviteService>().requestEarlyAccess(
        name: user?.name ?? "",
        email: user?.email ?? "",
        mobileNumber: _phoneNumber?.completeNumber ?? "",
      );
    } catch (e) {
      // FlashMessage.showError(context, e.toString());
    } finally {
      if (mounted) {
        HelperFunctions.launchMyUrl(
          authstate.appSetting?.data.subscriptionUrl ??
              "https://stopbreakingpromises.com",
        ).then((val) {
          Navigator.pop(context);
        });
      }
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
