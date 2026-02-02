import 'package:get_it/get_it.dart';
import 'package:sbp_app/core/services/shared_prefs_services.dart';
import 'package:sbp_app/features/auth/services/auth_services.dart';
import 'package:sbp_app/features/invite/services/invite_service.dart';
import 'package:sbp_app/features/onboarding/services/onboarding_services.dart';
import 'package:sbp_app/features/profile/services/profile_services.dart';
import 'package:sbp_app/features/promise/services/promise_services.dart';
import 'package:sbp_app/features/promise/services/reflection_services.dart';
import 'package:sbp_app/features/seven_day_challenge/services/challenge_services.dart';

import 'api_client.dart';
import 'apple_auth_services.dart';

final GetIt locator = GetIt.instance;

void initServices(SharedPrefServices sharedPrefService) {
  locator.registerSingleton<SharedPrefServices>(sharedPrefService);
  locator.registerSingleton<ApiClient>(ApiClient());
  locator.registerSingleton<OnboardingServices>(
    OnboardingServices(locator.get<ApiClient>()),
  );
  locator.registerSingleton<InviteService>(
    InviteService(locator.get<ApiClient>()),
  );
  locator.registerSingleton<AuthServices>(
    AuthServices(locator.get<ApiClient>()),
  );
  locator.registerSingleton<PromiseServices>(
    PromiseServices(locator.get<ApiClient>()),
  );
  locator.registerSingleton<ProfileServices>(
    ProfileServices(locator.get<ApiClient>()),
  );
  locator.registerSingleton<ChallengeServices>(
    ChallengeServices(locator.get<ApiClient>()),
  );
  locator.registerSingleton<ReflectionServices>(
    ReflectionServices(locator.get<ApiClient>()),
  );

  // locator.registerSingleton<GoogleAuthService>(GoogleAuthService());
  locator.registerSingleton<AppleAuthServices>(AppleAuthServices());
}
