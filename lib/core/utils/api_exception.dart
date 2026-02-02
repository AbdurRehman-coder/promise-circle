import 'dart:io';
import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

class ApiErrorHandler {
  static ApiException handle(dynamic error) {
    String errorDescription = "";

    if (error is DioException) {
      
      switch (error.type) {
        case DioExceptionType.cancel:
          errorDescription = "Request to server was cancelled";
          break;
        case DioExceptionType.connectionTimeout:
          errorDescription = "Connection timeout with server";
          break;
        case DioExceptionType.receiveTimeout:
          errorDescription = "Receive timeout in connection with server";
          break;
        case DioExceptionType.sendTimeout:
          errorDescription = "Send timeout in connection with server";
          break;
        case DioExceptionType.badCertificate:
          errorDescription = "Bad certificate encountered";
          break;
        case DioExceptionType.connectionError:
          errorDescription = "No internet connection. Please check your network.";
          break;
        case DioExceptionType.badResponse:
          errorDescription = _extractBackendError(error.response);
          break;
        case DioExceptionType.unknown:
          if (error.error is SocketException) {
            errorDescription = "No internet connection";
          } else {
            errorDescription = "Unexpected error occurred";
          }
          break;
      }
    } else {
      errorDescription = "Something went wrong. Please try again.";
    }

    return ApiException(errorDescription);
  }

  static String _extractBackendError(Response? response) {
    try {
      if (response != null && response.data != null) {
        final data = response.data;

        if (data is Map<String, dynamic>) {
          if (data.containsKey('message')) return data['message'].toString();
          if (data.containsKey('error')) return data['error'].toString();
          if (data.containsKey('msg')) return data['msg'].toString();
          if (data.containsKey('errors')) return data['errors'].toString();
        } 
        else if (data is String) {
          return data;
        }
      }
      
      if (response != null) {
        switch (response.statusCode) {
          case 400: return "Bad Request.";
          case 401: return "Unauthorized. Please login again.";
          case 403: return "Access forbidden.";
          case 404: return "Resource not found.";
          case 500: return "Internal server error.";
          case 502: return "Bad gateway.";
          case 503: return "Service unavailable.";
          default: return "Received invalid status code: ${response.statusCode}";
        }
      }
    } catch (e) {
      return "Failed to parse error message";
    }
    return "Unknown error occurred";
  }
}