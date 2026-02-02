import 'package:flutter/material.dart';

class SupportOption {
  final String title;
  final String icon;
  final VoidCallback onTap;

  const SupportOption({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}