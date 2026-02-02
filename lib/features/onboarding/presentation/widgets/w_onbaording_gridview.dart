import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sbp_app/core/utils/responsive_config.dart';
import 'package:sbp_app/features/onboarding/presentation/widgets/w_intent_selection_dialog.dart';

import '../../model/onboarding_step.dart';
import '../../provider/onboarding_provider.dart';
import '../widgets/w_option_card.dart';

class OnboardingGridView extends ConsumerWidget {
  final List<OptionItem> options;
  final int currentStepIndex;
  final int maxSelection;

  const OnboardingGridView({
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

    return GridView.builder(
      itemCount: options.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 8.h,
        childAspectRatio: 1.25,
      ),
      itemBuilder: (context, index) {
        final isSelected =
            selections[currentStepIndex]?.contains(index) ?? false;

        return GestureDetector(
          onTap: () async {
            final isAlreadySelected =
                selections[currentStepIndex]?.contains(index) ?? false;

            final selectedCount = selections[currentStepIndex]?.length ?? 0;

            // ❌ Don't open dialog if max reached AND this option is not already selected
            if (!isAlreadySelected && selectedCount >= maxSelection) {
              return;
            }

            // ✔ Only selected or allowed → open dialog
            final previouslySelected = controller.getMicrotags(
              currentStepIndex,
              index,
            );

            final selectedMicrotags = await showModalBottomSheet<List<String>>(
              context: context,
              isScrollControlled: true,
              constraints: BoxConstraints(maxWidth: double.infinity),
              backgroundColor: Colors.transparent,
              builder: (_) => IntentSelectionBottomSheet(
                title: options[index].title,
                icon: options[index].icon,
                intents: options[index].microtags ?? [],
                previouslySelected: previouslySelected,
              ),
            );

            if (selectedMicrotags == null) return;

            if (selectedMicrotags.isNotEmpty) {
              controller.saveMicrotags(
                currentStepIndex,
                index,
                selectedMicrotags,
              );

              if (!controller.isSelected(currentStepIndex, index)) {
                controller.toggleOption(
                  step: currentStepIndex,
                  optionIndex: index,
                  maxAllowed: maxSelection,
                );
              }
            } else {
              controller.saveMicrotags(currentStepIndex, index, []);
              controller.removeOption(currentStepIndex, index);
            }
          },

          child: OptionCard(
            item: options[index],
            isSelected: isSelected,
            isListItem: false,
          ),
        );
      },
    );
  }
}
