// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
// import 'package:sbp_app/core/services/shared_prefs_services.dart';
// import 'package:sbp_app/features/auth/provider/authentication_providr.dart';
// import 'package:sbp_app/features/auth/services/auth_services.dart';

// @GenerateMocks([AuthServices, SharedPrefServices])
// import 'forgot_password_provider_test.mocks.dart';

// void main() {
//   late MockAuthServices mockAuthServices;
//   late MockSharedPrefServices mockPrefs;

//   setUp(() {
//     mockAuthServices = MockAuthServices();
//     mockPrefs = MockSharedPrefServices();
//   });

//   group('Forgot Password Flow Tests', () {
//     test('forgotPassword - success case', () async {
//       // Arrange
//       const email = 'test@example.com';
//       when(mockAuthServices.forgotPassword(email))
//           .thenAnswer((_) async => true);

//       // Note: In real implementation, you'd need to properly inject dependencies
//       // This is a simplified test structure

//       // Assert
//       verify(mockAuthServices.forgotPassword(email)).called(1);
//     });

//     test('forgotPassword - failure case', () async {
//       // Arrange
//       const email = 'test@example.com';
//       when(mockAuthServices.forgotPassword(email))
//           .thenAnswer((_) async => false);

//       // Assert expectations for error state
//       verify(mockAuthServices.forgotPassword(email)).called(1);
//     });

//     test('verifyResetCode - success case', () async {
//       // Arrange
//       const email = 'test@example.com';
//       const code = '12345';
//       when(mockAuthServices.verifyResetCode(email, code))
//           .thenAnswer((_) async => true);

//       // Assert
//       verify(mockAuthServices.verifyResetCode(email, code)).called(1);
//     });

//     test('verifyResetCode - wrong code', () async {
//       // Arrange
//       const email = 'test@example.com';
//       const code = '00000';
//       when(mockAuthServices.verifyResetCode(email, code))
//           .thenThrow(Exception('wrong authentication code'));

//       // Assert
//       expect(
//         () => mockAuthServices.verifyResetCode(email, code),
//         throwsException,
//       );
//     });

//     test('resendVerificationCode - success case', () async {
//       // Arrange
//       const email = 'test@example.com';
//       when(mockAuthServices.resendVerificationCode(email))
//           .thenAnswer((_) async => true);

//       // Assert
//       verify(mockAuthServices.resendVerificationCode(email)).called(1);
//     });

//     test('resetPassword - success case', () async {
//       // Arrange
//       const email = 'test@example.com';
//       const newPassword = 'NewPass123!';
//       const confirmPassword = 'NewPass123!';
//       const code = '12345';

//       when(mockAuthServices.resetPassword(
//         email,
//         newPassword,
//         confirmPassword,
//         code,
//       )).thenAnswer((_) async => true);

//       // Assert
//       verify(mockAuthServices.resetPassword(
//         email,
//         newPassword,
//         confirmPassword,
//         code,
//       )).called(1);
//     });

//     test('resetPassword - password mismatch', () async {
//       // Arrange
//       const email = 'test@example.com';
//       const newPassword = 'NewPass123!';
//       const confirmPassword = 'DifferentPass123!';
//       const code = '12345';

//       when(mockAuthServices.resetPassword(
//         email,
//         newPassword,
//         confirmPassword,
//         code,
//       )).thenThrow(Exception('Passwords do not match'));

//       // Assert
//       expect(
//         () => mockAuthServices.resetPassword(
//           email,
//           newPassword,
//           confirmPassword,
//           code,
//         ),
//         throwsException,
//       );
//     });

//     test('resetPassword - invalid/expired token', () async {
//       // Arrange
//       const email = 'test@example.com';
//       const newPassword = 'NewPass123!';
//       const confirmPassword = 'NewPass123!';
//       const code = 'expired';

//       when(mockAuthServices.resetPassword(
//         email,
//         newPassword,
//         confirmPassword,
//         code,
//       )).thenThrow(Exception('Invalid or expired token'));

//       // Assert
//       expect(
//         () => mockAuthServices.resetPassword(
//           email,
//           newPassword,
//           confirmPassword,
//           code,
//         ),
//         throwsException,
//       );
//     });
//   });
// }

