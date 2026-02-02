import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sbp_app/core/utils/responsive_config.dart';
import 'package:sbp_app/features/shared/widgets/bottom_height_widget.dart';
import 'package:sbp_app/features/shared/widgets/w_app_safe_area.dart';
import '../../data/challenge_data.dart';
import '../../provider/challenge_provider.dart';
import '../widgtes/challenge_bottom_buttons.dart';
import '../widgtes/challenge_day_card.dart';
import '../widgtes/unlock_content.dart';

class SevenDayChallengeScreen extends ConsumerStatefulWidget {
  const SevenDayChallengeScreen({super.key});
  static const String routeName = '/seven-day-challenge';

  @override
  ConsumerState<SevenDayChallengeScreen> createState() =>
      _SevenDayChallengeScreenState();
}

class _SevenDayChallengeScreenState
    extends ConsumerState<SevenDayChallengeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int dayIndex = ref.read(challengeProvider).currentDay;
    final bool isUnlocked = dayIndex > 7;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F0),
      body: AppSafeArea(
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    sliver: SliverToBoxAdapter(
                      child: isUnlocked
                          ? const UnlockContent()
                          : ChallengeDayCard(
                              dayIndex: dayIndex,
                              content: challengeContentMap[dayIndex]!,
                              animationController: _animationController,
                            ),
                    ),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(height: 32.h),
                        ChallengeBottomButtons(
                          isUnlocked: isUnlocked,
                          dayIndex: dayIndex,
                          content: !isUnlocked
                              ? challengeContentMap[dayIndex]
                              : null,
                        ),
                        const BottomHeightWidget(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
