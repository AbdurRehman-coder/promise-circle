import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sbp_app/core/constants/promise_profile_data.dart';
import '../data/onboarding_data.dart';
import '../model/onboarding_answers.dart';
import '../model/onboarding_result.dart';
import '../model/onboarding_step.dart';

final onboardingStepsProvider = Provider<List<OnboardingStep>>((ref) {
  return onBoardingSteps;
});
final promiseProfileValues = promiseProfileAvatarMap;

class OnboardingController extends Notifier<Map<int, List<int>>> {
  @override
  Map<int, List<int>> build() => {};

  final Map<int, Map<int, List<String>>> _microtagSelections = {};
  void clearMicroTags() {
    _microtagSelections.clear();
  }

  void toggleOption({
    required int step,
    required int optionIndex,
    required int maxAllowed,
  }) {
    final current = state[step] ?? [];

    if (maxAllowed == 1) {
      if (current.contains(optionIndex)) {
        state = {...state, step: []};
      } else {
        state = {
          ...state,
          step: [optionIndex],
        };
      }
      return;
    }

    if (current.contains(optionIndex)) {
      // Remove option
      state = {...state, step: current.where((i) => i != optionIndex).toList()};
    } else {
      if (current.length >= maxAllowed) return;

      state = {
        ...state,
        step: [...current, optionIndex],
      };
    }
  }

  // ✅ NEW: remove a selected option completely
  void removeOption(int step, int optionIndex) {
    final current = state[step] ?? [];
    if (current.contains(optionIndex)) {
      state = {...state, step: current.where((i) => i != optionIndex).toList()};
    }
  }

  void saveMicrotags(int step, int optionIndex, List<String> microtags) {
    _microtagSelections.putIfAbsent(step, () => {});
    if (microtags.isEmpty) {
      _microtagSelections[step]?.remove(optionIndex);
    } else {
      _microtagSelections[step]?[optionIndex] = microtags;
    }
  }

  List<String> getMicrotags(int step, int optionIndex) {
    return _microtagSelections[step]?[optionIndex] ?? [];
  }

  bool isSelected(int step, int optionIndex) {
    return state[step]?.contains(optionIndex) ?? false;
  }

  bool isContinueEnabled(int step, int maxAllowed, int? minSelection) {
    // if (step == onBoardingSteps.length - 1) return true;

    final list = state[step] ?? [];

    final meetsMinRequirement = minSelection != null
        ? list.length >= minSelection
        : list.isNotEmpty;

    final meetsMaxRequirement = list.length <= maxAllowed;

    return meetsMinRequirement && meetsMaxRequirement;
  }

  OnboardingAnswers buildFinalAnswers(List<OnboardingStep> steps) {
    final q1Indexes = state[0] ?? [];
    final q1 = q1Indexes.map((i) {
      final item = steps[0].options[i];
      final microtags = getMicrotags(0, i);
      return IntentAnswer(intent: item.intent ?? '', microtags: microtags);
    }).toList();

    final q2Indexes = state[1] ?? [];
    final q2 = q2Indexes.map((i) => steps[1].options[i].title).toList();

    final q3Indexes = state[2] ?? [];
    final q3 = q3Indexes.map((i) => steps[2].options[i].title).toList();

    final q4Indexes = state[3] ?? [];
    final q4 = q4Indexes.map((i) => steps[3].options[i].title).toList();

    final q5Indexes = state[4] ?? [];
    final q5 = q5Indexes.map((i) => steps[4].options[i].title).toList();

    return OnboardingAnswers(
      q1: q1,
      q2: q2,
      q3Who: q3,
      q4Obstacle: q4,
      q5Accountability: q5,
    );
  }

  
}

final onboardingControllerProvider =
    NotifierProvider<OnboardingController, Map<int, List<int>>>(
      OnboardingController.new,
    );

final onboardingStepIndexProvider = StateProvider<int>((ref) => 0);

final onboardingLoadingProvider =
    StateNotifierProvider<OnboardingLoadingNotifier, bool>(
      (_) => OnboardingLoadingNotifier(),
    );

class OnboardingLoadingNotifier extends StateNotifier<bool> {
  OnboardingLoadingNotifier() : super(false);

  void setLoading(bool value) => state = value;
}

final onboardingResultProvider = StateProvider<OnboardingResult?>(
  (ref) => null,
);
