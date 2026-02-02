import 'package:flutter/material.dart';

class AppAnimations {
  static const bool areAnimationsEnabled = true;

  static Widget navigationTransition(
    Animation<double> animation,
    Widget child,
  ) => defaultTransition(animation, child);

  static Widget executiveSlide(Animation<double> animation, Widget child) {
    if (!areAnimationsEnabled) return child;

    const curve = Curves.fastOutSlowIn;

    var slideTween = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    );

    var fadeTween = Tween<double>(begin: 0.0, end: 1.0);

    return SlideTransition(
      position: slideTween.animate(
        CurvedAnimation(parent: animation, curve: curve),
      ),
      child: FadeTransition(
        opacity: fadeTween.animate(
          CurvedAnimation(parent: animation, curve: const Interval(0.0, 0.5)),
        ),
        child: child,
      ),
    );
  }

  static Widget defaultTransition(Animation<double> animation, Widget child) {
    if (!areAnimationsEnabled) return child;

    const curve = Curves.easeOutExpo;

    var slideTween = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    );

    return SlideTransition(
      position: slideTween.animate(
        CurvedAnimation(parent: animation, curve: curve),
      ),
      child: child,
    );
  }

  static Widget modernZoom(Animation<double> animation, Widget child) {
    if (!areAnimationsEnabled) return child;

    const curve = Curves.easeOutQuart;

    final scaleAnimation = Tween<double>(
      begin: 0.92,
      end: 1.0,
    ).animate(CurvedAnimation(parent: animation, curve: curve));

    final fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeIn));

    return FadeTransition(
      opacity: fadeAnimation,
      child: ScaleTransition(scale: scaleAnimation, child: child),
    );
  }

  static Widget editorialLift(Animation<double> animation, Widget child) {
    if (!areAnimationsEnabled) return child;

    const curve = Curves.easeOutCubic;

    var slideTween = Tween<Offset>(
      begin: const Offset(0.0, 0.15),
      end: Offset.zero,
    );

    var fadeTween = Tween<double>(begin: 0.0, end: 1.0);

    return SlideTransition(
      position: slideTween.animate(
        CurvedAnimation(parent: animation, curve: curve),
      ),
      child: FadeTransition(
        opacity: fadeTween.animate(
          CurvedAnimation(parent: animation, curve: curve),
        ),
        child: child,
      ),
    );
  }

  static Widget softFade(Animation<double> animation, Widget child) {
    if (!areAnimationsEnabled) return child;

    return FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
      child: child,
    );
  }

  static Widget cinematicRise(Animation<double> animation, Widget child) {
    if (!areAnimationsEnabled) return child;

    const curve = Curves.fastLinearToSlowEaseIn;

    final scaleAnimation = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(parent: animation, curve: curve));

    final slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: animation, curve: curve));

    final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animation,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
      ),
    );

    return FadeTransition(
      opacity: fadeAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: ScaleTransition(scale: scaleAnimation, child: child),
      ),
    );
  }

  static Widget switcherTransition(Widget child, Animation<double> animation) {
    if (!areAnimationsEnabled) return child;

    final scaleAnimation = Tween<double>(
      begin: 0.97,
      end: 1.0,
    ).animate(animation);

    final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animation, curve: const Interval(0.2, 1.0)),
    );

    return FadeTransition(
      opacity: fadeAnimation,
      child: ScaleTransition(scale: scaleAnimation, child: child),
    );
  }
}
