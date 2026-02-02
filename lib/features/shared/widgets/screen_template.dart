import 'package:flutter/material.dart';
import 'package:sbp_app/core/utils/responsive_config.dart';
import 'package:sbp_app/features/shared/widgets/w_app_text_logo.dart';
import '../../../core/utils/app_exports.dart';
import 'w_app_safe_area.dart';

class ScreenTemplate extends StatelessWidget {
  const ScreenTemplate({super.key, this.widget});
  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppSafeArea(
        child: Column(
          children: [
            SizedBox(height: 36.h),
            AppNameLogo(),
            SizedBox(height: 42.h),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 20.h, left: 20.w, right: 20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  // boxShadow: const [
                  //   BoxShadow(
                  //     color: Colors.grey,
                  //     offset: Offset(0.0, 1.0),
                  //     blurRadius: 6.0,
                  //   ),
                  // ],
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: IntrinsicHeight(child: widget),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
