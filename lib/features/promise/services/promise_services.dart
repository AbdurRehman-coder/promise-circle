import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:sbp_app/core/constants/api_endpoints.dart';
import 'package:sbp_app/features/promise/models/create_promise_payload.dart';
import 'package:sbp_app/features/promise/models/promises_response.dart';
import '../../../core/services/api_client.dart';
import '../models/promise_result.dart';

class PromiseServices {
  final ApiClient apiClient;

  PromiseServices(this.apiClient);

  Future<PromiseResult?> createPromise({
    required CreatePromisePayload answers,
  }) async {
    try {
      final res = await apiClient.dio.post("/promises", data: answers.toJson());
      final data = res.data['data'];
      if (res.statusCode == 201 && data != null) {
        log('✅ Promise created: ${data['_id']}');
        return PromiseResult.fromJson(data);
      }
      return null;
    } catch (e, st) {
      log("❌ Promise creation failed: $e", stackTrace: st);
      rethrow;
    }
  }

  Future<PromisesResponse?> getAllPromises() async {
    try {
      final res = await apiClient.dio.get(ApiEndpoints.allPromisesOfUser);
      if (res.statusCode == 200) {
        final data = res.data;
        return PromisesResponse.fromJson(data);
      }
      return null;
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? "Something went wrong";
    } catch (e, st) {
      log("❌ Error getting all promises: ", stackTrace: st, error: e);
      throw "Something went wrong";
    }
  }

  Future<PromiseResult?> updatePromise({
    required CreatePromisePayload answers,
    required String promiseId,
  }) async {
    try {
      final res = await apiClient.dio.patch(
        ApiEndpoints.updatePromise(promiseId),
        data: answers.toJson(),
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = res.data['data'];
        return PromiseResult.fromJson(data);
      }
      return null;
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? "Something went wrong";
    } catch (e, st) {
      log("❌ Error getting all promises: ", stackTrace: st, error: e);
      throw "Something went wrong";
    }
  }

  Future<Map<String, String>?> transformBrokenPromises({
    required String p1,
    required String p2,
    String? p3,
  }) async {
    try {
      final res = await apiClient.dio.post(
        '/openai/transform-broken-promises',
        data: {
          "broken_promise_1": p1,
          "broken_promise_2": p2,
          if (p3 != null && p3.isNotEmpty) "broken_promise_3": p3,
        },
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = res.data['data'];
        return {
          "p1": data['promise_1'] ?? "",
          "p2": data['promise_2'] ?? "",
          "p3": data['promise_3'] ?? "",
        };
      }
      return null;
    } catch (e) {
      log("❌ Transformation failed: $e");
      return null;
    }
  }

  Future<PromiseResult?> updatePromiseReminders({
    required String promiseId,
    required Map<String, dynamic> payload,
  }) async {
    try {
      final res = await apiClient.dio.patch(
        '/promises/$promiseId',
        data: payload,
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = res.data['data'];
        log('✅ Promise Updated: $data');
        return PromiseResult.fromJson(data);
      }
      return null;
    } on DioException catch (e) {
      log("❌ Update failed: ${e.response?.data}");
      throw e.response?.data['message'] ?? "Something went wrong";
    } catch (e, st) {
      log("❌ Error updating promise: ", stackTrace: st, error: e);
      throw "Something went wrong";
    }
  }

  Future<bool> createPromiseHistory({
    required String promiseId,
    required String status,
    required String keptAt,
    required String? reminderType,
    String? keptDate,
    int? keptDays,
    String? circleId,
  }) async {
    try {
      final Map<String, dynamic> payload = {
        "promise": promiseId,
        "status": status,
        "keptAt": keptAt,
        "reminderType": reminderType,
      };

      if (circleId != null) payload["circle"] = circleId;
      if (reminderType == "ONE_TIME") {
        payload["keptDate"] = keptDate;
      } else {
        payload["keptDays"] = keptDays;
      }

      final res = await apiClient.dio.post('/promise-history', data: payload);
      return res.statusCode == 200 || res.statusCode == 201;
    } on DioException catch (e) {
      log("❌ History creation failed: ${e.response?.data}");
      throw e.response?.data['message'] ?? "Failed to update promise status";
    } catch (e) {
      log("❌ Error creating history: $e");
      throw "An unexpected error occurred";
    }
  }
}
