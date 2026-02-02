class OnboardingAnswers {
  final List<IntentAnswer> q1;
  final List<String> q2;
  final List<String> q3Who;
  final List<String> q4Obstacle;
  final List<String> q5Accountability;

  OnboardingAnswers({
    required this.q1,
    required this.q2,
    required this.q3Who,
    required this.q4Obstacle,
    required this.q5Accountability,
  });

  factory OnboardingAnswers.fromJson(Map<String, dynamic> json) {
    return OnboardingAnswers(
      q1: (json['q1'] as List<dynamic>)
          .map((i) => IntentAnswer.fromJson(i as Map<String, dynamic>))
          .toList(),

      q2: List<String>.from(json['q2']),
      q3Who: List<String>.from(json['q3_who']),
      q4Obstacle: List<String>.from(json['q4_obstacle']),
      q5Accountability: List<String>.from(json['q5_accountability']),
    );
  }

  Map<String, dynamic> toJson() => {
    "q1": q1.map((i) => i.toJson()).toList(),
    "q2": q2,
    "q3_who": q3Who,
    "q4_obstacle": q4Obstacle,
    "q5_accountability": q5Accountability,
  };
}

class IntentAnswer {
  final String intent;
  final List<String> microtags;

  IntentAnswer({required this.intent, required this.microtags});

  factory IntentAnswer.fromJson(Map<String, dynamic> json) {
    return IntentAnswer(
      intent: json['intent'] as String,
      microtags: List<String>.from(json['microtags']),
    );
  }

  Map<String, dynamic> toJson() => {"intent": intent, "microtags": microtags};
}
