import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sbp_app/core/utils/responsive_config.dart';
import 'package:sbp_app/features/invite/presentation/screens/invite_code_screen.dart';
import 'package:sbp_app/features/shared/widgets/w_app_text_logo.dart';
import 'package:sbp_app/features/shared/widgets/w_primary_button.dart';
import 'package:sbp_app/core/constants/assets.dart';

import '../../../shared/widgets/w_app_safe_area.dart';

class SuccessInvitationScreen extends StatelessWidget {
  const SuccessInvitationScreen({super.key});
  static const String routeName = '/success-invite';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppSafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40.h),
              const AppNameLogo(),
              SizedBox(height: 36.h),
              Expanded(child: SvgPicture.asset(Assets.svgInviteSuccess)),
              SizedBox(height: 32.h),
              PrimaryButton(
                text: 'Done',
                onPressed: () => Navigator.popUntil(
                  context,
                  ModalRoute.withName(InviteCodeScreen.routeName),
                ),
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }
}
