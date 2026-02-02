import 'package:dio/dio.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:sbp_app/core/services/shared_prefs_services.dart';

import 'app_services.dart';

class ApiClient {
  late final Dio dio;
  late final SharedPrefServices prefs;

  ApiClient() : dio = Dio() {
    prefs = locator<SharedPrefServices>();

    dio.options
      // ..baseUrl = "http://174.138.93.70/v1/"
      ..baseUrl = "https://api.stopbreakingpromises.com/v1/"
      ..connectTimeout = const Duration(milliseconds: 1200000)
      ..receiveTimeout = const Duration(milliseconds: 1200000)
      ..responseType = ResponseType.json;

    dio.interceptors.addAll([
      _AuthInterceptor(prefs),
      _TokenRefreshInterceptor(dio, prefs),
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    ]);
  }
}

class _AuthInterceptor extends Interceptor {
  final SharedPrefServices prefs;
  _AuthInterceptor(this.prefs);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final user = await prefs.getLoggedUser();
    if (user?.accessToken != null && user!.accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer ${user.accessToken}';
    }
    return handler.next(options);
  }
}

class _TokenRefreshInterceptor extends QueuedInterceptor {
  final Dio dio;
  final SharedPrefServices prefs;

  _TokenRefreshInterceptor(this.dio, this.prefs);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final user = await prefs.getLoggedUser();

      if (user != null && user.refreshToken.isNotEmpty) {
        try {
          final response = await _refresh(user.refreshToken);

          if (response.statusCode == 200 || response.statusCode == 201) {
            final data = response.data['data'] ?? response.data;
            final newAccessToken = data['accessToken'] ?? data['token'];
            final newRefreshToken = data['refreshToken'] ?? user.refreshToken;

            user.accessToken = newAccessToken;
            user.refreshToken = newRefreshToken;
            await prefs.saveLoggedUser(user);

            final options = err.requestOptions;
            options.headers['Authorization'] = 'Bearer $newAccessToken';

            final retryResponse = await dio.fetch(options);
            return handler.resolve(retryResponse);
          }
        } catch (e) {
          await prefs.clearUserData();
          return handler.next(err);
        }
      }
    }
    return handler.next(err);
  }

  Future<Response> _refresh(String refreshToken) async {
    final refreshDio = Dio(
      BaseOptions(
        baseUrl: dio.options.baseUrl,
        connectTimeout: const Duration(seconds: 30),
      ),
    );

    // final fcmToken = await FirebaseMessaging.instance.getToken();
    const fcmToken = '';

    return await refreshDio.post(
      'auth/refresh',
      data: {"token": refreshToken, "fcmToken": fcmToken},
    );
  }
}
