import 'dart:developer';
import 'package:sbp_app/core/services/api_client.dart';

class ReflectionServices {
  final ApiClient apiClient;

  ReflectionServices(this.apiClient);

  Future<bool> createReflection({
    required String promiseId,
    required String description,
    String? imageUrl,
    bool isPrivate = false,
  }) async {
    try {
      final res = await apiClient.dio.post(
        "/reflections",
        data: {
          "promise": promiseId,
          "description": description,
          "imageUrl": imageUrl,
          "isPrivate": isPrivate,
        },
      );

      return res.statusCode == 201||res.statusCode == 200;
    } catch (e, st) {
      log("❌ Create Reflection failed: $e", stackTrace: st);
      rethrow;
    }
  }
}