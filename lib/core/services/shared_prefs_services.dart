import 'dart:convert';
import 'package:sbp_app/features/onboarding/model/onboarding_data_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/models/auth_response_model.dart';

class SharedPrefServices {
  static const _firstTimeKey = 'isFirstTimeUser';
  static const String _authKey = "user_model";
  static const String _onboardingKey = "onboarding_data";

  late final SharedPreferences _prefs;

  SharedPrefServices._internal(this._prefs);

  static Future<SharedPrefServices> getInstance() async {
    final prefs = await SharedPreferences.getInstance();
    return SharedPrefServices._internal(prefs);
  }

  /// Save auth response
  Future<void> saveLoggedUser(AuthResponse response) async {
    final jsonString = jsonEncode(response.toJson());
    await _prefs.setString(_authKey, jsonString);
  }

  /// Load auth response
  Future<AuthResponse?> getLoggedUser() async {
    final jsonString = _prefs.getString(_authKey);
    if (jsonString == null) return null;

    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return AuthResponse.fromJson(jsonMap);
  }

  Future<void> saveOnboarding(OnboardingDataModel data) async {
    final jsonString = jsonEncode(data.toJson());
    await _prefs.setString(_onboardingKey, jsonString);
  }

  Future<OnboardingDataModel?> getOnboarding() async {
    final jsonString = _prefs.getString(_onboardingKey);
    if (jsonString == null) return null;

    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return OnboardingDataModel.fromJson(jsonMap);
  }

  Future<bool> isFirstTimeUser() async {
    if (_prefs.containsKey(_firstTimeKey)) return false;
    await _prefs.setBool(_firstTimeKey, false);
    return true;
  }

  Future<void> clearUserData() async {
    await _prefs.remove(_authKey);
  }

  Future<void> clearOnboarding() async {
    await _prefs.remove(_onboardingKey);
  }
}
