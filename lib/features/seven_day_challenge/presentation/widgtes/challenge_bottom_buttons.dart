import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sbp_app/core/constants/assets.dart';
import 'package:sbp_app/core/services/app_services.dart';
import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/core/utils/responsive_config.dart';
import 'package:sbp_app/features/main_home/presentations/main_home_screen.dart';
import 'package:sbp_app/features/promise/presentation/screens/ui_promise_flow.dart';
import 'package:sbp_app/features/promise/provider/promise_controller.dart';

import 'package:sbp_app/features/shared/widgets/w_primary_button.dart';

import '../../models/seven_day_challenge_model.dart';
import '../../provider/challenge_provider.dart';
import '../../services/challenge_services.dart';
import '../../utils/challenge_utils.dart';
import '../../../shared/providers/ai_examples_provider.dart';

class ChallengeBottomButtons extends ConsumerStatefulWidget {
  final bool isUnlocked;
  final int dayIndex;
  final ChallengeDayContent? content;

  const ChallengeBottomButtons({
    super.key,
    required this.isUnlocked,
    required this.dayIndex,
    this.content,
  });

  @override
  ConsumerState<ChallengeBottomButtons> createState() =>
      _ChallengeBottomButtonsState();
}

class _ChallengeBottomButtonsState
    extends ConsumerState<ChallengeBottomButtons> {
  bool _isLoading = false;

  Future<void> _handleChallengeCompletion(BuildContext context) async {
    final challengeNotifier = ref.read(challengeProvider.notifier);

    bool isHomeFound = false;
    Navigator.of(context).popUntil((route) {
      if (route.settings.name == HomeDashboardPage.routeName) {
        isHomeFound = true;
        return true;
      }
      return route.isFirst;
    });

    if (!isHomeFound && context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        HomeDashboardPage.routeName,
        (route) => false,
      );
    }

    try {
      final challengeService = locator.get<ChallengeServices>();
      final dayKey = ChallengeUtils.getDayKey(widget.dayIndex);

      await challengeService.updateDay(dayKey);

      final updatedChallenge = await challengeNotifier.loadChallenge();
      challengeNotifier.updateNotifications(updatedChallenge);
    } catch (e) {
      debugPrint("Error updating challenge day: $e");
    }
  }

  Future<void> _navigateToPromiseFlow(BuildContext context) async {
    setState(() => _isLoading = true);
    try {
      if (widget.content != null) {
        await ref
            .read(aiExamplesControllerProvider.notifier)
            .getSamplePromise(theme: widget.content!.theme);
      }

      ref.read(promiseStepIndexProvider.notifier).state = 2;

      final Object arguments = {
        "is_challenge_promise": true,
        "day_key": ChallengeUtils.getDayKey(widget.dayIndex),
      };

      if (context.mounted) {
        Navigator.of(
          context,
        ).pushNamed(UIPromiseFlowScreen.routeName, arguments: arguments);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PrimaryButton(
            isLoading: _isLoading,
            onPressed: () async {
              if (widget.dayIndex == 6) {
                await _handleChallengeCompletion(context);
                return;
              }

              if (widget.isUnlocked) {
                _handleChallengeCompletion(context);
              } else {
                await _navigateToPromiseFlow(context);
              }
            },
            icon: SvgPicture.asset(Assets.svgArrowForward),
            text: widget.isUnlocked
                ? "Begin Tracking"
                : (widget.content?.ctaText ?? "Continue"),
            backgroundColor: AppColors.primaryBlackColor,
          ),
          if (widget.dayIndex == 7) ...[
            SizedBox(height: 12.h),
            PrimaryButton(
              onPressed: () => _handleChallengeCompletion(context),
              text: "Prepare to Track Promises",
              textColor: AppColors.primaryBlackColor,
              borderColor: const Color(0xFFBBBBBB),
              isOutlined: true,
            ),
          ],
        ],
      ),
    );
  }
}
