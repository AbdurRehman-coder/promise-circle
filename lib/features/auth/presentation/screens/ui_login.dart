// import 'dart:io';
// import 'package:cubix_app/core/utils/app_exports.dart';
//
// import '../../../../core/constants/app_constants.dart' show AppConstants;
//
// class LoginScreen extends ConsumerWidget {
//   const LoginScreen({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final currentIndex = ref.watch(bottomNavIndexProvider);
//     final notifier = ref.read(bottomNavIndexProvider.notifier);
//     return Scaffold(
//       body: LayoutBuilder(
//         builder:
//             (context, constraints) => SingleChildScrollView(
//               child: ConstrainedBox(
//                 constraints: BoxConstraints(minHeight: constraints.maxHeight),
//                 child: IntrinsicHeight(
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: getProportionateScreenWidth(34),
//                       vertical: getProportionateScreenHeight(20),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         Image.asset(
//                           AppAssets.onboardingImage,
//                           fit: BoxFit.fill,
//                         ),
//                         SizedBox(height: getProportionateScreenHeight(45)),
//                         RichText(
//                           textAlign: TextAlign.center,
//                           text: TextSpan(

//                               TextSpan(
//                                 text: 'Any topic. Anytime.',
//                                 style: AppTextStyles.headingTextStyle.copyWith(
//                                   color: AppColors.brownColor,
//                                   height: 40 / 32,
//                                   fontSize: 32,
//                                 ),
//                               ),
//                               TextSpan(
//                                 text: '\nYour way.',
//                                 style: AppTextStyles.headingTextStyle.copyWith(
//                                   color: AppColors.blueColor,
//                                   fontSize: 32,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//
//                         SizedBox(height: getProportionateScreenHeight(65)),
//                         Text(
//                           textAlign: TextAlign.center,
//                           'Sign in to continue with',
//                           style: AppTextStyles.bodyTextStyle.copyWith(
//                             color: AppColors.brownColor,
//                             fontSize: getProportionateScreenHeight(16),
//                             fontWeight: FontWeight.w500,
//                             wordSpacing: 1.4,
//                           ),
//                         ),
//                         SizedBox(height: getProportionateScreenHeight(24)),
//                         if (Platform.isIOS) ...[
//                           PrimaryButton(
//                             text: 'Apple',
//                             icon: SvgPicture.asset(
//                               AppAssets.appleIcon,
//                               fit: BoxFit.scaleDown,
//                             ),
//                             height: getProportionateScreenHeight(56),
//                             onPressed: () async {
//                               if (currentIndex != 0) {
//                                 notifier.state = 0;
//                               }
//                               await locator.get<AuthServices>().handleAppleAuth(
//                                 context,
//                               );
//                             },
//                             textColor: AppColors.blackColor,
//                             backgroundColor: AppColors.whiteColor,
//                           ),
//                           SizedBox(height: getProportionateScreenHeight(12)),
//                         ],
//                         PrimaryButton(
//                           text: 'Google',
//                           height: getProportionateScreenHeight(56),
//                           icon: Padding(
//                             padding: const EdgeInsets.symmetric(
//                               vertical: 4,
//                               horizontal: 8,
//                             ),
//                             child: SvgPicture.asset(
//                               AppAssets.googleIcon,
//                               fit: BoxFit.scaleDown,
//                             ),
//                           ),
//
//                           onPressed: () {
//                             if (currentIndex != 0) {
//                               notifier.state = 0;
//                             }
//                             locator.get<AuthServices>().handleGoogleAuth(
//                               context,
//                             );
//                           },
//                           textColor: AppColors.blackColor,
//                           backgroundColor: AppColors.whiteColor,
//                         ),
//                         SizedBox(height: getProportionateScreenHeight(12)),
//                         Spacer(),
//                         RichText(
//                           textAlign: TextAlign.center,
//                           text: TextSpan(
//                             style: AppTextStyles.bodyTextStyle.copyWith(
//                               color: const Color(0xff8E8E93),
//                               fontSize: 12,
//                               fontWeight: FontWeight.w400,
//                             ),
//                             children: [
//                               const TextSpan(
//                                 text: 'By continuing, you agree to our',
//                               ),
//                               TextSpan(
//                                 text: ' Terms & Conditions',
//                                 style: AppTextStyles.bodyTextStyle.copyWith(
//                                   color: AppColors.blackColor,
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.w400,
//                                   decoration: TextDecoration.underline,
//                                 ),
//                                 recognizer:
//                                     TapGestureRecognizer()
//                                       ..onTap = () async {
//                                         AppUtils.launchLink(
//                                           url:
//                                               AppConstants
//                                                   .termsAndConditionsUrl,
//                                         );
//                                       },
//                               ),
//                               const TextSpan(text: ' and\n'),
//                               TextSpan(
//                                 text: ' Privacy Policy.',
//                                 style: AppTextStyles.bodyTextStyle.copyWith(
//                                   color: AppColors.blackColor,
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.w400,
//                                   decoration: TextDecoration.underline,
//                                 ),
//                                 recognizer:
//                                     TapGestureRecognizer()
//                                       ..onTap = () async {
//                                         AppUtils.launchLink(
//                                           url: AppConstants.privacyPolicyUrl,
//                                         );
//                                       },
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//       ),
//     );
//   }
// }
