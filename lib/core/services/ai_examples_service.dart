import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/ai_example_request_model.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://134.209.173.74',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ),
  );
  dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  return dio;
});

final aiServiceProvider = Provider<AiApiService>((ref) {
  return AiApiService(ref.read(dioProvider));
});

class AiApiService {
  final Dio _dio;
  AiApiService(this._dio);

  Future<dynamic> generateSamplePromise(
    GenerateSamplePromiseRequest request,
  ) async {
    try {
      final response = await _dio.post(
        '/sample-promise',
        data: request.toJson(),
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<dynamic> generatePromiseFromBroken(
    GeneratePromiseFromBrokenRequest request,
  ) async {
    try {
      final response = await _dio.post(
        '/promise-from-broken',
        data: request.toJson(),
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<dynamic> generatePromiseReason(
    GeneratePromiseReasonRequest request,
  ) async {
    try {
      final response = await _dio.post(
        '/promise-reason',
        data: request.toJson(),
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<dynamic> generateBreakCost(GenerateBreakCostRequest request) async {
    try {
      final response = await _dio.post(
        '/promise-break-cost',
        data: request.toJson(),
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<dynamic> transformBrokenPromises(
    TransformBrokenPromisesRequest request,
  ) async {
    try {
      final response = await _dio.post(
        '/transform-broken-promises',
        data: request.toJson(),
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<dynamic> generateBrokenPromiseFromLastYear(
    GenerateSamplePromiseRequest request,
  ) async {
    try {
      final response = await _dio.post(
        '/broken-promise-from-last-year',
        data: request.toJson(),
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<dynamic> generatReminderActionSteps(String promise) async {
    try {
      final response = await _dio.post(
        '/action-points',
        data: {"promise": promise},
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    if (e.response != null) {
      return 'Server Error: ${e.response?.statusCode} - ${e.response?.statusMessage}';
    }
    return 'Network Error: ${e.message}';
  }
}
