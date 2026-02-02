import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/core/utils/responsive_config.dart';
import 'package:sbp_app/core/utils/text_styles.dart';
import 'package:sbp_app/features/auth/provider/authentication_providr.dart';

import 'package:sbp_app/features/profile/presentations/send_email.dart';
import 'package:sbp_app/features/shared/widgets/w_app_text_logo.dart';
import 'package:sbp_app/features/shared/widgets/w_primary_button.dart';
import 'package:sbp_app/core/constants/assets.dart';

import '../../../shared/widgets/w_app_safe_area.dart' show AppSafeArea;
import '../invite_phone_no_screen.dart';

class InviteCodeMisMatch extends StatefulWidget {
  static const String routeName = '/invite-code-mismatch';
  static String routePath = '/invite-code-mismatch';
  const InviteCodeMisMatch({super.key});

  @override
  State<InviteCodeMisMatch> createState() => _InviteCodeMisMatch();
}

class _InviteCodeMisMatch extends State<InviteCodeMisMatch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppSafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Consumer(
            builder: (context, ref, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 40.h),
                  AppNameLogo(),
                  SizedBox(height: 36.h),
                  Expanded(
                    child: SvgPicture.asset(
                      Assets.svgCodeNotFound,
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  PrimaryButton(
                    text: 'Try Again',
                    onPressed: () {
                      Navigator.pop(context);
                    },

                    iconLeading: false,
                  ),
                  if (ref.watch(authenticationProvider).checkPaywall) ...[
                    SizedBox(height: 16.h),
                    PrimaryButton(
                      outlinedButtonBackgroundColor: AppColors.whiteColor,
                      backgroundColor: const Color(0xffE2E1E0),
                      textColor: AppColors.primaryBlackColor,
                      isOutlined: true,
                      text: 'Get an Invite Code',
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
                      iconLeading: false,
                    ),
                  ],
                  SizedBox(height: 24.h),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, SendEmail.routeName);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          Assets.svgContactSupportIcon,
                          height: 18.h,
                          width: 16.w,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          "Contact Support",
                          style: AppTextStyles.bodyTextStyle.copyWith(
                            fontSize: 14.sp,
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32.h),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
