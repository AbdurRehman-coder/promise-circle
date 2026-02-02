import '../../features/onboarding/model/onboarding_result.dart';

// --- Shared Components ---

class UserProfileRequest {
  final String key;
  final String label;
  final String hint;

  const UserProfileRequest({
    required this.key,
    required this.label,
    required this.hint,
  });

  factory UserProfileRequest.fromProfile(Profile profile) {
    return UserProfileRequest(
      key: profile.key,
      label: profile.label,
      hint: profile.hint,
    );
  }

  Map<String, dynamic> toJson() => {'key': key, 'label': label, 'hint': hint};
}

class OnboardingAnswersRequest {
  final List<String> q2;
  final List<String> q3Who;
  final List<String> q4Obstacle;
  final List<String> q5Accountability;

  const OnboardingAnswersRequest({
    required this.q2,
    required this.q3Who,
    required this.q4Obstacle,
    required this.q5Accountability,
  });

  factory OnboardingAnswersRequest.fromWeightages(Weightages weightages) {
    return OnboardingAnswersRequest(
      q2: weightages.q2.map((e) => e.answer).toList(),
      q3Who: weightages.q3Who.map((e) => e.answer).toList(),
      q4Obstacle: weightages.q4Obstacle.map((e) => e.answer).toList(),
      q5Accountability: weightages.q5Accountability
          .map((e) => e.answer)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'q2': q2,
    'q3_who': q3Who,
    'q4_obstacle': q4Obstacle,
    'q5_accountability': q5Accountability,
  };
}

class PromiseContextRequest {
  final UserProfileRequest profile;
  final List<String> intentTags;
  final List<String> microtags;
  final OnboardingAnswersRequest answers;

  const PromiseContextRequest({
    required this.profile,
    required this.intentTags,
    required this.microtags,
    required this.answers,
  });

  factory PromiseContextRequest.fromOnboardingResult(OnboardingResult result) {
    return PromiseContextRequest(
      profile: UserProfileRequest.fromProfile(result.profile),
      intentTags: result.intentTags,
      microtags: result.microtags,
      answers: OnboardingAnswersRequest.fromWeightages(result.weightages),
    );
  }

  Map<String, dynamic> toJson() => {
    'profile': profile.toJson(),
    'intentTags': intentTags,
    'microtags': microtags,
    'answers': answers.toJson(),
  };
}

class GenerateSamplePromiseRequest {
  final PromiseContextRequest context;
  final String? theme;

  const GenerateSamplePromiseRequest({required this.context, this.theme});

  factory GenerateSamplePromiseRequest.fromOnboarding(
    OnboardingResult result, {
    String? theme,
  }) {
    return GenerateSamplePromiseRequest(
      context: PromiseContextRequest.fromOnboardingResult(result),
      theme: theme,
    );
  }

  Map<String, dynamic> toJson() {
    final map = context.toJson();
    if (theme != null) {
      map['theme'] = theme;
    }
    return map;
  }
}

class GeneratePromiseFromBrokenRequest {
  final PromiseContextRequest context;
  final Map<String, String?>? previousBrokenPromises;

  const GeneratePromiseFromBrokenRequest({
    required this.context,
    required this.previousBrokenPromises,
  });

  factory GeneratePromiseFromBrokenRequest.fromOnboarding({
    required OnboardingResult result,
    required Map<String, String?>? previousBrokenPromises,
  }) {
    return GeneratePromiseFromBrokenRequest(
      context: PromiseContextRequest.fromOnboardingResult(result),
      previousBrokenPromises: previousBrokenPromises,
    );
  }

  Map<String, dynamic> toJson() {
    final map = context.toJson();
    map['previousBrokenPromises'] = previousBrokenPromises;
    return map;
  }
}

class GeneratePromiseReasonRequest {
  final PromiseContextRequest context;
  final String description;
  final Map<String, String?>? previousBrokenPromises;

  const GeneratePromiseReasonRequest({
    required this.context,
    required this.description,
    required this.previousBrokenPromises,
  });

  factory GeneratePromiseReasonRequest.fromOnboarding({
    required OnboardingResult result,
    required String description,
    required Map<String, String?>? previousBrokenPromises,
  }) {
    return GeneratePromiseReasonRequest(
      context: PromiseContextRequest.fromOnboardingResult(result),
      description: description,
      previousBrokenPromises: previousBrokenPromises,
    );
  }

  Map<String, dynamic> toJson() {
    final map = context.toJson();
    map['description'] = description;
    map['previousBrokenPromises'] = previousBrokenPromises;
    return map;
  }
}

class GenerateBreakCostRequest {
  final PromiseContextRequest context;
  final String description;
  final Map<String, String?> reasons;
  final Map<String, String?>? previousBrokenPromises;

  const GenerateBreakCostRequest({
    required this.context,
    required this.description,
    required this.reasons,
    required this.previousBrokenPromises,
  });

  factory GenerateBreakCostRequest.fromOnboarding({
    required OnboardingResult result,
    required String description,
    required Map<String, String?> reasons,
    required Map<String, String?>? previousBrokenPromises,
  }) {
    return GenerateBreakCostRequest(
      context: PromiseContextRequest.fromOnboardingResult(result),
      description: description,
      reasons: reasons,
      previousBrokenPromises: previousBrokenPromises,
    );
  }

  Map<String, dynamic> toJson() {
    final map = context.toJson();
    map['description'] = description;
    map['reasons'] = reasons;
    map['previousBrokenPromises'] = previousBrokenPromises;
    return map;
  }
}

class TransformBrokenPromisesRequest {
  final String brokenPromise1;
  final String? brokenPromise2;
  final String? brokenPromise3;

  const TransformBrokenPromisesRequest({
    required this.brokenPromise1,
    this.brokenPromise2,
    this.brokenPromise3,
  });

  Map<String, dynamic> toJson() => {
    'broken_promise_1': brokenPromise1,
    'broken_promise_2': brokenPromise2,
    'broken_promise_3': brokenPromise3,
  };
}
