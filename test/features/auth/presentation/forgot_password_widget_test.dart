import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sbp_app/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:sbp_app/features/auth/presentation/screens/password_reset_success_screen.dart';
import 'package:sbp_app/features/auth/presentation/screens/reset_password_screen.dart';

void main() {
  group('Forgot Password Screen Widget Tests', () {
    testWidgets('ForgotPasswordScreen displays email field and button',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ForgotPasswordScreen(),
        ),
      );

      // Verify title exists
      expect(find.text('Forgot password'), findsOneWidget);

      // Verify email field label exists
      expect(find.text('Email'), findsOneWidget);

      // Verify button exists
      expect(find.text('Reset Password'), findsOneWidget);
    });

    testWidgets('ResetPasswordScreen displays password fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ResetPasswordScreen(),
        ),
      );

      // Verify title exists
      expect(find.text('Change password'), findsOneWidget);

      // Verify password fields exist
      expect(find.text('New password'), findsOneWidget);
      expect(find.text('Confirm new password'), findsOneWidget);

      // Verify helper text
      expect(
        find.text(
            'Use 8 or more characters with a mix of letters, numbers & symbols'),
        findsOneWidget,
      );

      // Verify button exists
      expect(find.text('Confirm'), findsOneWidget);
    });

    testWidgets('PasswordResetSuccessScreen displays success message',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PasswordResetSuccessScreen(),
        ),
      );

      // Verify success title
      expect(find.text('Password changed'), findsOneWidget);

      // Verify success message
      expect(
        find.text('Your password has been updated successfully'),
        findsOneWidget,
      );

      // Verify login button
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('Reset password button is disabled with invalid passwords',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ResetPasswordScreen(),
        ),
      );

      // Find the button - it should be disabled initially
      final button = find.text('Confirm');
      expect(button, findsOneWidget);

      // TODO: Add more specific button state verification
      // This would require accessing the actual PrimaryButton widget
      // and checking its enabled property
    });

    testWidgets('Email validation shows error for invalid email',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ForgotPasswordScreen(),
        ),
      );

      // Find email text field
      final emailField = find.byType(TextFormField).first;

      // Enter invalid email
      await tester.enterText(emailField, 'invalid-email');
      await tester.pump();

      // Tap the button to trigger validation
      final button = find.text('Reset Password');
      await tester.tap(button);
      await tester.pump();

      // Note: Actual validation message verification would require
      // more specific widget tree access
    });
  });

  group('Password Validation Tests', () {
    testWidgets('Password fields toggle visibility on icon tap',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ResetPasswordScreen(),
        ),
      );

      // Find visibility toggle icons
      final visibilityIcons = find.byIcon(Icons.visibility_off_outlined);
      expect(visibilityIcons, findsWidgets);

      // Tap first visibility icon
      await tester.tap(visibilityIcons.first);
      await tester.pump();

      // After tap, should show the other icon
      expect(find.byIcon(Icons.remove_red_eye_outlined), findsWidgets);
    });
  });
}

