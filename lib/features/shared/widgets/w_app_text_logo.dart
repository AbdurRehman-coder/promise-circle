import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sbp_app/core/constants/assets.dart';
import 'package:sbp_app/core/utils/responsive_config.dart';

class AppNameLogo extends StatelessWidget {
  const AppNameLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      Assets.svgAppNameIcon,
      height: 32.h,
      width: 140.w,
      fit: BoxFit.fill,
    );
  }
}
