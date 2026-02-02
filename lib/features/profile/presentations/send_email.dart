import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/core/utils/responsive_config.dart';
import 'package:sbp_app/core/utils/text_styles.dart';
import 'package:sbp_app/core/utils/validators.dart';
import 'package:sbp_app/features/shared/widgets/w_primary_button.dart';
import 'package:sbp_app/features/profile/providers/profile_provider.dart';
import 'package:sbp_app/features/shared/widgets/back_button.dart';
import 'package:sbp_app/features/shared/widgets/flushbar.dart';
import 'package:sbp_app/features/shared/widgets/input_textfield_label.dart';
import 'package:sbp_app/features/shared/widgets/screen_template.dart';

class SendEmail extends ConsumerStatefulWidget {
  const SendEmail({super.key});
  static const String routeName = '/send-email';
  static String routePath = '/send-email';
  @override
  ConsumerState<SendEmail> createState() => _SendEmailState();
}

class _SendEmailState extends ConsumerState<SendEmail> {
  late final TextEditingController _name;
  late final TextEditingController _emailController;
  late final TextEditingController _reason;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController();
    _emailController = TextEditingController();
    _reason = TextEditingController();
  }

  @override
  void dispose() {
    _name.dispose();
    _emailController.dispose();
    _reason.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      widget: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BackButtonWidget(),
            SizedBox(height: 16.h),
            Text(
              'Send Email',
              style: AppTextStyles.headingTextStyleBogart.copyWith(
                color: AppColors.blackColor,
                fontSize: 32.sp,
                letterSpacing: 0.9,
              ),
            ),
            SizedBox(height: 16.h),
            // const SizedBox(height: 24),
            BuildInputFieldLabel(
              label: 'Full name',
              hintText: 'Enter your full name',
              controller: _name,
            ),
            SizedBox(height: 24.h),
            BuildInputFieldLabel(
              label: 'Email',
              hintText: 'example@host.com',
              controller: _emailController,
              validator: Validators.validateEmail,
            ),
            SizedBox(height: 20.h),
            BuildInputFieldLabel(
              label: 'Reason',
              hintText: 'Write your reason to send email',
              controller: _reason,
              maxlines: 4,
            ),
            SizedBox(height: 16.h),
            const Spacer(),
            Consumer(
              builder: (context, ref, child) {
                final isLoading = ref.watch(profileProvider).isLoading;
                return PrimaryButton(
                  text: "Send email",
                  isLoading: isLoading,
                  onPressed: () {
                    sendSupport();
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

  void sendSupport() async {
    if (Validators.validateEmail(_emailController.text) != null ||
        _name.text.isEmpty ||
        _reason.text.isEmpty) {
      FlashMessage.showError(context, "Please fill all fields correctly");
      return;
    }

    await ref
        .read(profileProvider.notifier)
        .sendSupport(
          context,
          _name.text,
          _emailController.text.trim(),
          _reason.text.trim(),
        );

    final provider = ref.read(profileProvider);

    if (!mounted) return;

    if (provider.error != null) {
      FlashMessage.showError(context, provider.error!);
      return;
    }

    if (provider.isValid == true) {
      FlashMessage.showSuccess(context, "Success");
      Navigator.pop(context);
      return;
    }
  }
}
