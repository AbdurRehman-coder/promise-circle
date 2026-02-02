/// Simple PhoneNumber model for phone validation
class PhoneNumber {
  final String? isoCode;
  final String? dialCode;
  final String? phoneNumber;

  const PhoneNumber({this.isoCode, this.dialCode, this.phoneNumber});

  @override
  String toString() {
    return phoneNumber ?? '';
  }

  /// Get the complete phone number with country code
  String get completeNumber {
    final phone = phoneNumber;
    final dial = dialCode;

    if (phone == null || phone.isEmpty) return '';

    // If phoneNumber already starts with dialCode, return as is
    if (dial != null && phone.startsWith(dial)) {
      return phone;
    }

    // If phoneNumber doesn't start with dialCode, prepend it
    if (dial != null && !phone.startsWith(dial)) {
      return '$dial$phone';
    }

    return phone;
  }

  /// Get just the national number (without country code)
  String get nationalNumber {
    final phone = phoneNumber;
    final dial = dialCode;

    if (phone == null || phone.isEmpty) return '';
    if (dial != null && phone.startsWith(dial)) {
      return phone.substring(dial.length);
    }
    return phone;
  }

  PhoneNumber copyWith({
    String? isoCode,
    String? dialCode,
    String? phoneNumber,
  }) {
    return PhoneNumber(
      isoCode: isoCode ?? this.isoCode,
      dialCode: dialCode ?? this.dialCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}