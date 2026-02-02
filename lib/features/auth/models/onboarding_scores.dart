// class OnboardingScores {
//   final double? motivation;
//   final double? accountability;
//   final double? followThrough;

//   OnboardingScores({this.motivation, this.accountability, this.followThrough});

//   factory OnboardingScores.fromJson(Map<String, dynamic> json) {
//     return OnboardingScores(
//       motivation: (json['motivation'] as num?)?.toDouble(),
//       accountability: (json['accountability'] as num?)?.toDouble(),
//       followThrough: (json['followThrough'] as num?)?.toDouble(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'motivation': motivation,
//       'accountability': accountability,
//       'followThrough': followThrough,
//     };
//   }
// }
