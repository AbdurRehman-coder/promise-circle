import 'package:flutter/material.dart';

class AppSafeArea extends StatelessWidget {
  final Widget child;
  final bool top;
  final bool bottom;
  final bool left;
  final bool right;
  final Color? color;
  final double minimumTop;

  const AppSafeArea({
    super.key,
    required this.child,
    this.top = true,
    this.bottom = false,
    this.left = true,
    this.right = true,
    this.color,
    this.minimumTop = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(bottom: bottom, top: top, child: child);
  }
}
