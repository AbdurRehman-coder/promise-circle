import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/core/utils/text_styles.dart';
import 'package:sbp_app/core/constants/assets.dart';

class PromiseProfileShareCard extends StatelessWidget {
  final String profileName;
  final String profileKey;
  final String imagePath;

  const PromiseProfileShareCard({
    super.key,
    required this.profileName,
    required this.profileKey,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1080,
      height: 1920,
      child: FittedBox(
        fit: BoxFit.cover,
        child: Container(
          width: 400,
          height: 711.11,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primaryBlackColor,
                AppColors.secondaryBlueColor,
              ],
            ),
            // borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    "MY",
                    style: AppTextStyles.bodyTextStyle.copyWith(
                      color: Colors.white54,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SvgPicture.asset(Assets.svgAppNameWhiteIcon, height: 25),
                  const SizedBox(height: 12),
                  Text(
                    "PROFILE IS",
                    style: AppTextStyles.bodyTextStyle.copyWith(
                      color: Colors.white54,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),

              Column(
                children: [
                  const SizedBox(height: 24),
                  Text(
                    profileName,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.headingTextStyleBogart.copyWith(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    profileKey,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyTextStyle.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: SvgPicture.asset(imagePath, fit: BoxFit.contain),
                ),
              ),

              Column(
                children: [
                  Text(
                    "Download at",
                    style: AppTextStyles.bodyTextStyle.copyWith(
                      color: Colors.white70,
                      fontSize: 14,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "www.stopbreakingpromises.com",
                    style: AppTextStyles.bodyTextStyle.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
