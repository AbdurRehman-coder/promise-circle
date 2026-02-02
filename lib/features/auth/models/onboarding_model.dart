// class OnboardingData {
//   final OnboardingAnswers? answers;
//   final OnboardingScores? scores;
//   final OnboardingBuckets? buckets;
//   final OnboardingWeightages? weightages;

//   const OnboardingData({
//     this.answers,
//     this.scores,
//     this.buckets,
//     this.weightages,
//   });

//   factory OnboardingData.fromJson(Map<String, dynamic>? json) {
//     if (json == null) return const OnboardingData();

//     return OnboardingData(
//       answers: json['answers'] != null
//           ? OnboardingAnswers.fromJson(json['answers'])
//           : null,
//       scores: json['scores'] != null
//           ? OnboardingScores.fromJson(json['scores'])
//           : null,
//       buckets: json['buckets'] != null
//           ? OnboardingBuckets.fromJson(json['buckets'])
//           : null,
//       weightages: json['weightages'] != null
//           ? OnboardingWeightages.fromJson(json['weightages'])
//           : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       "answers": answers?.toJson(),
//       "scores": scores?.toJson(),
//       "buckets": buckets?.toJson(),
//       "weightages": weightages?.toJson(),
//     };
//   }
// }

// class OnboardingAnswers {
//   final List<dynamic>? q1;
//   final List<String>? q2;
//   final List<String>? q3Who;
//   final List<String>? q4Obstacle;
//   final List<String>? q5Accountability;

//   const OnboardingAnswers({
//     this.q1,
//     this.q2,
//     this.q3Who,
//     this.q4Obstacle,
//     this.q5Accountability,
//   });

//   factory OnboardingAnswers.fromJson(Map<String, dynamic> json) {
//     return OnboardingAnswers(
//       q1: json['q1'] != null ? List<dynamic>.from(json['q1']) : null,
//       q2: json['q2'] != null ? List<String>.from(json['q2']) : null,
//       q3Who: json['q3_who'] != null ? List<String>.from(json['q3_who']) : null,
//       q4Obstacle: json['q4_obstacle'] != null
//           ? List<String>.from(json['q4_obstacle'])
//           : null,
//       q5Accountability: json['q3_who'] != null
//           ? List<String>.from(json['q5_accountability'])
//           : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       "q1": q1,
//       "q2": q2,
//       "q3_who": q3Who,
//       "q4_obstacle": q4Obstacle,
//       "q5_accountability": q5Accountability,
//     };
//   }
// }

// class OnboardingScores {
//   final double? motivation;
//   final double? accountability;
//   final double? followThrough;

//   const OnboardingScores({
//     this.motivation,
//     this.accountability,
//     this.followThrough,
//   });

//   factory OnboardingScores.fromJson(Map<String, dynamic> json) {
//     return OnboardingScores(
//       motivation: (json['motivation'] as num?)?.toDouble(),
//       accountability: (json['accountability'] as num?)?.toDouble(),
//       followThrough: (json['followThrough'] as num?)?.toDouble(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       "motivation": motivation,
//       "accountability": accountability,
//       "followThrough": followThrough,
//     };
//   }
// }

// class OnboardingBuckets {
//   final String? motivationType;
//   final String? accountabilityType;
//   final String? followThroughType;

//   const OnboardingBuckets({
//     this.motivationType,
//     this.accountabilityType,
//     this.followThroughType,
//   });

//   factory OnboardingBuckets.fromJson(Map<String, dynamic> json) {
//     return OnboardingBuckets(
//       motivationType: json['motivationType'],
//       accountabilityType: json['accountabilityType'],
//       followThroughType: json['followThroughType'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       "motivationType": motivationType,
//       "accountabilityType": accountabilityType,
//       "followThroughType": followThroughType,
//     };
//   }
// }

// class OnboardingWeightages {
//   final Map<String, dynamic>? q5Accountability;
//   final List<dynamic>? q2;

//   const OnboardingWeightages({this.q5Accountability, this.q2});

//   factory OnboardingWeightages.fromJson(Map<String, dynamic> json) {
//     return OnboardingWeightages(
//       q5Accountability: json['q5_accountability'],
//       q2: json['q2'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {"q5_accountability": q5Accountability, "q2": q2};
//   }
// }
