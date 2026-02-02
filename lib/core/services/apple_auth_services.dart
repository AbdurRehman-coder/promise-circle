import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'package:crypto/crypto.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleAuthPayload {
  final String identityToken;
  final String? authorizationCode;
  final String userIdentifier;
  final String rawNonce;
  final String? givenName;
  final String? familyName;

  const AppleAuthPayload({
    required this.identityToken,
    this.authorizationCode,
    required this.userIdentifier,
    required this.rawNonce,
    this.givenName,
    this.familyName,
  });
}

class AppleAuthCancelledException implements Exception {
  const AppleAuthCancelledException();
}

class AppleAuthFailedException implements Exception {
  final String message;
  const AppleAuthFailedException(this.message);
}

class AppleAuthUnsupportedException implements Exception {
  const AppleAuthUnsupportedException();
}

class AppleAuthServices {
  /// Initiates Apple Sign-In, returns payload for backend.
  /// Throws AppleAuthCancelledException if user cancels.
  /// Throws AppleAuthFailedException if sign-in fails.
  /// Throws AppleAuthUnsupportedException if not on iOS.
  Future<AppleAuthPayload> signIn() async {
    try {
      // Check if platform is supported
      if (!Platform.isIOS) {
        throw const AppleAuthUnsupportedException();
      }

      // Generate raw nonce
      final rawNonce = _generateNonce();

      // Create hashed nonce
      final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

      // Request Apple ID credential
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );

      // Check if we have required data
      if (credential.identityToken == null) {
        throw const AppleAuthFailedException('Identity token is null');
      }

      return AppleAuthPayload(
        identityToken: credential.identityToken!,
        authorizationCode: credential.authorizationCode,
        userIdentifier: credential.userIdentifier ?? '',
        rawNonce: rawNonce,
        givenName: credential.givenName,
        familyName: credential.familyName,
      );
    } on SignInWithAppleAuthorizationException catch (e) {
      log("Apple sign-in authorization error: ${e.code} - ${e.message}");

      // Handle user cancellation
      if (e.code == AuthorizationErrorCode.canceled) {
        throw const AppleAuthCancelledException();
      }

      // Handle other authorization errors
      throw AppleAuthFailedException('Authorization failed: ${e.message}');
    } catch (e) {
      if (e is AppleAuthCancelledException ||
          e is AppleAuthFailedException ||
          e is AppleAuthUnsupportedException) {
        rethrow;
      }

      log("Apple sign-in error: $e");
      throw AppleAuthFailedException('Sign-in failed: $e');
    }
  }

  /// Sign out provider if needed (Apple doesn't have explicit sign out)
  Future<void> signOut() async {
    // Apple Sign-In doesn't require explicit sign out
    // This method exists for parity with Google service
  }

  /// Generate a cryptographically secure random nonce
  String _generateNonce() {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = math.Random.secure();
    return List.generate(
      32,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }
}
