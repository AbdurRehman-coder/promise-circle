import 'package:flutter/material.dart';
import 'package:sbp_app/core/utils/app_animations.dart';

class RootScreenTransition extends StatelessWidget {
  final Widget child;

  const RootScreenTransition({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return AppAnimations.navigationTransition(animation, child);
      },
      child: child,
    );
  }
}
