import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sbp_app/core/utils/responsive_config.dart';

class BottomHeightWidget extends StatelessWidget {
  const BottomHeightWidget({super.key, this.androidHeight, this.iOSHeight});
  final double? androidHeight;
  final double? iOSHeight;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Platform.isAndroid ? androidHeight ?? 32.h : iOSHeight ?? 32.h,
    );
  }
}
