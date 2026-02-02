// // ignore_for_file: use_build_context_synchronously
//
// import '../../../app.dart';
//
// class AppleSocialButton extends StatelessWidget {
//   const AppleSocialButton({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<LoginCubit, LoginState>(
//       listener: (context, state) {
//         if (state.isSuccess &&
//             state.isAppleSignInOperation &&
//             !state.requiresProfileUpdate) {
//           // AppToasts.success(
//           //   message: state.message ?? 'Apple sign-in successful!',
//           //   context: context,
//           // );
//           context.goNamed(BottomNavRoutes.bottomNav);
//         } else if (state.isFailure &&
//             state.isAppleSignInOperation &&
//             state.errorMessage != null &&
//             !state.requiresReactivation &&
//             state.reactivationErrorMessage != null) {
//           context.read<LoginCubit>().reset();
//           context.pop();
//           AppToasts.error(message: state.errorMessage!, context: context);
//         } else if (state.requiresReactivation &&
//             state.reactivationData != null) {
//           _showReactivationDialog(
//             context,
//             state.reactivationData!,
//             state.isLoading && state.isAppleSignInOperation,
//           );
//         } else if (state.requiresProfileUpdate && !state.isLoading) {
//           // context.read<LoginCubit>().reset();
//           context.pop();
//           _showProfileUpdateDialog(context);
//         }
//       },
//       child: BlocBuilder<LoginCubit, LoginState>(
//         builder: (context, state) {
//           final isLoading = state.isLoading && state.isAppleSignInOperation;
//
//           return GestureDetector(
//             onTap: isLoading ? null : () => _handleAppleSignIn(context),
//             child: Container(
//               height: 48,
//               decoration: BoxDecoration(
//                 color: AppColors.black,
//                 borderRadius: BorderRadius.circular(
//                   AppSpacing.inputBorderRadius,
//                 ),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   if (isLoading)
//                     const SpinKitDualRing(color: AppColors.white, size: 30.0),
//                   if (!isLoading)
//                     const Icon(Icons.apple, color: AppColors.white, size: 22),
//                   HSpacing.sm(),
//                   AppText.small(
//                     text: 'Continue with Apple',
//                     color: AppColors.white,
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   void _handleAppleSignIn(BuildContext context) {
//     final loginCubit = context.read<LoginCubit>();
//     loginCubit.performAppleSignIn();
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
