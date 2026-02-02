// import 'onboarding_answers.dart';
// import 'onboarding_profile.dart';
// import 'onboarding_scores.dart' show OnboardingScores;

// class OnboardingHistory {
//   final DateTime? completedAt;
//   final OnboardingAnswers? answers;
//   final OnboardingScores? scores;
//   final OnboardingProfile? profile;

//   OnboardingHistory({
//     this.completedAt,
//     this.answers,
//     this.scores,
//     this.profile,
//   });

//   factory OnboardingHistory.fromJson(Map<String, dynamic> json) {
//     return OnboardingHistory(
//       completedAt: json['completedAt'] != null
//           ? DateTime.tryParse(json['completedAt'] as String)
//           : null,
//       answers: json['answers'] != null
//           ? OnboardingAnswers.fromJson(json['answers'] as Map<String, dynamic>)
//           : null,
//       scores: json['scores'] != null
//           ? OnboardingScores.fromJson(json['scores'] as Map<String, dynamic>)
//           : null,
//       profile: json['profile'] != null
//           ? OnboardingProfile.fromJson(json['profile'] as Map<String, dynamic>)
//           : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'completedAt': completedAt?.toIso8601String(),
//       'answers': answers?.toJson(),
//       'scores': scores?.toJson(),
//       'profile': profile?.toJson(),
//     };
//   }
// }
