import 'package:flutter/material.dart';

class StaggeredItem extends StatelessWidget {
  final Widget child;
  final int index;
  final AnimationController animationController;

  const StaggeredItem({
    super.key,
    required this.child,
    required this.index,
    required this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        final double delay = index * 0.15;
        final double start = delay.clamp(0.0, 0.8);
        final double end = (start + 0.5).clamp(0.0, 1.0);

        final curve = CurvedAnimation(
          parent: animationController,
          curve: Interval(start, end, curve: Curves.easeOutQuart),
        );

        return Opacity(
          opacity: curve.value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - curve.value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}