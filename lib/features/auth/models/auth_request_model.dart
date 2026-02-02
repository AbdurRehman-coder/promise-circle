class AuthRequestModel {
  final String idToken;
  final String identityToken;
  final String userIdentifier;
  final String firstName;
  final String lastName;
  final String fcmToken;
  final String appVersion;

  AuthRequestModel({
    this.idToken = '',
    this.identityToken = '',
    this.userIdentifier = '',
    this.firstName = '',
    this.lastName = '',
    this.fcmToken = '',
    this.appVersion = '',
  });

  Map<String, dynamic> toJson() {
    return {
      "idToken": idToken,
      "identityToken": identityToken,
      "userIdentifier": userIdentifier,
      "firstName": firstName,
      "lastName": lastName,
      "fcmToken": fcmToken,
      "appVersion": appVersion,
    };
  }
}
