import 'package:intl/intl.dart';

import '../theming/app_colors.dart';
import 'app_exports.dart';

bool _isLoadingDialogOpen = false;

extension LoadingDialogExt on BuildContext {
  void showLoading() {
    if (_isLoadingDialogOpen) return;
    _isLoadingDialogOpen = true;

    showDialog(
      context: this,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: AppColors.primaryBlackColor),
      ),
    ).then((_) {
      _isLoadingDialogOpen = false; // reset when closed
    });
  }

  void hideLoading() {
    if (_isLoadingDialogOpen &&
        Navigator.of(this, rootNavigator: true).canPop()) {
      Navigator.of(this, rootNavigator: true).pop();
      _isLoadingDialogOpen = false;
    }
  }
}

extension StringExtension on String {
  String get capitalize {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String get capitalizeA {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  String get toTitleCase {
    if (trim().isEmpty) return this;

    return split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .map((word) {
          if (word.length < 2) {
            return word.toUpperCase();
          }
          return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
        })
        .join(' ');
  }
}

extension DateTimeExtension on DateTime {
  String formatDate() {
    return DateFormat('MM/dd/yyyy').format(this);
  }
}

extension DateParsing on String {
  /// Converts a date string in MM/DD/YYYY to ISO 8601 (YYYY-MM-DD)
  String toIsoDate() {
    try {
      final parts = split('/'); // [MM, DD, YYYY]
      if (parts.length != 3) return this; // return original if invalid

      final month = int.parse(parts[0]);
      final day = int.parse(parts[1]);
      final year = int.parse(parts[2]);

      return "${year.toString().padLeft(4, '0')}-"
          "${month.toString().padLeft(2, '0')}-"
          "${day.toString().padLeft(2, '0')}";
    } catch (_) {
      return this; // return original string if parsing fails
    }
  }

  /// Converts MM/DD/YYYY to full ISO 8601 DateTime string with midnight time
  String toIsoDateTime() {
    try {
      final parts = split('/');
      if (parts.length != 3) return this;

      final month = int.parse(parts[0]);
      final day = int.parse(parts[1]);
      final year = int.parse(parts[2]);

      final dt = DateTime(year, month, day);
      return dt.toIso8601String(); // e.g., "2025-11-27T00:00:00.000"
    } catch (_) {
      return this;
    }
  }
}
