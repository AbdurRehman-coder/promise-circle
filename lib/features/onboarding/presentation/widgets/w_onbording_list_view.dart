import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/responsive_config.dart';
import '../../model/onboarding_step.dart';
import '../../provider/onboarding_provider.dart';
import '../widgets/w_option_card.dart';

class OnboardingListView extends ConsumerWidget {
  final List<OptionItem> options;
  final int currentStepIndex;
  final int maxSelection;

  const OnboardingListView({
    super.key,
    required this.options,
    required this.currentStepIndex,
    required this.maxSelection,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selections = ref.watch(
      onboardingControllerProvider,
    ); // 👈 watch state
    final controller = ref.read(onboardingControllerProvider.notifier);

    return ListView.builder(
      itemCount: options.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final isSelected =
            selections[currentStepIndex]?.contains(index) ?? false;

        return GestureDetector(
          onTap: () => controller.toggleOption(
            step: currentStepIndex,
            optionIndex: index,
            maxAllowed: maxSelection,
          ),
          child: Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: OptionCard(
              item: options[index],
              isSelected: isSelected,
              isListItem: true,
            ),
          ),
        );
      },
    );
  }
}
