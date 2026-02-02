import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:sbp_app/core/services/app_services.dart';
import 'package:sbp_app/features/auth/provider/authentication_providr.dart';
import 'package:sbp_app/features/profile/services/profile_services.dart';
import 'package:dio/dio.dart';

class PromiseProfileState {
  final bool initialLoading, isLoading, isImageLoading;
  final String? error;
  final Map<String, dynamic>? data;
  final bool? isValid;

  const PromiseProfileState({
    this.initialLoading = false,
    this.isLoading = false,
    this.isImageLoading = false,
    this.error,
    this.data,
    this.isValid,
  });

  PromiseProfileState copyWith({
    bool? isLoading,
    bool? initialLoading,
    bool? isImageLoading,
    String? error,
    bool? isValid,
  }) {
    return PromiseProfileState(
      isLoading: isLoading ?? this.isLoading,
      initialLoading: initialLoading ?? this.initialLoading,
      isImageLoading: isImageLoading ?? this.isImageLoading,
      error: error,
      isValid: isValid,
    );
  }
}

class PromisesProvider extends StateNotifier<PromiseProfileState> {
  final ProfileServices profileServices = locator.get<ProfileServices>();
  final Ref ref;

  PromisesProvider(this.ref) : super(const PromiseProfileState());

  Future<bool> cancelSubscription(BuildContext context) async {
    try {
      state = state.copyWith(isLoading: true);

      final success = await profileServices.cancelSubscription();

      state = state.copyWith(isLoading: false);

      return success;
    } on DioException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.response?.data["message"] ?? "Failed to cancel subscription",
      );
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<void> refund(
    BuildContext context,
    String email,
    String reason,
    String name,
    String description,
  ) async {
    try {
      state = state.copyWith(isLoading: true);
      bool? response = await profileServices.refund(
        email: email,
        reason: reason,
        name: name,
        description: description,
      );
      if (response != null) {
        state = state.copyWith(isLoading: false, isValid: true);
      } else {
        state = state.copyWith(isLoading: false, error: 'Something went wrong');
      }
    } on DioException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.response?.data["message"],
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> sendSupport(
    BuildContext context,
    String name,
    String email,
    String reason,
  ) async {
    try {
      state = state.copyWith(isLoading: true);
      bool? response = await profileServices.sendSupport(
        name: name,
        email: email,
        reason: reason,
      );
      if (response ?? false) {
        state = state.copyWith(isLoading: false, isValid: true);
      } else {
        state = state.copyWith(isLoading: false, error: 'Something went wrong');
      }
    } on DioException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.response?.data["message"],
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> deleteUserAccount(BuildContext context) async {
    try {
      state = state.copyWith(isLoading: true);
      final success = await profileServices.deleteAccount();
      state = state.copyWith(isLoading: false);
      return success;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<String?> uploadProfileImage(File imageFile) async {
    try {
      state = state.copyWith(isImageLoading: true);
      final extension = p.extension(imageFile.path).replaceAll('.', '');
      final presignedData = await profileServices.getPresignedUrl(
        folder: "profile-picture",
        fileExtension: extension,
      );
      if (presignedData == null) throw Exception("Failed generating URL");

      await profileServices.uploadImageToSignedUrl(
        presignedData['presignedUrl'],
        imageFile,
        'image/jpeg',
      );
      final updated = await profileServices.updateProfile(
        displayPictureURL: presignedData['publicUrl'],
      );

      if (updated) {
        final currentUser = ref.read(authenticationProvider).authUser!.user;
        ref
            .read(authenticationProvider.notifier)
            .syncLocalUserData(
              currentUser.copyWith(
                displayPictureURL: presignedData['publicUrl'],
              ),
            );
        state = state.copyWith(isImageLoading: false);
        return presignedData['publicUrl'];
      }
      return null;
    } catch (e) {
      state = state.copyWith(isImageLoading: false, error: e.toString());
      return null;
    }
  }
}

final profileProvider =
    StateNotifierProvider<PromisesProvider, PromiseProfileState>(
      (ref) => PromisesProvider(ref),
    );
