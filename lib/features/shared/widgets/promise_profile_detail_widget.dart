import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sbp_app/features/shared/widgets/w_shared_promise_profile_card.dart';
import '../../onboarding/model/onboarding_result.dart';

class PromiseProfileDetailWidget extends ConsumerWidget {
  const PromiseProfileDetailWidget({
    super.key,
    required this.onboarding,
    required this.showPromiseExample,
    required this.showCelebration,
    required this.isSliderLocked,
  });

  final OnboardingResult onboarding;
  final bool showPromiseExample;
  final bool showCelebration;
  final bool isSliderLocked;

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
    return SharedPromiseProfileCard(
      profileLabel: label,
      profileKey: key,
      intentText: intent,
      motivationText: motivation,
      obstacleText: obstacle,
      showCelebration: showCelebration,
      supportStyleText: support,
      showPromiseExample: showPromiseExample,
      isSliderLocked: isSliderLocked
    );
  }
}
