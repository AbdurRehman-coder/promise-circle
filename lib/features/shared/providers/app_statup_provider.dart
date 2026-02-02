import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sbp_app/features/auth/provider/authentication_providr.dart';
import 'package:sbp_app/features/promise/provider/promise_list_provider.dart';
import 'package:sbp_app/features/shared/providers/app_initialization_provider.dart';

enum AppStartupState {
  loading,
  unauthenticated,
  basicInfoNeeded,
  onboardingNeeded,
  promiseCreation,
  home,
}

final appStartupProvider = Provider<AppStartupState>((ref) {
  final init = ref.watch(appInitializationProvider);
  final authState = ref.watch(authenticationProvider);
  final promisesState = ref.watch(promisesProvider);

  if (init.isLoading || authState.initialLoading) {
    return AppStartupState.loading;
  }

  if (!authState.isAuthenticated) {
    return AppStartupState.unauthenticated;
  }

  final user = authState.authUser!.user;

  if (!(user.username?.isNotEmpty ?? false)) {
    return AppStartupState.basicInfoNeeded;
  }

  if (!(user.onboarding?.completed ?? false)) {
    return AppStartupState.onboardingNeeded;
  }

  if (promisesState.promises.isEmpty) {
    return AppStartupState.promiseCreation;
  }

  return AppStartupState.home;
});