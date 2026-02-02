// import 'package:sbp_app/features/onboarding/model/onboarding_result.dart';

// import 'onboarding_answers.dart';
// import 'onboarding_buckets.dart';
// import 'onboarding_history.dart';
// import 'onboarding_profile.dart';
// import 'onboarding_scores.dart';

// class Onboarding {
//   final OnboardingAnswers? answers;
//   final OnboardingScores? scores;
//   final OnboardingBuckets? buckets;
//   final Weightages? weightages;
//   final OnboardingProfile? profile;
//   final bool? completed;
//   final DateTime? completedAt;
//   final List<String>? intentTags;
//   final List<String>? microtags;
//   final List<OnboardingHistory>? history;
//   final String? progressionHint;

//   Onboarding({
//     this.answers,
//     this.scores,
//     this.buckets,
//     this.weightages,
//     this.profile,
//     this.completed,
//     this.completedAt,
//     this.intentTags,
//     this.microtags,
//     this.history,
//     this.progressionHint,
//   });

//   factory Onboarding.fromJson(Map<String, dynamic> json) {
//     return Onboarding(
//       answers: json['answers'] != null
//           ? OnboardingAnswers.fromJson(json['answers'] as Map<String, dynamic>)
//           : null,
//       scores: json['scores'] != null
//           ? OnboardingScores.fromJson(json['scores'] as Map<String, dynamic>)
//           : null,
//       buckets: json['buckets'] != null
//           ? OnboardingBuckets.fromJson(json['buckets'] as Map<String, dynamic>)
//           : null,
//       weightages: json['weightages'] != null
//           ? Weightages.fromJson(json['weightages'] as Map<String, dynamic>)
//           : null,
//       profile: json['profile'] != null
//           ? OnboardingProfile.fromJson(json['profile'] as Map<String, dynamic>)
//           : null,
//       completed: json['completed'] as bool?,
//       completedAt: json['completedAt'] != null
//           ? DateTime.tryParse(json['completedAt'] as String)
//           : null,
//       intentTags: (json['intentTags'] as List?)
//           ?.map((e) => e.toString())
//           .toList(),
//       microtags: (json['microtags'] as List?)
//           ?.map((e) => e.toString())
//           .toList(),
//       history: (json['history'] as List?)
//           ?.map((e) => OnboardingHistory.fromJson(e as Map<String, dynamic>))
//           .toList(),
//       progressionHint: json['progressionHint'] as String?,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'answers': answers?.toJson(),
//       'scores': scores?.toJson(),
//       'buckets': buckets?.toJson(),
//       'weightages': weightages?.toJson(),
//       'profile': profile?.toJson(),
//       'completed': completed,
//       'completedAt': completedAt?.toIso8601String(),
//       'intentTags': intentTags,
//       'microtags': microtags,
//       'history': history?.map((e) => e.toJson()).toList(),
//       'progressionHint': progressionHint,
//     };
//   }
// }
