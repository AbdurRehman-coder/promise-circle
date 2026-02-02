import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import '../../../core/services/api_client.dart';

class ProfileServices {
  final ApiClient apiClient;

  ProfileServices(this.apiClient);

  Future<bool> cancelSubscription() async {
    try {
      final res = await apiClient.dio.post("subscription/cancel");

      if (res.statusCode == 200 || res.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e, st) {
      log("Cancel Subscription failed: $e", stackTrace: st);
      rethrow;
    }
  }

  Future<bool?> refund({
    required String email,
    required String reason,
    required String description,
    String name = '',
  }) async {
    try {
      final res = await apiClient.dio.post(
        "/refund",
        data: {
          "email": email,
          "reason": reason,
          "name": name,
          "description": description,
        },
      );

      final data = res.data['data'];
      if (res.statusCode == 201 && data != null) {
        return true;
      }
      return null;
    } catch (e, st) {
      log("refund failed: $e", stackTrace: st);
      rethrow;
    }
  }

  Future<bool?> sendSupport({
    required String name,
    required String email,
    required String reason,
  }) async {
    try {
      final res = await apiClient.dio.post(
        "/support",
        data: {"name": name, "email": email, "description": reason},
      );

      final data = res.data['data'];
      if (res.statusCode == 201 && data != null) {
        return true;
      }
      return null;
    } catch (e, st) {
      log("Support creation failed: $e", stackTrace: st);
      rethrow;
    }
  }

  Future<bool> deleteAccount() async {
    try {
      final res = await apiClient.dio.delete("/user");
      return res.statusCode == 200 || res.statusCode == 204;
    } catch (e, st) {
      log("Delete Account failed: $e", stackTrace: st);
      rethrow;
    }
  }

  Future<bool> updateProfile({String? displayPictureURL}) async {
    try {
      final Map<String, dynamic> data = {};
      if (displayPictureURL != null) {
        data['displayPictureURL'] = displayPictureURL;
      }

      if (data.isEmpty) return false;

      if (data['timezoneRegion'] == null) {
        try {
          final String systemTimezone =
              await FlutterTimezone.getLocalTimezone();
          data['timezoneRegion'] = systemTimezone;
        } catch (_) {
          data['timezoneRegion'] = 'UTC';
        }
      }

      data.putIfAbsent(
        'timezone',
        () => DateTime.now().toUtc().toIso8601String(),
      );
      final res = await apiClient.dio.patch("/user", data: data);

      return res.statusCode == 200;
    } catch (e, st) {
      log("Update Profile failed: $e", stackTrace: st);
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getPresignedUrl({
    required String folder,
    required String fileExtension,
  }) async {
    try {
      String contentType = 'image/jpeg';
      if (fileExtension.toLowerCase().contains('png')) {
        contentType = 'image/png';
      }

      final res = await apiClient.dio.post(
        "/images/presigned-url",
        data: {"folder": folder, "contentType": contentType, "expiresIn": 3600},
      );

      if (res.statusCode == 201 || res.statusCode == 200) {
        return res.data['data'];
      }
      return null;
    } catch (e, st) {
      log("Get Presigned URL failed: $e", stackTrace: st);
      rethrow;
    }
  }

  Future<bool> uploadImageToSignedUrl(
    String url,
    File file,
    String contentType,
  ) async {
    try {
      final dio = Dio();
      final len = await file.length();

      final res = await dio.put(
        url,
        data: file.openRead(),
        options: Options(
          headers: {
            Headers.contentLengthHeader: len,
            "Content-Type": contentType,
            "x-amz-acl": "public-read",
          },
        ),
      );

      return res.statusCode == 200;
    } catch (e, st) {
      log("S3 Upload failed: $e", stackTrace: st);
      throw Exception("Failed to upload image to storage");
    }
  }
}
