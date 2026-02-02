import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sbp_app/core/utils/app_extensions.dart';
import '../../../../core/constants/assets.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/utils/text_styles.dart';
import '../../../shared/widgets/squiggly_container.dart';

class PromiseShareCard extends StatelessWidget {
  final dynamic result;
  final String name;
  const PromiseShareCard({super.key, required this.result, required this.name});

  @override
  Widget build(BuildContext context) {
    const double logicalWidth = 400;
    const double logicalHeight = 711.11;

    return MediaQuery(
      data: const MediaQueryData(
        size: Size(1080, 1920),
        textScaler: TextScaler.noScaling,
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: SizedBox(
          width: 1080,
          height: 1920,
          child: FittedBox(
            fit: BoxFit.fill,
            child: Container(
              width: logicalWidth,
              height: logicalHeight,
              color: AppColors.backgroundColor,
              child: Material(
                type: MaterialType.transparency,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 36, 24, 36),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SquigglyContainer(
                        borderColor: const Color(0xFF6CC163),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                Assets.svgAppNameIcon,
                                height: 24,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'MY ONE PROMISE 2026',
                                style: AppTextStyles.bodyTextStyle.copyWith(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primaryBlackColor.withValues(
                                    alpha: 0.6,
                                  ),
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildSectionDivider(
                                context,
                                (result.categories ?? [])
                                    .map(
                                      (e) => (e as String).capitalizeA.trim(),
                                    )
                                    .join(" • "),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'I Promise',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.headingTextStyleBogart
                                    .copyWith(
                                      fontSize: 27,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryBlackColor,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              AutoSizeText(
                                _cleanDescription(result.description ?? ""),
                                textAlign: TextAlign.center,

                                maxLines: 3,
                                softWrap: true,
                                style: AppTextStyles.headingTextStyleBogart
                                    .copyWith(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.primaryBlackColor,

                                      height: 1.1,
                                    ),
                              ),
                              const SizedBox(height: 18),
                              _buildStarDivider(),
                              const SizedBox(height: 18),
                              Text(
                                'This is my ONE Promise. Hold me to it!',
                                style: AppTextStyles.bodyTextStyle.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryBlackColor.withValues(
                                    alpha: 0.8,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "— ${name.split(' ')[0]}",
                                style: AppTextStyles.bodyTextStyle.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryBlackColor.withValues(
                                    alpha: 0.8,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Reduced space to match image
                      const SizedBox(height: 24),

                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "What’s Your ONE\nPromise for 2026?",
                            textAlign: TextAlign.center,
                            style: AppTextStyles.headingTextStyleBogart
                                .copyWith(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryBlackColor,
                                  height: 1.1,
                                ),
                          ),
                          // Reduced space
                          const SizedBox(height: 16),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: AppTextStyles.bodyTextStyle.copyWith(
                                fontSize: 15,
                                color: AppColors.primaryBlackColor,
                                height: 1.3,
                              ),
                              children: const [
                                TextSpan(text: 'Download '),
                                TextSpan(
                                  text: 'Stop Breaking Promises',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'app to make and share yours!',
                            style: AppTextStyles.bodyTextStyle.copyWith(
                              fontSize: 16,
                              height: 1.3,
                            ),
                          ),
                          // Reduced space
                          const SizedBox(height: 20),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: _buildStoreButton(
                                    icon: Assets.appStoreIcon,
                                    label1: "Download on the",
                                    label2: "App Store",
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildStoreButton(
                                    icon: Assets.playStoreIcon,
                                    label1: "Get it on",
                                    label2: "Google Play",
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Reduced space
                          const SizedBox(height: 24),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                Assets.instagramIcon,
                                height: 20,
                              ),
                              const SizedBox(width: 16),
                              SvgPicture.asset(Assets.threadIcon, height: 20),
                              const SizedBox(width: 16),
                              SvgPicture.asset(Assets.tiktokIcon, height: 20),
                              const SizedBox(width: 16),
                              Text(
                                '#MyOnePromise',
                                style: AppTextStyles.headingTextStyleBogart
                                    .copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '@promises.app',
                            style: AppTextStyles.bodyTextStyle.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionDivider(BuildContext context, String title) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Colors.black12, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 240),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                style: AppTextStyles.headingTextStyleBogart.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlackColor,
                ),
              ),
            ),
          ),
        ),
        const Expanded(child: Divider(color: Colors.black12, thickness: 1)),
      ],
    );
  }

  Widget _buildStarDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(color: Colors.black12, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SvgPicture.asset(
            Assets.svgTwinkleStarsBlackIcon,
            height: 18,
            width: 18,
          ),
        ),
        const Expanded(child: Divider(color: Colors.black12, thickness: 1)),
      ],
    );
  }

  String _cleanDescription(String desc) {
    String cleaned = desc;
    if (cleaned.toLowerCase().startsWith('i promise')) {
      cleaned = cleaned.substring(9).trim();
    }
    return cleaned;
  }

  Widget _buildStoreButton({
    required String icon,
    required String label1,
    required String label2,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(40),
        color: Colors.transparent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(icon, height: 22),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label1, style: const TextStyle(fontSize: 8, height: 1.0)),
              Text(
                label2,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
