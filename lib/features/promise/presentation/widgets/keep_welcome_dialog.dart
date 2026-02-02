import 'package:flutter_svg/svg.dart';
import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/core/utils/app_exports.dart';
import 'package:sbp_app/core/utils/text_styles.dart';
import 'package:sbp_app/features/shared/widgets/w_primary_button.dart';

import '../../../../core/constants/assets.dart';
import '../../../../core/utils/responsive_config.dart';

class KeepWelcomeDialog extends StatelessWidget {
  const KeepWelcomeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildAvatar(),
              const SizedBox(height: 24),

              Text(
                "Hello, I'm Keep.ai",
                style: AppTextStyles.bodyTextStyleBogart.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 26.sp,
                  color: const Color(0xFF1A1A1A),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: AppTextStyles.bodyTextStyle.copyWith(
                    color: const Color(0xFF4A4A4A),
                    height: 1.5, // Improved readability
                    fontSize: 16,
                  ),
                  children: const [
                    TextSpan(text: "But you can call me "),
                    TextSpan(
                      text: "Keep",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.blackColor,
                      ),
                    ),
                    TextSpan(text: " for short.\n\n"),

                    TextSpan(
                      text:
                          "Your promise is now tracked so you'll be getting notifications and messages from me when its time to check in on your daily promises.",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // 4. Action Button
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  text: "Okay",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return SizedBox(
      width: 80,
      height: 80,

      child: SvgPicture.asset(Assets.svgBottomBarMainIcon),
    );
  }
}
