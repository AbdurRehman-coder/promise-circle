// import 'dart:developer';
// import 'dart:io';
// import 'package:google_sign_in/google_sign_in.dart';

// import 'api_config.dart';

// class GoogleAuthService {
//   final GoogleSignIn _googleSignIn = GoogleSignIn(
//     clientId: Platform.isIOS ? ApiConfig.iosClientId : null,
//     serverClientId: ApiConfig.webClientId,
//     scopes: const ['email', 'profile'],
//   );

//   Future<GoogleUserData?> signIn() async {
//     try {
//       final account = await _googleSignIn.signIn();
//       if (account == null) return null;

//       final auth = await account.authentication;

//       final userData = GoogleUserData(
//         account: account,
//         accessToken: auth.accessToken,
//         idToken: auth.idToken,
//         serverAuthCode: account.serverAuthCode,
//       );

//       // Comprehensive logging for debugging
//       log("=== Google Sign-In Success ===");
//       log("Display Name: ${account.displayName}");
//       log("Email: ${account.email}");
//       log("ID: ${account.id}");
//       log("Photo URL: ${account.photoUrl}");
//       log("==============================");

//       // Log tokens separately for easy copying
//       log("=== TOKENS (Copy These) ===");
//       log("ACCESS_TOKEN_START");
//       log("${auth.accessToken}");
//       log("ACCESS_TOKEN_END");
//       log("");
//       log("ID_TOKEN_START");
//       log("${auth.idToken}");
//       log("ID_TOKEN_END");
//       log("");
//       log("SERVER_AUTH_CODE_START");
//       log("${account.serverAuthCode}");
//       log("SERVER_AUTH_CODE_END");
//       log("=========================");

//       return userData;
//     } catch (e) {
//       log("Google sign-in error: $e");
//       return null;
//     }
//   }

//   Future<void> handleSignOut() async {
//     await _googleSignIn.signOut();
//   }

//   Future<GoogleUserData?> signInSilently() async {
//     try {
//       final account = await _googleSignIn.signInSilently();
//       if (account == null) return null;

//       final auth = await account.authentication;

//       final userData = GoogleUserData(
//         account: account,
//         accessToken: auth.accessToken,
//         idToken: auth.idToken,
//         serverAuthCode: account.serverAuthCode,
//       );

//       // Comprehensive logging for silent sign-in
//       log("=== Google Silent Sign-In Success ===");
//       log("Display Name: ${account.displayName}");
//       log("Email: ${account.email}");
//       log("ID: ${account.id}");
//       log("Photo URL: ${account.photoUrl}");
//       log("====================================");

//       // Log tokens separately for easy copying
//       log("=== SILENT TOKENS (Copy These) ===");
//       log("ACCESS_TOKEN_START");
//       log("${auth.accessToken}");
//       log("ACCESS_TOKEN_END");
//       log("");
//       log("ID_TOKEN_START");
//       log("${auth.idToken}");
//       log("ID_TOKEN_END");
//       log("");
//       log("SERVER_AUTH_CODE_START");
//       log("${account.serverAuthCode}");
//       log("SERVER_AUTH_CODE_END");
//       log("=================================");

//       return userData;
//     } catch (e) {
//       log("Silent sign-in error: $e");
//       return null;
//     }
//   }
// }

// class GoogleUserData {
//   final GoogleSignInAccount account;
//   final String? accessToken;
//   final String? idToken;
//   final String? serverAuthCode;

//   GoogleUserData({
//     required this.account,
//     this.accessToken,
//     this.idToken,
//     this.serverAuthCode,
//   });
// }
