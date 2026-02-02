import 'package:flutter/material.dart';
import 'package:flashy_flushbar/flashy_flushbar.dart';

class FlashMessage {
  FlashMessage._();

  static void showError(BuildContext context, String message) {
    FlashyFlushbar(
      leadingWidget: const Icon(
        Icons.error_outline,
        color: Colors.black,
        size: 24,
      ),
      message: message,
      duration: const Duration(seconds: 2),
      trailingWidget: IconButton(
        icon: const Icon(Icons.close, color: Colors.black, size: 24),
        onPressed: () {
          FlashyFlushbar.cancel();
        },
      ),
      isDismissible: false,
    ).show();
  }

  static void showSuccess(BuildContext context, String message) {
    FlashyFlushbar(
      leadingWidget: const Icon(
        Icons.check_circle_outline,
        color: Colors.black,
        size: 24,
      ),

      message: message,
      duration: const Duration(seconds: 2),
      trailingWidget: IconButton(
        icon: const Icon(Icons.close, color: Colors.black, size: 24),
        onPressed: () {
          FlashyFlushbar.cancel();
        },
      ),
      isDismissible: true,
    ).show();
  }
}
