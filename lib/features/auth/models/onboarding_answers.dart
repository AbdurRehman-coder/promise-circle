// class OnboardingAnswers {
//   final List<QuestionOneAnswer>? q1;
//   final List<String>? q2;
//   final List<String>? q3Who;
//   final List<String>? q4Obstacle;
//   final List<String>? q5Accountability;

//   OnboardingAnswers({
//     this.q1,
//     this.q2,
//     this.q3Who,
//     this.q4Obstacle,
//     this.q5Accountability,
//   });

//   factory OnboardingAnswers.fromJson(Map<String, dynamic> json) {
//     return OnboardingAnswers(
//       q1: (json['q1'] as List?)
//           ?.map((e) => QuestionOneAnswer.fromJson(e as Map<String, dynamic>))
//           .toList(),
//       q2: (json['q2'] as List?)?.map((e) => e.toString()).toList(),
//       q3Who: (json['q3_who'] as List?)?.map((e) => e.toString()).toList(),
//       q4Obstacle: (json['q4_obstacle'] as List?)
//           ?.map((e) => e.toString())
//           .toList(),
//       q5Accountability: (json['q5_accountability'] as List)
//           .map((e) => e.toString())
//           .toList(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'q1': q1?.map((e) => e.toJson()).toList(),
//       'q2': q2,
//       'q3_who': q3Who,
//       'q4_obstacle': q4Obstacle,
//       'q5_accountability': q5Accountability,
//     };
//   }
// }

// class QuestionOneAnswer {
//   final String? id;
//   final String? intent;
//   final List<String>? microtags;

//   QuestionOneAnswer({this.id, this.intent, this.microtags});

//   factory QuestionOneAnswer.fromJson(Map<String, dynamic> json) {
//     return QuestionOneAnswer(
//       id: json['_id'] as String?,
//       intent: json['intent'] as String?,
//       microtags: (json['microtags'] as List?)
//           ?.map((e) => e.toString())
//           .toList(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {'_id': id, 'intent': intent, 'microtags': microtags};
//   }
// }
