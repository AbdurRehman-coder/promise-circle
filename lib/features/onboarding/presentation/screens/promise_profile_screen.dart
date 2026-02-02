import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/core/utils/helper_functions.dart';
import 'package:sbp_app/core/utils/responsive_config.dart';
import 'package:sbp_app/features/shared/widgets/w_primary_button.dart';
import 'package:sbp_app/features/promise/presentation/screens/ui_promise_flow.dart';
import 'package:sbp_app/core/constants/assets.dart';
import 'package:sbp_app/features/shared/widgets/w_shared_promise_profile_card.dart';

import '../../../shared/widgets/w_app_safe_area.dart';
import '../../model/onboarding_result.dart';

class PromiseProfileScreen extends ConsumerWidget {
  const PromiseProfileScreen({
    super.key,
    required this.onboarding,
    required this.showFirstPromiseButton,
  });
  final bool showFirstPromiseButton;
  final OnboardingResult onboarding;

  static const String routeName = '/promise-profile';
  String safeJoinAnswers(List? list) {
    if (list == null || list.isEmpty) return 'N/A';
    return list
        .map((item) {
          final text = item.answer?.toString() ?? '';
          return capitalize(text);
        })
        .where((text) => text.isNotEmpty)
        .join(', ');
  }

  String safeList(List<String>? list) {
    if (list == null || list.isEmpty) return 'N/A';
    return list.map(capitalize).join(', ');
  }

  String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final intent = safeList(onboarding.intentTags);
    final motivation = safeJoinAnswers(onboarding.weightages.q2);
    final obstacle = safeJoinAnswers(onboarding.weightages.q4Obstacle);
    final support = safeJoinAnswers(onboarding.weightages.q3Who);

    final label = onboarding.profile.label;
    final key = onboarding.profile.key;
    return Scaffold(
      body: AppSafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            children: [
              !showFirstPromiseButton
                  ? Align(
                      alignment: Alignment.bottomLeft,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back),
                      ),
                    )
                  : SizedBox.shrink(),
              SharedPromiseProfileCard(
                profileLabel: label,
                profileKey: key,
                intentText: intent,
                motivationText: motivation,
                obstacleText: obstacle,
                showCelebration: true,
                supportStyleText: support,
                showPromiseExample: true,

                isSliderLocked: false,
              ),

              SizedBox(height: 46.h),

              PrimaryButton(
                iconLeading: true,
                icon: SvgPicture.asset(Assets.svgShareBlackIcon),
                isOutlined: true,
                text: "Share my Promise Profile",
                borderColor: AppColors.primaryBlackColor.withValues(alpha: 0.3),
                onPressed: () async {
                  await HelperFunctions.sharePromiseProfile(
                    context,
                    label: onboarding.profile.label,
                    key: onboarding.profile.key, screenName: 'Promise Profile', ref: ref,
                  );
                },
              ),
              if (showFirstPromiseButton) SizedBox(height: 16.h),
              if (showFirstPromiseButton)
                PrimaryButton(
                  text: "Make One 2026 Promise",
                  onPressed: () {
                    Navigator.pushNamed(context, UIPromiseFlowScreen.routeName);
                  },
                ),

              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
