// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:sbp_app/core/theming/app_colors.dart';
// import 'package:sbp_app/core/utils/text_styles.dart';
// import 'package:sbp_app/features/promise/provider/promise_provider.dart';

// /// Privacy settings step widget
// class PrivacyStep extends ConsumerWidget {
//   const PrivacyStep({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final controller = ref.watch(promiseControllerProvider.notifier);
//     final privacyData = ref.watch(promiseControllerProvider)[7] ?? {};
//     final isPrivate = privacyData['isPrivate'] as bool? ?? true;
//     final openToJoin = privacyData['openToJoin'] as bool? ?? false;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Privacy Settings',
//           textAlign: TextAlign.center,
//           style: AppTextStyles.headingTextStyleBogart,
//         ),
//         const SizedBox(height: 32),
//         Text(
//           'Choose how you want to share your promise',
//           style: AppTextStyles.bodyTextStyle.copyWith(
//             fontSize: 14,
//             color: AppColors.primaryBlackColor.withValues(alpha: 0.8),
//             fontWeight: FontWeight.w400,
//           ),
//         ),
//         const SizedBox(height: 24),
        
//         // Private Toggle
//         Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: AppColors.whiteColor,
//             borderRadius: BorderRadius.circular(20),
//             border: Border.all(color: AppColors.grey200Color),
//           ),
//           child: Row(
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Keep Private',
//                       style: AppTextStyles.bodyTextStyle.copyWith(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       'Only you can see this promise',
//                       style: AppTextStyles.bodyTextStyle.copyWith(
//                         fontSize: 14,
//                         color: AppColors.primaryBlackColor.withValues(alpha: 0.6),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Switch(
//                 value: isPrivate,
//                 onChanged: (value) {
//                   controller.togglePrivacy('isPrivate', value);
//                 },
//                 activeColor: AppColors.secondaryBlueColor,
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 16),
        
//         // Open to Join Toggle
//         Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: AppColors.whiteColor,
//             borderRadius: BorderRadius.circular(20),
//             border: Border.all(color: AppColors.grey200Color),
//           ),
//           child: Row(
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Open to Join',
//                       style: AppTextStyles.bodyTextStyle.copyWith(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       'Others can join you in this promise',
//                       style: AppTextStyles.bodyTextStyle.copyWith(
//                         fontSize: 14,
//                         color: AppColors.primaryBlackColor.withValues(alpha: 0.6),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Switch(
//                 value: openToJoin,
//                 onChanged: (value) {
//                   controller.togglePrivacy('openToJoin', value);
//                 },
//                 activeColor: AppColors.secondaryBlueColor,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

