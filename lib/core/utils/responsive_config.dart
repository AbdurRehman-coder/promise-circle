import 'package:flutter/material.dart';
import 'dart:math';

/// Production-ready Responsive Layout Engine
/// Handles scaling across Mobile, Tablet, and Desktop while maintaining aspect ratios.
class ResponsiveLayout {
  static late double screenWidth;
  static late double screenHeight;
  static late double _scaleFactor;
  static late double _textScaleFactor;

  // Constants based on your provided design specs
  static const double _designWidth = 395;
  static const double _designHeight = 855;

  // Breakpoints for adaptive logic
  static const double _tabletBreakpoint = 600;

  static void init(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    screenWidth = mediaQuery.size.width;
    screenHeight = mediaQuery.size.height;

    // Calculate base scale
    double widthScale = screenWidth / _designWidth;
    double heightScale = screenHeight / _designHeight;

    // Logic: Use the smaller scale to ensure content fits both dimensions
    // For Tablets, we dampen the scale factor to prevent UI elements from becoming massive.
    if (screenWidth >= _tabletBreakpoint) {
      // Tablet Logic: Clamp scaling to prevent oversized elements
      _scaleFactor = min(widthScale, heightScale) * 0.85;
      _textScaleFactor = min(widthScale, 1.2); // Cap text growth
    } else {
      // Mobile Logic: Standard linear scaling
      _scaleFactor = widthScale;
      _textScaleFactor = widthScale;
    }
  }

  static double get scaleWidth => _scaleFactor;
  static double get scaleHeight =>
      _scaleFactor; // Using uniform scaling for better UX
  static double get textScale => _textScaleFactor;
  static double get radiusScale => _scaleFactor;
}

extension SizeExtension on num {
  /// Scales width and maintain aspect ratio
  double get w => this * ResponsiveLayout.scaleWidth;

  /// Scales height and maintain aspect ratio
  double get h => this * ResponsiveLayout.scaleHeight;

  /// Scales font size with a cap for readability on large screens
  double get sp => this * ResponsiveLayout.textScale;

  /// Scales radius for containers and buttons
  double get r => this * ResponsiveLayout.radiusScale;
}
