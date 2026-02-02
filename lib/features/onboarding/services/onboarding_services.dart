import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:sbp_app/features/onboarding/model/onboarding_answers.dart';
import '../../../core/services/api_client.dart';
import '../model/onboarding_result.dart';

class OnboardingServices {
  final ApiClient apiClient;

  OnboardingServices(this.apiClient);

  Future<OnboardingResult?> completeOnboarding({
    String? email,
    required OnboardingAnswers answers,
  }) async {
    try {
      Response res;
      if (email == null) {
        res = await apiClient.dio.post(
          "/onboarding/preview",
          data: {"answers": answers.toJson()},
        );
      } else {
        res = await apiClient.dio.post(
          "/onboarding/complete",
          data: {"email": email, "answers": answers.toJson()},
        );
      }
      final data = res.data['data'];
      if (res.statusCode == 201 && data != null) {
        log('🧩 Onboarding response: $data');
        return OnboardingResult.fromJson(data);
      }
      return null;
    } catch (e, st) {
      log("❌ Onboarding failed: $e", stackTrace: st);
      rethrow;
    }
  }
}
