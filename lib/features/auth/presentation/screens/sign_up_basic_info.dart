import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/core/utils/app_extensions.dart';
import 'package:sbp_app/core/utils/responsive_config.dart';
import 'package:sbp_app/core/utils/text_styles.dart';
import 'package:sbp_app/core/utils/validators.dart';
import 'package:sbp_app/features/auth/models/user_model.dart';
import 'package:sbp_app/features/auth/presentation/widgets/gender_state.dart';
import 'package:sbp_app/features/auth/provider/authentication_providr.dart';
import 'package:sbp_app/features/onboarding/presentation/screens/promise_profile_screen.dart';
import 'package:sbp_app/features/shared/widgets/bottom_height_widget.dart';
import 'package:sbp_app/features/shared/widgets/flushbar.dart';
import 'package:sbp_app/features/shared/widgets/input_textfield_label.dart';
import 'package:sbp_app/features/shared/widgets/screen_template.dart';
import 'package:sbp_app/features/shared/widgets/w_custom_calendar_bottom_sheet.dart';
import 'package:sbp_app/features/shared/widgets/w_primary_button.dart';
import 'package:sbp_app/core/constants/assets.dart';

class SignUpBasicInfoScreen extends ConsumerStatefulWidget {
  const SignUpBasicInfoScreen({
    super.key,
    this.email = '',
    this.password = '',
    this.inviteCode = '',
  });

  final String email;
  final String password;
  final String inviteCode;
  static const String routeName = '/sign-up-basic-info';

  @override
  ConsumerState<SignUpBasicInfoScreen> createState() =>
      _SignUpBasicInfoScreenState();
}

class _SignUpBasicInfoScreenState extends ConsumerState<SignUpBasicInfoScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final ValueNotifier<bool?> isValidField = ValueNotifier<bool?>(false);
  final _formKey = GlobalKey<FormState>();
  String gender = '';

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.email;
  }

  @override
  void dispose() {
    _nameController.dispose();
    dobController.dispose();
    _usernameController.dispose();
    isValidField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authenticationProvider);

    return ScreenTemplate(
      widget: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            Text(
              'Give us the basics',
              style: AppTextStyles.headingTextStyleBogart.copyWith(
                color: AppColors.blackColor,
                fontSize: 32.sp,
                letterSpacing: 0.9,
              ),
            ),
            SizedBox(height: 16.h),
            BuildInputFieldLabel(
              label: 'Full Name',
              hintText: 'Enter your full name',
              controller: _nameController,
              onChange: (value) => validateFields(),
              validator: (value) =>
                  Validators.validateFieldEmpty(value, name: 'Full Name'),
            ),
            if (Platform.isAndroid || authState.checkPaywall) ...[
              SizedBox(height: 22.h),
              BuildInputFieldLabel(
                readOnly: true,
                isOptional: true,
                label: 'Date of birth',
                hintText: 'MM/DD/YYYY',
                controller: dobController,
                onTap: selectDate,
                sufixIcon: GestureDetector(
                  onTap: selectDate,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 13.w,
                      vertical: 13.h,
                    ),
                    child: SvgPicture.asset(Assets.svgCalendarIcon),
                  ),
                ),
                onChange: (value) => validateFields(),
              ),
              SizedBox(height: 22.h),
              GenderSelector(
                onGenderSelected: (e) {
                  gender = e;
                  validateFields();
                },
              ),
            ],
            SizedBox(height: 22.h),
            BuildInputFieldLabel(
              label: 'Username',
              hintText: 'Enter your userName',
              readOnly: true,
              controller: _usernameController,
              onChange: (value) => validateFields(),
            ),
            SizedBox(height: 8.h),
            Text(
              "In case you decide to share your promises with friends.",
              style: AppTextStyles.bodyTextStyle.copyWith(
                color: AppColors.greysColor,
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.4,
              ),
            ),
            const Spacer(),
            ValueListenableBuilder<bool?>(
              valueListenable: isValidField,
              builder: (context, isValid, child) {
                return PrimaryButton(
                  text: 'Unlock Your Promise Profile',
                  isLoading: authState.isLoading,
                  enabled: isValid ?? false,
                  onPressed: () => requestBasicInfo(),
                );
              },
            ),
            const BottomHeightWidget(),
          ],
        ),
      ),
    );
  }

  Future<void> selectDate() async {
    FocusManager.instance.primaryFocus?.unfocus();
    await Future.delayed(const Duration(milliseconds: 200));

    final now = DateTime.now();
    final sixteenYearsAgo = DateTime(now.year - 13, now.month, now.day);

    if (!mounted) return;

    final DateTime? picked = await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CustomCalendarBottomSheet(
        initialDate: DateTime(2005, 1, 1),
        minDate: DateTime(1960, 1, 1),
        maxDate: sixteenYearsAgo,
        title: "Date of birth",
      ),
    );

    if (picked != null) {
      dobController.text = picked.formatDate();
      validateFields();
    }
  }

  Future<void> requestBasicInfo() async {
    await ref
        .read(authenticationProvider.notifier)
        .updateBasicInfo(
          User(
            name: _nameController.text.toTitleCase,
            dateOfBirth: dobController.text.isEmpty
                ? null
                : dobController.text.toIsoDate(),
            gender: gender.isEmpty ? null : gender.toLowerCase(),
            username: _usernameController.text,
          ),
        );

    final state = ref.read(authenticationProvider);
    if (!mounted) return;

    if (state.error != null) {
      FlashMessage.showError(context, state.error!);
      return;
    }

    if (state.authUser != null) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        PromiseProfileScreen.routeName,
        (route) => false,
        arguments: state.authUser!.user.onboarding,
      );
    }
  }

  void validateFields() {
    isValidField.value =
        _nameController.text.isNotEmpty && _usernameController.text.isNotEmpty;
  }
}
