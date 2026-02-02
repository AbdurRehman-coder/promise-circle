import 'package:dio/dio.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:sbp_app/core/utils/api_exception.dart';
import 'package:sbp_app/features/auth/models/app_setting.dart';
import 'package:sbp_app/features/auth/models/auth_response_model.dart';
import 'package:sbp_app/features/auth/models/sign_up_request_model.dart';
import '../../../core/services/api_client.dart';
import '../models/subscription_data_model.dart';
import '../models/user_model.dart';

class AuthServices {
  final ApiClient apiClient;

  AuthServices(this.apiClient);

  Future<bool> signup(
    SignUpRequestModel signUpRequestModel, {
    String? fcmToken,
  }) async {
    try {
      final data = signUpRequestModel.toJson();
      if (fcmToken != null) {
        data['fcmToken'] = fcmToken;
      }

      final res = await apiClient.dio.post("/auth/signup", data: data);
      if (_isSuccess(res)) {
        return true;
      }
      return false;
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<AuthResponse?> verifyEmail(String email, String code) async {
    try {
      final res = await apiClient.dio.patch(
        "/auth/verify",
        data: {"email": email, "emailVerificationCode": code},
      );
      if (_isSuccess(res)) {
        return AuthResponse.fromJson(res.data);
      }
      return null;
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<AuthResponse?> login(
    String email,
    String password, {
    String? fcmToken,
  }) async {
    try {
      final res = await apiClient.dio.post(
        "/auth/login",
        data: {
          "email": email,
          "password": password,
          if (fcmToken != null) "fcmToken": fcmToken,
        },
      );
      if (_isSuccess(res)) {
        return AuthResponse.fromJson(res.data);
      }
      return null;
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<User?> requestBasicInfo(User user) async {
    try {
      final Map<String, dynamic> requestData = Map<String, dynamic>.from(
        user.toJson(),
      );

      if (requestData['timezoneRegion'] == null) {
        try {
          final String systemTimezone =
              await FlutterTimezone.getLocalTimezone();
          requestData['timezoneRegion'] = systemTimezone;
        } catch (_) {
          requestData['timezoneRegion'] = 'UTC';
        }
      }

      requestData.putIfAbsent(
        'timezone',
        () => DateTime.now().toUtc().toIso8601String(),
      );
      final res = await apiClient.dio.patch("/user", data: user.toJson());

      if (_isSuccess(res)) {
        final data = res.data['data'];
        return User.fromJson(data);
      }
      return null;
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<User?> getCurrentUser(String id) async {
    try {
      final res = await apiClient.dio.get("/user/$id");
      if (res.statusCode == 200) {
        return User.fromJson(res.data['data']);
      }
      return null;
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<bool> forgotPassword(String email) async {
    try {
      final res = await apiClient.dio.post(
        "/auth/forgot",
        data: {"email": email},
      );
      return _isSuccess(res);
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<bool> verifyResetCode(String email, String code) async {
    try {
      final res = await apiClient.dio.post(
        "/auth/verify-code",
        data: {"email": email, "emailVerificationCode": code},
      );
      return _isSuccess(res);
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<bool> resendVerificationCode(String email) async {
    try {
      final res = await apiClient.dio.post(
        "/auth/resend-verification",
        data: {"email": email},
      );
      return _isSuccess(res);
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<bool> resetPassword(
    String email,
    String newPassword,
    String confirmPassword,
    String passwordResetCode,
  ) async {
    try {
      final res = await apiClient.dio.post(
        "/auth/reset",
        data: {
          "email": email,
          "newPassword": newPassword,
          "confirmPassword": confirmPassword,
          "passwordResetCode": passwordResetCode,
        },
      );
      return _isSuccess(res);
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<AuthResponse?> googleSignIn(
    String idToken,
    String inviteCode, {
    String? fcmToken,
  }) async {
    try {
      final res = await apiClient.dio.post(
        "/auth/google-signin",
        data: {
          "idToken": idToken,
          "role": "user",
          "inviteCode": inviteCode,
          if (fcmToken != null) "fcmToken": fcmToken,
        },
      );
      if (_isSuccess(res)) {
        return AuthResponse.fromJson(res.data);
      }
      return null;
    } catch (e) {
      print(e);
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<AuthResponse?> appleSignIn(
    String identityToken,
    String userIdentifier,
    String fcmToken,
    String inviteCode,
  ) async {
    try {
      final res = await apiClient.dio.post(
        "/auth/apple-signin",
        data: {
          "identityToken": identityToken,
          "userIdentifier": userIdentifier,
          "role": "user",
          "fcmToken": fcmToken,
          "inviteCode": inviteCode,
        },
      );
      if (_isSuccess(res)) {
        return AuthResponse.fromJson(res.data);
      }
      return null;
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  bool _isSuccess(Response res) {
    return (res.statusCode == 200 || res.statusCode == 201) && res.data != null;
  }

  Future<SubscriptionData?> getUserSubscription() async {
    try {
      final res = await apiClient.dio.get("/subscription/active");

      if (_isSuccess(res)) {
        if (res.data['data'] != null) {
          return SubscriptionData.fromJson(res.data['data']);
        }
        return null;
      }
      return null;
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<AppSettingsResponse?> getUserAppSetting() async {
    try {
      final res = await apiClient.dio.get("/subscription/settings");

      if (_isSuccess(res)) {
        if (res.data['data'] != null) {
          return AppSettingsResponse.fromJson(res.data);
        }
        return null;
      }
      return null;
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }
}
