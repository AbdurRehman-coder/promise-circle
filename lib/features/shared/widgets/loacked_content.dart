import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sbp_app/core/theming/app_colors.dart';

import '../../../core/utils/responsive_config.dart' show SizeExtension;

class LockedContent extends StatelessWidget {
  final Widget child;
  final String overlayText;
  final VoidCallback? onTap;
  final double blurSigma;
  final IconData lockIcon;

  const LockedContent({
    super.key,
    required this.child,
    required this.overlayText,
    required this.onTap,
    this.blurSigma = 5.0,
    this.lockIcon = Icons.lock,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryBlackColor.withValues(alpha: 0.1),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: const BoxDecoration(color: Colors.white),
              child: child,
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "🔑",
                        style: TextStyle(
                          fontSize: 20.sp,
                          color: AppColors.primaryBlackColor,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        overlayText,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryBlackColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
