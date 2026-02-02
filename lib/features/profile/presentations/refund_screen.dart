import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/core/utils/text_styles.dart';
import 'package:sbp_app/core/utils/validators.dart';
import 'package:sbp_app/features/shared/widgets/w_primary_button.dart';
import 'package:sbp_app/features/auth/provider/authentication_providr.dart';
import 'package:sbp_app/features/profile/presentations/widgets/reason_selection_tile.dart';
import 'package:sbp_app/features/profile/providers/profile_provider.dart';
import 'package:sbp_app/features/shared/widgets/back_button.dart';
import 'package:sbp_app/features/shared/widgets/flushbar.dart';
import 'package:sbp_app/features/shared/widgets/input_textfield_label.dart';
import 'package:sbp_app/features/shared/widgets/screen_template.dart';

class RefundScreen extends ConsumerStatefulWidget {
  const RefundScreen({super.key});
  static const String routeName = '/refund';
  static String routePath = '/refund';
  @override
  ConsumerState<RefundScreen> createState() => _RefundScreenState();
}

class _RefundScreenState extends ConsumerState<RefundScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _reasonController;

  String reason = "app_issue";

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _reasonController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _reasonController.dispose();
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
            const SizedBox(height: 16),
            Text(
              'Refund',
              style: AppTextStyles.headingTextStyleBogart.copyWith(
                color: AppColors.blackColor,
                fontSize: 32,
                letterSpacing: 0.9,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'You’re covered with our Refund Guarantee',
              style: AppTextStyles.bodyTextStyle.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.greyColor,
              ),
            ),
            const SizedBox(height: 24),
            BuildInputFieldLabel(
              label: 'Email that you used at purchase',
              hintText: 'example@host.com',
              controller: _emailController,
              validator: Validators.validateEmail,
            ),
            const SizedBox(height: 20),
            Text(
              "Reason",
              style: AppTextStyles.bodyTextStyle.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            ReasonSelectionWidget(
              onSelected: (e) {
                setState(() {
                  reason = e;
                });
              },
            ),
            const SizedBox(height: 16),
            BuildInputFieldLabel(
              label: 'Reason',
              hintText: 'Refund reason',
              controller: _reasonController,
              maxlines: 3,
            ),
            const SizedBox(height: 16),
            Text(
              "Refunds are usually processed within 24 hours.\nDepending on your bank, funds may appear within 3–7 days.",
              style: AppTextStyles.bodyTextStyle.copyWith(
                fontSize: 11,
                color: AppColors.greysColor,
              ),
            ),
            const SizedBox(height: 16),
            const Spacer(),
            Consumer(
              builder: (context, ref, child) {
                final isLoading = ref.watch(profileProvider).isLoading;
                return PrimaryButton(
                  text: "Request Refund",
                  isLoading: isLoading,
                  enabled: !isLoading,
                  onPressed: () {
                    sendRefundRequest();
                  },
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void sendRefundRequest() async {
    if (Validators.validateEmail(_emailController.text) != null) return;

    final user = ref.read(authenticationProvider).authUser!.user;

    await ref
        .read(profileProvider.notifier)
        .refund(
          context,
          _emailController.text.trim(),
          reason.trim(),
          user.name ?? '',
          _reasonController.text.trim(),
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
