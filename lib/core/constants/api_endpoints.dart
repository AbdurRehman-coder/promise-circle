class ApiEndpoints {
  static String get signup => 'auth/signup';

  static String get verifyEmail => 'auth/verify';

  static String get resendVerifyEmail => 'auth/resend-verification';

  static String get verifyCode => 'auth/verify-code';

  static String get invite => 'auth/invite';

  static String get login => 'auth/login';

  static String get allPromisesOfUser => 'promises/user';

  static String get promise => "/promises";

  static String updatePromise(String promiseId) => "/promises/$promiseId";
}
