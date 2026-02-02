import 'dart:convert';

class OnboardingResult {
  final bool ok;
  final Profile profile;
  final Scores scores;
  final Buckets buckets;
  final List<String> intentTags;
  final List<String> microtags;
  final Weightages weightages;
  final String? progressionHint;
  final String? suggestionByAI;
  final bool? completed;

  OnboardingResult({
    required this.ok,
    required this.profile,
    required this.scores,
    required this.buckets,
    required this.intentTags,
    required this.microtags,
    required this.weightages,
    this.completed,
    this.progressionHint,
    this.suggestionByAI,
  });

  factory OnboardingResult.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data = json['onboarding'] ?? json;

    return OnboardingResult(
      ok: json['ok'] ?? false,

      profile: Profile.fromJson(data['profile'] ?? {}),
      scores: Scores.fromJson(data['scores'] ?? {}),
      buckets: Buckets.fromJson(data['buckets'] ?? {}),
      intentTags:
          (data['intentTags'] as List?)?.map((e) => e.toString()).toList() ??
          [],
      microtags:
          (data['microtags'] as List?)?.map((e) => e.toString()).toList() ?? [],
      weightages: Weightages.fromJson(data['weightages'] ?? {}),
      progressionHint: data['progressionHint'] ?? '',
      suggestionByAI: data['suggestionByAI'] ?? '',
      completed: data['completed'] ?? false,
    );
  }
  Map<String, dynamic> toJson() => {
    'profile': profile.toJson(),
    'scores': scores.toJson(),
    'buckets': buckets.toJson(),
    'intentTags': intentTags,
    'microtags': microtags,
    'weightages': weightages.toJson(),
    'progressionHint': progressionHint,
    'suggestionByAI': suggestionByAI,
    'completed': completed,
  };

  static OnboardingResult fromJsonString(String jsonStr) =>
      OnboardingResult.fromJson(json.decode(jsonStr));

  String toJsonString() => json.encode(toJson());
}

class Profile {
  final String key;
  final String label;
  final String hint;

  Profile({required this.key, required this.label, required this.hint});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      key: json['key'] ?? '',
      label: json['label'] ?? '',
      hint: json['hint'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'key': key, 'label': label, 'hint': hint};
}

class Scores {
  final double? motivation;
  final double? accountability;
  final double? followThrough;

  Scores({
    required this.motivation,
    required this.accountability,
    required this.followThrough,
  });

  factory Scores.fromJson(Map<String, dynamic> json) {
    return Scores(
      motivation: (json['motivation'] as num?)?.toDouble(),
      accountability: (json['accountability'] as num?)?.toDouble(),
      followThrough: (json['followThrough'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'motivation': motivation,
    'accountability': accountability,
    'followThrough': followThrough,
  };
}

class Buckets {
  final String motivationType;
  final String accountabilityType;
  final String followThroughType;

  Buckets({
    required this.motivationType,
    required this.accountabilityType,
    required this.followThroughType,
  });

  factory Buckets.fromJson(Map<String, dynamic> json) {
    return Buckets(
      motivationType: json['motivationType'] ?? '',
      accountabilityType: json['accountabilityType'] ?? '',
      followThroughType: json['followThroughType'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'motivationType': motivationType,
    'accountabilityType': accountabilityType,
    'followThroughType': followThroughType,
  };
}

class Weightages {
  final List<WeightageItem> q2;
  final List<WeightageItem> q3Who;
  final List<WeightageItem> q4Obstacle;
  final List<WeightageItem> q5Accountability;

  Weightages({
    required this.q2,
    required this.q3Who,
    required this.q4Obstacle,
    required this.q5Accountability,
  });

  factory Weightages.fromJson(Map<String, dynamic> json) {
    return Weightages(
      q2:
          (json['q2'] as List<dynamic>?)
              ?.map((e) => WeightageItem.fromJson(e))
              .toList() ??
          [],
      q3Who:
          (json['q3_who'] as List<dynamic>?)
              ?.map((e) => WeightageItem.fromJson(e))
              .toList() ??
          [],
      q4Obstacle:
          (json['q4_obstacle'] as List<dynamic>?)
              ?.map((e) => WeightageItem.fromJson(e))
              .toList() ??
          [],
      q5Accountability:
          (json['q5_accountability'] as List<dynamic>?)
              ?.map((e) => WeightageItem.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'q2': q2.map((e) => e.toJson()).toList(),
    'q3_who': q3Who.map((e) => e.toJson()).toList(),
    'q4_obstacle': q4Obstacle.map((e) => e.toJson()).toList(),
    'q5_accountability': q5Accountability.map((e) => e.toJson()).toList(),
  };
}

class WeightageItem {
  final String answer;
  final double? motivation;
  final double? accountability;
  final double? followThrough;

  WeightageItem({
    required this.answer,
    this.motivation,
    this.accountability,
    this.followThrough,
  });

  factory WeightageItem.fromJson(Map<String, dynamic> json) {
    return WeightageItem(
      answer: (json['answer'] as String?) ?? '',

      motivation: (json['motivation'] as num?)?.toDouble(),
      accountability: (json['accountability'] as num?)?.toDouble(),
      followThrough: (json['followThrough'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'answer': answer,
    if (motivation != null) 'motivation': motivation,
    if (accountability != null) 'accountability': accountability,
    if (followThrough != null) 'followThrough': followThrough,
  };
}
