class SignUpRequestModel {
  final String email;
  final String password;

  final String role;

  final String inviteCode;

  SignUpRequestModel({
    this.email = '',
    this.password = '',

    this.role = '',
    this.inviteCode = '',
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
      "role": role,
      "inviteCode": inviteCode,
    };
  }
}
