//
//
// import '../../../../core/utils/app_exports.dart';
//
// class GoogleSocialButton extends StatelessWidget {
//   const GoogleSocialButton({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: isLoading ? null : () => _handleGoogleSignIn(context),
//       child: Container(
//         height: 48,
//         decoration: BoxDecoration(
//           color: AppColors.white,
//           borderRadius: BorderRadius.circular(
//             AppSpacing.inputBorderRadius,
//           ),
//           border: Border.all(color: AppColors.borderLight),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             if (isLoading)
//               const SpinKitDualRing(color: AppColors.primary, size: 30.0),
//             if (!isLoading)
//               AppImageProvider.localAsset(
//                 path: AppAssets.googleLogo,
//                 width: 20,
//                 height: 20,
//               ),
//             HSpacing.sm(),
//             AppText.small(
//               text: AppStrings.continueWithGoogle,
//               color: AppColors.textPrimary,
//             ),
//           ],
//         ),
//       ),
//     )
//   }
//
//   void _handleGoogleSignIn(BuildContext context) {
//
//   }
//
//   void _showReactivationDialog(
//     BuildContext context,
//     ReactivationData data,
//     bool isLoading,
//   ) {
//     ConfirmationDialog.show(
//       context,
//       title: 'Account Reactivation Required',
//       description:
//           'Your account has been deactivated. Would you like to reactivate it and continue signing in?',
//       confirmText: 'Reactivate',
//       cancelText: 'Cancel',
//       confirmButtonColor: AppColors.primary,
//       onConfirm: () {
//         // User confirmed - proceed with reactivation
//         context.read<LoginCubit>().confirmReactivation();
//       },
//       onCancel: () {
//         // User cancelled - cancel reactivation
//         context.read<LoginCubit>().cancelReactivation();
//       },
//       isLoading: isLoading,
//     );
//   }
//
//   void _showProfileUpdateDialog(BuildContext context) {
//     ConfirmationDialog.show(
//       barrierDismissible: false,
//       context,
//       title: 'Profile Update Required',
//       description:
//           'Your account has been reactivated successfully! However, your profile information (name, etc.) was deleted. Please go to your profile and update your personal details.',
//       confirmText: 'Profile',
//       cancelText: 'Skip',
//       confirmButtonColor: AppColors.primary,
//       onConfirm: () {
//         // User confirmed - navigate to profile page
//         context.read<LoginCubit>().confirmProfileUpdate();
//         context.goNamed(BottomNavRoutes.bottomNav, extra: 4);
//       },
//       onCancel: () {
//         // User cancelled - skip profile update
//         context.read<LoginCubit>().cancelProfileUpdate();
//         context.goNamed(BottomNavRoutes.bottomNav);
//       },
//       isLoading: false,
//     );
//   }
// }
