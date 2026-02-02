import 'package:dio/dio.dart';
import 'package:sbp_app/core/services/api_client.dart';
import 'package:sbp_app/core/utils/api_exception.dart';
import 'package:sbp_app/features/invite/models/invite_verification.dart';

class InviteService {
  final ApiClient apiClient;

  InviteService(this.apiClient);

  Future<InviteVerificationResult?> verifyInvite({
    required String inviteCode,
  }) async {
    try {
      final res = await apiClient.dio.post(
        '/auth/apply-invite-code',
        data: {"inviteCode": inviteCode},
      );

      if (_isSuccess(res)) {
        return InviteVerificationResult.fromJson(res.data['data']);
      }
      return null;
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<bool> requestEarlyAccess({
    required String name,
    required String email,
    required String mobileNumber,
  }) async {
    try {
      final res = await apiClient.dio.post(
        "/waitlist",
        data: {"name": name, "email": email, "phone": mobileNumber},
      );

      return _isSuccess(res);
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  bool _isSuccess(Response res) {
    return (res.statusCode == 200 || res.statusCode == 201) && res.data != null;
  }
}
