// lib/features/auth/utils/validators.dart
import 'package:email_validator/email_validator.dart';

class Validators {
  Validators._();
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    if (!EmailValidator.validate(value.trim())) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Must be at least 8 characters';
    }
    if (!RegExp(r'(?=.*[0-9])(?=.*[!@#\$%^&*(),.?":{}|<>])').hasMatch(value)) {
      return 'Include number & special character';
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) return 'Please confirm password';
    if (value != password) return 'Passwords do not match';
    return null;
  }

  static validateFieldEmpty(String? value, {required String name}) {
    if (value == null || value.trim().isEmpty) {
      return '$name is required';
    }
    return null;
  }

  static validateDob(String? value, {required String name}) {
    String? emptyCheck = validateFieldEmpty(value, name: name);
    if (emptyCheck != null) {
      return emptyCheck;
    }

    try {
      List<String> parts = value!.split('/');
      int month = int.parse(parts[0]);
      int day = int.parse(parts[1]);
      int year = int.parse(parts[2]);

      DateTime dob = DateTime(year, month, day);
      DateTime today = DateTime.now();

      DateTime sixteenYearsAgo = DateTime(
        today.year - 13,
        today.month,
        today.day,
      );

      if (dob.isAfter(sixteenYearsAgo)) {
        return 'You must be 16+ years old';
      }
    } catch (e) {
      return null;
    }

    return null;
  }
}
