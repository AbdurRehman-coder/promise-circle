import 'package:flutter/gestures.dart';
import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/core/utils/app_exports.dart';
import 'package:sbp_app/core/utils/text_styles.dart';
import 'package:sbp_app/features/shared/widgets/legal_web_view.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  void _openLegalPage(BuildContext context, String title, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => LegalWebViewPage(title: title, url: url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: AppTextStyles.bodyTextStyle.copyWith(
            color: AppColors.greysColor,
            fontSize: 14,
          ),
          children: [
            const TextSpan(text: 'By continuing you agree to our\n'),
            
            // --- Terms of Use ---
            TextSpan(
              text: 'Terms of Use',
              style: AppTextStyles.bodyTextStyle.copyWith(
                color: AppColors.blackColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => _openLegalPage(
                      context,
                      'Terms of Use',
                      'https://stopbreakingpromises.com/terms-conditions',
                    ),
            ),
            
            const TextSpan(text: ' and '),
            
            // --- Privacy Policy ---
            TextSpan(
              text: 'Privacy Policy',
              style: AppTextStyles.bodyTextStyle.copyWith(
                color: AppColors.blackColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => _openLegalPage(
                      context,
                      'Privacy Policy',
                      'https://stopbreakingpromises.com/privacy-policy',
                    ),
            ),
          ],
        ),
      ),
    );
  }
}