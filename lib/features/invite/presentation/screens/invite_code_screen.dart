import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/core/utils/responsive_config.dart';
import 'package:sbp_app/features/auth/provider/authentication_providr.dart';
import 'package:sbp_app/features/shared/widgets/w_app_text_logo.dart';
import 'package:sbp_app/features/shared/widgets/w_custom_form_field.dart';
import 'package:sbp_app/features/shared/widgets/w_primary_button.dart';
import 'package:sbp_app/features/invite/presentation/screens/first_login_screen.dart';
import 'package:sbp_app/features/invite/provider/invite_provider.dart';
import 'package:sbp_app/core/constants/assets.dart';
import '../../../../core/services/facebook_events_service.dart';
import '../../../../core/utils/text_styles.dart';
import '../../../shared/widgets/w_app_safe_area.dart';
import '../invite_phone_no_screen.dart';
import 'invitation_code_mismatch.dart' show InviteCodeMisMatch;

class InviteCodeScreen extends StatefulWidget {
  static const String routeName = '/invite-code';
  static String routePath = '/invite-code';

  const InviteCodeScreen({super.key});

  @override
  State<InviteCodeScreen> createState() => _InviteCodeScreenState();
}

class _InviteCodeScreenState extends State<InviteCodeScreen> {
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppSafeArea(
        child: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        padding: EdgeInsets.only(top: 10.h),
                        height: 40.h,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(40.r),
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back, size: 24),
                        ),
                      ),
                    ),

                    const AppNameLogo(),
                    SizedBox(height: 30.h),
                    SizedBox(
                      height: 518.h,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: SizedBox(
                              child: SvgPicture.asset(
                                Assets.svgEarlyAccess,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 20.h,
                            left: 20.w,
                            right: 20.w,
                            child: CustomTextField(
                              hintText: "Enter your invite code",
                              alignment: TextAlign.center,
                              filledColor: Colors.white,
                              style: AppTextStyles.bodyTextStyle.copyWith(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              controller: _codeController,
                              textCapitalization: TextCapitalization.characters,
                              onChange: (v) => setState(() {}),
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Consumer(
                  builder: (context, ref, child) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(height: 24.h),
                        Consumer(
                          builder: (context, ref, child) {
                            final provider = ref.watch(inviteProvider);
                            return PrimaryButton(
                              enabled: _codeController.text.isNotEmpty,
                              text: 'Get Access',
                              isLoading: provider.isLoading,
                              onPressed: () => verifyCode(ref, context),
                              icon: SvgPicture.asset(
                                Assets.svgArrowForward,
                                height: 20.h,
                                width: 24.w,
                                fit: BoxFit.scaleDown,
                              ),
                              iconLeading: false,
                            );
                          },
                        ),
                        if (ref.watch(authenticationProvider).checkPaywall) ...[
                          SizedBox(height: 16.h),
                          PrimaryButton(
                            enabled: _codeController.text.isNotEmpty,
                            text: 'Get an Invite Code',
                            textColor: AppColors.textPrimaryColor,
                            borderColor: const Color(0xFFE2E1E0),
                            isOutlined: true,
                            onPressed: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     fullscreenDialog: true,
                              //     builder: (context) => LegalWebViewPage(
                              //       title: "Stop Breaking Promises",
                              //       url: 'https://stopbreakingpromises.com/',
                              //     ),
                              //   ),
                              // );
                              Navigator.pushNamed(
                                context,
                                InvitePhoneNoScreen.routeName,
                              );
                            },
                          ),
                        ],
                        SizedBox(height: 32.h),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> verifyCode(WidgetRef ref, BuildContext context) async {
    final fbEvents = FacebookEventsService();
    fbEvents.logEvent(
      name: 'invite_code_entered',
      parameters: {'timestamp': DateTime.now().toIso8601String()},
      ref: ref,
      screenName: 'Invite Code',
    );
    FocusManager.instance.primaryFocus?.unfocus();

    final inputCode = _codeController.text.trim();

    if (inputCode.isEmpty) return;

    await ref.read(inviteProvider.notifier).verify(inputCode);

    if (!context.mounted) return;

    final providerState = ref.read(inviteProvider);
    final isSuccess = providerState.isValid == true;
    final isAlreadyActive =
        providerState.error == "User already has active access";

    if (isSuccess || isAlreadyActive) {
      final fbEvents = FacebookEventsService();
      fbEvents.logEvent(
        name: 'invite_code_success',
        parameters: {'timestamp': DateTime.now().toIso8601String()},
        ref: ref,
        screenName: 'Invite Code',
      );
      Navigator.pushReplacementNamed(
        context,
        FirstLoginScreen.routeName,
        arguments: inputCode,
      );
      return;
    }

    if (providerState.error != null) {
      _codeController.clear();
      Navigator.pushNamed(
        context,
        InviteCodeMisMatch.routeName,
        arguments: inputCode,
      );
    }
  }
}
