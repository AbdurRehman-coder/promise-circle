// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:sbp_app/core/widgets/w_app_text_logo.dart';
// import 'package:sbp_app/core/widgets/w_primary_button.dart';
// import 'package:sbp_app/features/invite/presentation/screens/invite_code_screen.dart';
// import 'package:sbp_app/generated/assets.dart';

// import '../../../../core/utils/app_exports.dart';

// class InviteSplashScreen extends StatelessWidget {
//   const InviteSplashScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: AppSafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(height: 40),
//             AppNameLogo(),
//             Expanded(child: SvgPicture.asset(Assets.earlyAccess)),
//             SizedBox(height: 32),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: PrimaryButton(
//                 text: 'Get Access',
//                 onPressed: () =>
//                     Navigator.pushNamed(context, InviteCodeScreen.routeName),
//                 icon: SvgPicture.asset(
//                   Assets.svgArrowForward,
//                   height: 20,
//                   width: 24,
//                   fit: BoxFit.scaleDown,
//                 ),
//                 iconLeading: false,
//               ),
//             ),
//             SizedBox(height: 34),
//           ],
//         ),
//       ),
//     );
//   }
// }
