import 'package:dio/dio.dart';
import 'package:sbp_app/core/utils/api_exception.dart';
import '../../../core/services/api_client.dart';
import '../models/seven_day_challenge_model.dart';

class ChallengeServices {
  final ApiClient apiClient;

  ChallengeServices(this.apiClient);

  Future<SevenDayChallenge> getChallenge() async {
    try {
      final res = await apiClient.dio.get('/seven-day-challenge');
      if (_isSuccess(res)) {
        return SevenDayChallenge.fromJson(res.data['data']);
      }
      throw Exception("Failed to load challenge");
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 404) {
        throw Exception("Challenge not started");
      }
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<SevenDayChallenge> createChallenge() async {
    try {
      final res = await apiClient.dio.post('/seven-day-challenge');
      if (_isSuccess(res)) {
        return SevenDayChallenge.fromJson(res.data['data']);
      }
      throw Exception("Failed to create challenge");
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<SevenDayChallenge> updateDay(String dayKey) async {
    try {
      final res = await apiClient.dio.patch(
        '/seven-day-challenge',
        data: {
          dayKey: true,
          "updatedAtFromUser": DateTime.now().toIso8601String(),
        },
      );
      if (_isSuccess(res)) {
        return SevenDayChallenge.fromJson(res.data['data']);
      }
      throw Exception("Failed to update day");
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  bool _isSuccess(Response res) {
    return (res.statusCode == 200 || res.statusCode == 201) && res.data != null;
  }
}
