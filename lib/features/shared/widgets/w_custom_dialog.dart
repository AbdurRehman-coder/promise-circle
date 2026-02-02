// import 'package:flutter_svg/svg.dart';
// import 'package:sbp_app/core/constants/assets.dart';
// import 'package:sbp_app/features/shared/widgets/w_primary_button.dart';
// import '../../../core/constants/app_assets.dart';
// import '../../../core/theming/app_colors.dart';
// import '../../../core/utils/app_exports.dart';
// import '../../../core/utils/text_styles.dart';

// class CustomDialog extends StatelessWidget {
//   final String title;
//   final Widget? icon;
//   final String description;
//   final String buttonText;
//   final bool showBackIcon;
//   final VoidCallback onPressed;

//   const CustomDialog({
//     super.key,
//     required this.title,
//     this.icon,
//     required this.description,
//     required this.buttonText,
//     required this.onPressed,
//     this.showBackIcon = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       backgroundColor: AppColors.whiteColor,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       insetPadding: const EdgeInsets.symmetric(horizontal: 28),
//       child: Padding(
//         padding: const EdgeInsets.all(25),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             icon ??
//                 Center(
//                   child: SvgPicture.asset(
//                     Assets.,
//                     height: 88,
//                     width: 92,
//                     colorFilter: ColorFilter.mode(
//                       AppColors.primaryBlackColor,
//                       BlendMode.srcIn,
//                     ),
//                   ),
//                 ),
//             const SizedBox(height: 24),
//             Text(
//               title,
//               style: AppTextStyles.bodyTextStyle.copyWith(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.blackColor,
//                 wordSpacing: 1.5,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 18),

//             Text(
//               description,
//               style: AppTextStyles.bodyTextStyle.copyWith(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w400,
//                 color: const Color(0xff47474A),
//                 height: 30 / 18,
//                 wordSpacing: 1.5,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 28),

//             PrimaryButton(text: buttonText, onPressed: onPressed),
//             if (showBackIcon) ...[
//               const SizedBox(height: 12),
//               TextButton(
//                 style: TextButton.styleFrom(
//                   minimumSize: Size(double.infinity, 48),
//                 ),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 child: Text(
//                   'Cancel',
//                   style: AppTextStyles.bodyTextStyle.copyWith(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.blackColor,
//                     height: 22 / 16,
//                   ),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }
