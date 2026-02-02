import 'dart:async';
import 'dart:developer' as dev;
import 'package:dio/dio.dart';
// import 'package:firebase_messaging/firebase_messaging.dart'; // IMPORT THIS
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
// ... existing imports ...
import 'package:sbp_app/core/services/api_config.dart';
import 'package:sbp_app/features/auth/models/app_setting.dart';
import 'package:sbp_app/features/auth/models/subscription_data_model.dart';
import 'package:sbp_app/features/auth/presentation/screens/sign_up_basic_info.dart';
import 'package:sbp_app/features/main_home/presentations/main_home_screen.dart';
import 'package:sbp_app/features/onboarding/model/onboarding_data_model.dart';
import 'package:sbp_app/features/onboarding/presentation/screens/ui_onboarding.dart';
import 'package:sbp_app/features/onboarding/presentation/screens/promise_profile_screen.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:sbp_app/features/auth/models/auth_response_model.dart';
import 'package:sbp_app/features/auth/models/sign_up_request_model.dart';
import 'package:sbp_app/features/auth/models/user_model.dart';
import 'package:sbp_app/features/auth/services/auth_services.dart';
import 'package:sbp_app/features/promise/provider/promise_list_provider.dart';
import 'package:sbp_app/features/promise/provider/promise_controller.dart';
import 'package:sbp_app/features/onboarding/provider/onboarding_provider.dart';
import 'package:sbp_app/features/shared/widgets/flushbar.dart';
import 'package:sbp_app/main.dart';
import '../../../core/services/app_services.dart';
import '../../../core/services/facebook_events_service.dart';
import '../../../core/services/shared_prefs_services.dart';
import '../../onboarding/model/onboarding_result.dart';
import '../../onboarding/services/onboarding_services.dart'
    show OnboardingServices;
import '../../seven_day_challenge/presentation/screens/challenge_intro_screen.dart';
import '../../seven_day_challenge/presentation/screens/seven_day_challenge_screen.dart';
import '../../seven_day_challenge/provider/challenge_provider.dart';
import '../../shared/providers/ai_examples_provider.dart';

// ... AuthenticationState Class remains exactly the same ...
class AuthenticationState {
  // ... (keep existing code)
  final AuthResponse? authUser;
  final OnboardingDataModel? onboardingData;
  final bool initialLoading, isLoading, googleLoading, appleLoading;
  final String? error;
  final String? resetEmail;
  final String? resetCode;
  final String inviteCode;
  bool? isFirstTime;
  SubscriptionData? subscriptionData;
  AppSettingsResponse? appSetting;

  AuthenticationState({
    this.authUser,
    this.initialLoading = false,
    this.isLoading = false,
    this.error,
    this.isFirstTime,
    this.resetEmail,
    this.resetCode,
    this.inviteCode = '',
    this.onboardingData,
    this.subscriptionData,
    this.googleLoading = false,
    this.appleLoading = false,
    this.appSetting,
  });

  // ... getters and copyWith remain same ...
  bool get isAuthenticated =>
      authUser != null && authUser!.accessToken.isNotEmpty;
  bool get isOnboardingCompleted => onboardingData != null;
  bool get hasSubscription =>
      subscriptionData != null && subscriptionData!.hasAccess;

  bool get checkPaywall => appSetting?.data.paywall ?? false;

  AuthenticationState copyWith({
    AuthResponse? authUser,
    bool? isLoading,
    bool? initialLoading,
    bool? googleLoading,
    bool? appleLoading,
    String? error,
    String? resetEmail,
    String? resetCode,
    String? inviteCode,
    OnboardingDataModel? onboardingData,
    SubscriptionData? subscriptionData,
    AppSettingsResponse? appSetting,
  }) {
    return AuthenticationState(
      authUser: authUser ?? this.authUser,
      isLoading: isLoading ?? this.isLoading,
      appleLoading: appleLoading ?? this.appleLoading,
      googleLoading: googleLoading ?? this.googleLoading,
      initialLoading: initialLoading ?? this.initialLoading,
      error: error,
      resetEmail: resetEmail ?? this.resetEmail,
      resetCode: resetCode ?? this.resetCode,
      inviteCode: inviteCode ?? this.inviteCode,
      onboardingData: onboardingData ?? this.onboardingData,
      subscriptionData: subscriptionData ?? this.subscriptionData,
      appSetting: appSetting ?? this.appSetting,
    );
  }
}

class AuthenticationProvider extends StateNotifier<AuthenticationState> {
  final SharedPrefServices prefs = locator.get<SharedPrefServices>();
  final AuthServices authServices = locator.get<AuthServices>();

  final Completer<void> _initCompleter = Completer<void>();
  Future<void> get initFuture => _initCompleter.future;

  AuthenticationProvider() : super(AuthenticationState()) {
    loadInitialData();
  }

  // Helper method to get FCM Token
  // Future<String?> _getFcmToken() async {
  //   // try {
  //   //   return await FirebaseMessaging.instance.getToken();
  //   // } catch (e) {
  //   //   dev.log("Error fetching FCM token: $e");
  //   //   return null;
  //   // }
  //   return null;
  // }

  Future<void> loadInitialData() async {
    OnboardingDataModel? onboardingDataModel;
    try {
      state = state.copyWith(initialLoading: true);
      onboardingDataModel = await checkOnboarding();
      await getUserAppSetting();

      final data = await Future.wait([
        Future.delayed(const Duration(seconds: 3)),
        loadUser(),
      ]);
      await getUserSubscription();
      state = state.copyWith(
        authUser: data[1] as AuthResponse?,
        onboardingData: onboardingDataModel,
        initialLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        initialLoading: false,
        authUser: null,
        onboardingData: onboardingDataModel,
      );
    } finally {
      if (!_initCompleter.isCompleted) _initCompleter.complete();
    }
  }

  Future<AuthResponse?> loadUser({bool updateState = false}) async {
    AuthResponse? response = await prefs.getLoggedUser();

    User? user = response != null
        ? await authServices.getCurrentUser(response.user.id!)
        : null;

    if (user == null) {
      await prefs.clearUserData();
      return null;
    }

    response = response!.copyWith(user: user);
    if (updateState) {
      state = state.copyWith(authUser: response);
    }
    await prefs.saveLoggedUser(response);
    dev.log("User logged in");
    return response;
  }

  Future<OnboardingDataModel?> checkOnboarding() async {
    return await prefs.getOnboarding();
  }

  Future<void> setOnboarding(OnboardingDataModel onboarding) async {
    state = state.copyWith(onboardingData: onboarding);
  }

  Future<void> getUserAppSetting() async {
    try {
      state = state.copyWith(appSetting: null);

      AppSettingsResponse? data = await authServices.getUserAppSetting();

      state = state.copyWith(appSetting: data);
    } catch (e) {
      state = state.copyWith(appSetting: null);
    }
  }

  Future<void> getUserSubscription() async {
    try {
      state = state.copyWith(subscriptionData: null);

      SubscriptionData? data = await authServices.getUserSubscription();

      state = state.copyWith(subscriptionData: data);
    } catch (e) {
      state = state.copyWith(subscriptionData: null);
    }
  }

  void syncLocalUserData(User updatedUser) {
    if (state.authUser == null) return;
    final updatedResponse = state.authUser!.copyWith(user: updatedUser);
    prefs.saveLoggedUser(updatedResponse);
    state = state.copyWith(authUser: updatedResponse);
  }

  void setInviteCode(String code) {
    if (state.inviteCode != code) {
      state = state.copyWith(inviteCode: code);
    }
    dev.log("Invite code set to ${state.inviteCode}");
  }

  // ===========================================================================
  // 2. Core Authentication (Login, Signup, Social, Logout)
  // ===========================================================================

  Future<void> login(
    String email,
    String password,
    WidgetRef ref,
    BuildContext context,
  ) async {
    state = state.copyWith(isLoading: true);
    try {
      final onboardingService = locator.get<OnboardingServices>();
      final data = await onboardingService.completeOnboarding(
        answers: state.onboardingData!.onboardingAnswers,
        email: email,
      );
      ref.read(aiExamplesControllerProvider.notifier).init(data!);

      // UPDATED: Fetch Token and Pass
      // final String? fcmToken = await _getFcmToken();
      const String? fcmToken = null;
      final response = await authServices.login(
        email,
        password,
        fcmToken: fcmToken,
      );

      await _handleAuthCompletion(
        response: response,
        onboardingResult: data,
        ref: ref,
        errorMessage: 'Something wrong. Please try again.',
        context: navigatorKey.currentContext,
      );
    } on DioException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error:
            e.response?.data['message'] ?? 'Something wrong. Please try again.',
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> signUp(SignUpRequestModel model, WidgetRef ref) async {
    state = state.copyWith(isLoading: true);
    try {
      final onboardingService = locator.get<OnboardingServices>();
      final data = await onboardingService.completeOnboarding(
        answers: state.onboardingData!.onboardingAnswers,
        email: model.email,
      );
      ref.read(aiExamplesControllerProvider.notifier).init(data!);

      // final String? fcmToken = await _getFcmToken();
      const String? fcmToken = null;
      final response = await authServices.signup(model, fcmToken: fcmToken);

      if (response) {
        final fbEvents = FacebookEventsService();

        fbEvents.logEvent(
          name: 'promise_profile',
          parameters: {'timestamp': DateTime.now().toIso8601String()},
          ref: ref,
          screenName: 'Promise Profile',
        );

        state = state.copyWith(
          isLoading: false,
          onboardingData: OnboardingDataModel(
            onboardingResult: data,
            onboardingAnswers: state.onboardingData!.onboardingAnswers,
          ),
          authUser: AuthResponse(
            user: User(email: model.email, emailVerified: false),
            accessToken: '',
            refreshToken: '',
          ),
        );
        fbEvents.logEvent(
          name: 'sign_up',
          parameters: {'timestamp': DateTime.now().toIso8601String()},
          ref: ref,
          screenName: 'Signup',
        );
      }
    } on DioException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error:
            e.response?.data['message'] ?? 'Something wrong. Please try again.',
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> signInWithGoogle(WidgetRef ref, BuildContext context) async {
    state = state.copyWith(googleLoading: true);
    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: ApiConfig.webClientId,
      serverClientId: ApiConfig.serverClientId,
      scopes: ['email', 'profile'],
    );
    try {
      final GoogleSignInAccount? account = await googleSignIn.signIn();

      if (account == null) {
        state = state.copyWith(googleLoading: false);
        return;
      }
      final onboardingService = locator.get<OnboardingServices>();
      final data = await onboardingService.completeOnboarding(
        answers: state.onboardingData!.onboardingAnswers,
        email: account.email,
      );
      ref.read(aiExamplesControllerProvider.notifier).init(data!);

      final GoogleSignInAuthentication auth = await account.authentication;
      final String? idToken = auth.idToken;

      if (idToken == null) {
        state = state.copyWith(
          googleLoading: false,
          error: "Failed to obtain Google tokens.",
        );
        return;
      }

      // UPDATED: Fetch Token and Pass
      // final String? fcmToken = await _getFcmToken();
      const String? fcmToken = null;
      final response = await authServices.googleSignIn(
        idToken,
        state.inviteCode,
        fcmToken: fcmToken,
      );

      await _handleAuthCompletion(
        response: response,
        onboardingResult: data,
        ref: ref,
        context: context.mounted ? context : null,
        errorMessage: "Google sign-in failed. Try again.",
      );
    } catch (e) {
      debugPrint(e.toString());
      googleSignIn.signOut();
      if (navigatorKey.currentContext != null) {
        FlashMessage.showError(navigatorKey.currentContext!, e.toString());
      }
      state = state.copyWith(googleLoading: false, error: e.toString());
    }
  }

  Future<void> signInWithApple(WidgetRef ref, BuildContext context) async {
    state = state.copyWith(appleLoading: true);

    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final onboardingService = locator.get<OnboardingServices>();
      final data = await onboardingService.completeOnboarding(
        answers: state.onboardingData!.onboardingAnswers,
        email: credential.email,
      );
      ref.read(aiExamplesControllerProvider.notifier).init(data!);

      final String identityToken = credential.identityToken ?? "";
      final String userIdentifier = credential.userIdentifier ?? "";

      if (identityToken.isEmpty || userIdentifier.isEmpty) {
        state = state.copyWith(
          appleLoading: false,
          error: "Failed to obtain Apple credentials.",
        );
        return;
      }

      // final String? fcmToken = await _getFcmToken();
      const String? fcmToken = null;
      final response = await authServices.appleSignIn(
        identityToken,
        userIdentifier,
        fcmToken ?? "",
        state.inviteCode,
      );

      await _handleAuthCompletion(
        response: response,
        onboardingResult: data,
        ref: ref,
        context: context.mounted ? context : null,
        errorMessage: "Apple sign-in failed. Try again.",
      );
    } catch (e) {
      debugPrint(e.toString());
      if (e is SignInWithAppleAuthorizationException) {
        if (e.code == AuthorizationErrorCode.canceled) {
          state = state.copyWith(appleLoading: false);
          return;
        }
      }
      if (navigatorKey.currentContext != null) {
        FlashMessage.showError(
          navigatorKey.currentContext!,
          "Apple sign-in failed. Try again.".toString(),
        );
      }
      state = state.copyWith(appleLoading: false, error: e.toString());
    }
  }

  Future<void> logout(WidgetRef ref, BuildContext context) async {
    Navigator.pushNamedAndRemoveUntil(
      context,
      UIOnboardingScreen.routeName,
      (route) => false,
    );
    if (state.authUser != null) {
      if (state.authUser!.user.authProvider == "google") {
        final GoogleSignIn googleSignIn = GoogleSignIn(
          clientId: ApiConfig.webClientId,
          serverClientId: ApiConfig.serverClientId,
          scopes: ['email', 'profile'],
        );
        await googleSignIn.signOut();
      }
    }

    state = AuthenticationState(
      authUser: null,
      inviteCode: "",
      isLoading: false,
    );

    await prefs.clearUserData();
    await prefs.clearOnboarding();
    ref.read(onboardingControllerProvider.notifier).clearMicroTags();
    ref.read(onboardingStepIndexProvider.notifier).state = 0;
    ref.read(promiseStepIndexProvider.notifier).state = 0;

    ref.invalidate(promisesProvider);
    ref.invalidate(promiseControllerProvider);
    ref.invalidate(onboardingControllerProvider);
  }

  // ===========================================================================
  // 3. Account Management (Update Info, Verify Email)
  // ===========================================================================

  Future<void> updateBasicInfo(User user) async {
    state = state.copyWith(isLoading: true);
    try {
      User? updatedUser = await authServices.requestBasicInfo(user);
      if (updatedUser != null) {
        AuthResponse response = state.authUser!.copyWith(user: updatedUser);
        await prefs.saveLoggedUser(response);
        state = state.copyWith(authUser: response, isLoading: false);
      }
    } on DioException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error:
            e.response?.data['message'] ??
            'Something went wrong. Please try again.',
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> verifyEmail(String code, {String? email}) async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await authServices.verifyEmail(
        email ?? state.authUser!.user.email!,
        code,
      );
      if (response != null) {
        await prefs.saveLoggedUser(response);
        state = state.copyWith(authUser: response, isLoading: false);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Something wrong. Please try again.',
        );
      }
    } on DioException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error:
            e.response?.data['message'] ??
            'Something went wrong. Please try again.',
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // ===========================================================================
  // 4. Password Recovery
  // ===========================================================================

  Future<void> forgotPassword(String email) async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await authServices.forgotPassword(email);
      if (response) {
        state = state.copyWith(isLoading: false, resetEmail: email);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Something went wrong. Please try again.',
        );
      }
    } on DioException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error:
            e.response?.data['message'] ??
            'Something went wrong. Please try again.',
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> verifyResetCode(String code) async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await authServices.verifyResetCode(
        state.resetEmail ?? '',
        code,
      );
      if (response) {
        state = state.copyWith(isLoading: false, resetCode: code);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Something went wrong. Please try again.',
        );
      }
    } on DioException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error:
            e.response?.data['message'] ??
            'Something went wrong. Please try again.',
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> resendVerificationCode() async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await authServices.resendVerificationCode(
        state.resetEmail ?? '',
      );
      if (response) {
        state = state.copyWith(isLoading: false);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Something went wrong. Please try again.',
        );
      }
    } on DioException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error:
            e.response?.data['message'] ??
            'Something went wrong. Please try again.',
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> resetPassword(String newPassword, String confirmPassword) async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await authServices.resetPassword(
        state.resetEmail ?? '',
        newPassword,
        confirmPassword,
        state.resetCode ?? '',
      );
      if (response) {
        state = state.copyWith(
          isLoading: false,
          resetEmail: null,
          resetCode: null,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Something went wrong. Please try again.',
        );
      }
    } on DioException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error:
            e.response?.data['message'] ??
            'Something went wrong. Please try again.',
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // ===========================================================================
  // 5. Private Helpers
  // ===========================================================================

  /// Consolidated logic for completing authentication (Login, Google, Apple)
  Future<void> _handleAuthCompletion({
    required AuthResponse? response,
    required OnboardingResult? onboardingResult,
    required WidgetRef ref,
    required String errorMessage,
    BuildContext? context,
  }) async {
    if (response == null) {
      state = state.copyWith(
        isLoading: false,
        googleLoading: false,
        appleLoading: false,
        error: errorMessage,
      );
      return;
    }
    final fbEvents = FacebookEventsService();
    fbEvents.logEvent(
      name: 'promise_profile',
      parameters: {'timestamp': DateTime.now().toIso8601String()},
      ref: ref,
      screenName: 'Promise Profile',
    );
    await prefs.saveLoggedUser(response);

    await Future.wait([
      getUserSubscription(),
      ref.read(promisesProvider.notifier).fetchPromises(),
    ]);

    await ref.read(challengeProvider.notifier).loadChallenge();

    state = state.copyWith(
      authUser: response,
      isLoading: false,
      googleLoading: false,
      appleLoading: false,
      onboardingData: OnboardingDataModel(
        onboardingResult: onboardingResult!,
        onboardingAnswers: state.onboardingData!.onboardingAnswers,
      ),
    );

    if (context != null && context.mounted) {
      final user = response.user;
      final promisesState = ref.read(promisesProvider);
      final challengeState = ref.read(challengeProvider);

      if (user.username == null || user.username!.isEmpty) {
        Navigator.of(context).pushReplacementNamed(
          SignUpBasicInfoScreen.routeName,
          arguments: user.email ?? '',
        );
        return;
      }

      if (!promisesState.hasPromises) {
        Navigator.of(context).pushReplacementNamed(
          PromiseProfileScreen.routeName,
          arguments: user.onboarding,
        );
        return;
      }

      final route = state.hasSubscription
          ? challengeState.isChallengeCompleted
                ? HomeDashboardPage.routeName
                : challengeState.isChallengeCreated
                ? challengeState.isUpdatedToday
                      ? HomeDashboardPage.routeName
                      : SevenDayChallengeScreen.routeName
                : ChallengeIntroScreen.routeName
          : HomeDashboardPage.routeName;

      Navigator.of(context).pushReplacementNamed(route);
    }
  }
}

final authenticationProvider =
    StateNotifierProvider<AuthenticationProvider, AuthenticationState>((ref) {
      return AuthenticationProvider();
    });
