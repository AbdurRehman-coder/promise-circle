class InviteVerificationResult {
  final bool? valid;
  // final Profile profile;

  InviteVerificationResult({
    this.valid,
    // required this.profile,
  });

  factory InviteVerificationResult.fromJson(Map<String, dynamic> json) {
    return InviteVerificationResult(
      valid: json['active'] ?? true,

      // profile: Profile.fromJson(json['profile']),
    );
  }
}
