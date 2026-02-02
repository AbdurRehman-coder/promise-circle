import 'package:sbp_app/features/onboarding/model/onboarding_answers.dart';
import 'package:sbp_app/features/onboarding/model/onboarding_result.dart';

class OnboardingDataModel {
  final OnboardingResult onboardingResult;
  final OnboardingAnswers onboardingAnswers;

  OnboardingDataModel({
    required this.onboardingResult,
    required this.onboardingAnswers,
  });

  factory OnboardingDataModel.fromJson(Map<String, dynamic> json) {
    return OnboardingDataModel(
      onboardingResult: OnboardingResult.fromJson(json['onboardingResult']),
      onboardingAnswers: OnboardingAnswers.fromJson(json['onboardingAnswers']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'onboardingResult': onboardingResult.toJson(),
      'onboardingAnswers': onboardingAnswers.toJson(),
    };
  }
}
