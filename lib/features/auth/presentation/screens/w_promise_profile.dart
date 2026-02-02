// import 'package:sbp_app/features/shared/widgets/w_shared_promise_profile_card.dart';

// import '../../../../core/utils/app_exports.dart';
// import '../../model/onboarding_result.dart';

// class PromiseProfileCard extends StatelessWidget {
//   final OnboardingResult result;

//   const PromiseProfileCard({super.key, required this.result});

//   @override
//   Widget build(BuildContext context) {
//     final intent = safeList(result.intentTags);
//     final motivation = safeJoinAnswers(result.weightages.q2);
//     final obstacle = safeJoinAnswers(result.weightages.q4Obstacle);
//     final support = safeJoinAnswers(result.weightages.q3Who);

//     final label = result.profile.label;
//     final key = result.profile.key;

//     return SharedPromiseProfileCard(
//       profileLabel: label,
//       profileKey: key,
//       intentText: intent,
//       motivationText: motivation,
//       obstacleText: obstacle,
//       showCelebration: true,
//       supportStyleText: support,
//     );
//   }

//   String safeJoinAnswers(List? list) {
//     if (list == null || list.isEmpty) return 'N/A';
//     return list
//         .map((item) {
//           final text = item.answer?.toString() ?? '';
//           return capitalize(text);
//         })
//         .where((text) => text.isNotEmpty)
//         .join(', ');
//   }

//   String safeList(List<String>? list) {
//     if (list == null || list.isEmpty) return 'N/A';
//     return list.map(capitalize).join(', ');
//   }

//   String capitalize(String text) {
//     if (text.isEmpty) return text;
//     return text[0].toUpperCase() + text.substring(1);
//   }
// }
