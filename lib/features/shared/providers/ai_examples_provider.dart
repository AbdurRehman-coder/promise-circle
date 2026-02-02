import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/ai_example_request_model.dart';
import '../../../core/services/ai_examples_service.dart';
import '../../onboarding/model/onboarding_result.dart';
import '../../auth/provider/authentication_providr.dart';

class AiExamplesState {
  final String? samplePromise;
  final String? promiseFromBroken;
  final String? promiseReason;
  final String? breakCost;
  final String? brokenPromiseFromLastYear;
  final List<String>? transformedPromises;
  final List<String>? actionSteps;

  const AiExamplesState({
    this.samplePromise,
    this.promiseFromBroken,
    this.promiseReason,
    this.breakCost,
    this.brokenPromiseFromLastYear,
    this.transformedPromises,
    this.actionSteps,
  });

  AiExamplesState copyWith({
    String? samplePromise,
    String? promiseFromBroken,
    String? promiseReason,
    String? breakCost,
    String? brokenPromiseFromLastYear,
    List<String>? transformedPromises,
    List<String>? actionSteps,
  }) {
    return AiExamplesState(
      samplePromise: samplePromise ?? this.samplePromise,
      promiseFromBroken: promiseFromBroken ?? this.promiseFromBroken,
      promiseReason: promiseReason ?? this.promiseReason,
      breakCost: breakCost ?? this.breakCost,
      brokenPromiseFromLastYear:
          brokenPromiseFromLastYear ?? this.brokenPromiseFromLastYear,
      transformedPromises: transformedPromises ?? this.transformedPromises,
      actionSteps: actionSteps ?? this.actionSteps,
    );
  }
}

final aiExamplesControllerProvider =
    AsyncNotifierProvider<AiExamplesController, AiExamplesState>(
      AiExamplesController.new,
    );

class AiExamplesController extends AsyncNotifier<AiExamplesState> {
  OnboardingResult? _cachedOnboardingResult;

  @override
  FutureOr<AiExamplesState> build() => const AiExamplesState();

  Future<void> init(OnboardingResult result) async {
    _cachedOnboardingResult = result;
    state = const AsyncValue.loading();
    try {
      await Future.wait([getSamplePromise(), getBrokenPromiseFromLastYear()]);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> getSamplePromise({String? theme}) async {
    _cachedOnboardingResult = ref
        .read(authenticationProvider)
        .authUser
        ?.user
        .onboarding;
    if (_cachedOnboardingResult == null) return;
    try {
      final request = GenerateSamplePromiseRequest.fromOnboarding(
        _cachedOnboardingResult!,
        theme: theme,
      );
      final response = await ref
          .read(aiServiceProvider)
          .generateSamplePromise(request);

      final content = response['data']['suggestionByAI'];
      final previousState = state.value ?? const AiExamplesState();

      state = AsyncValue.data(previousState.copyWith(samplePromise: content));
    } catch (e, st) {
      if (state.isLoading) rethrow;
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> getBrokenPromiseFromLastYear() async {
    _cachedOnboardingResult = ref
        .read(authenticationProvider)
        .authUser
        ?.user
        .onboarding;
    if (_cachedOnboardingResult == null) return;
    try {
      final request = GenerateSamplePromiseRequest.fromOnboarding(
        _cachedOnboardingResult!,
      );
      final response = await ref
          .read(aiServiceProvider)
          .generateBrokenPromiseFromLastYear(request);

      final content = response['data']['suggestionByAI'];
      final previousState = state.value ?? const AiExamplesState();

      state = AsyncValue.data(
        previousState.copyWith(brokenPromiseFromLastYear: content),
      );
    } catch (e, st) {
      if (state.isLoading) rethrow;
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> generatReminderActionSteps(String promise) async {
    try {
      state = AsyncValue.loading();
      final response = await ref
          .read(aiServiceProvider)
          .generatReminderActionSteps(promise);

      final content = (response['data']['action_points'] as List<dynamic>)
          .map((e) => e as String)
          .toList();
      final previousState = state.value ?? const AiExamplesState();

      state = AsyncValue.data(previousState.copyWith(actionSteps: content));
    } catch (e, st) {
      if (state.isLoading) rethrow;
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> getPromiseFromBroken({
    required Map<String, String?>? previousBrokenPromises,
  }) async {
    _cachedOnboardingResult = ref
        .read(authenticationProvider)
        .authUser
        ?.user
        .onboarding;
    if (_cachedOnboardingResult == null) return;
    state = const AsyncValue.loading();
    try {
      final request = GeneratePromiseFromBrokenRequest.fromOnboarding(
        result: _cachedOnboardingResult!,
        previousBrokenPromises: previousBrokenPromises,
      );
      final response = await ref
          .read(aiServiceProvider)
          .generatePromiseFromBroken(request);

      final content = response['data']['suggestionByAI'];
      final previousState = state.value ?? const AiExamplesState();

      state = AsyncValue.data(
        previousState.copyWith(promiseFromBroken: content),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> getPromiseReason({
    required String description,
    Map<String, String?>? previousBrokenPromises,
  }) async {
    _cachedOnboardingResult = ref
        .read(authenticationProvider)
        .authUser
        ?.user
        .onboarding;
    if (_cachedOnboardingResult == null) return;
    state = const AsyncValue.loading();
    try {
      final request = GeneratePromiseReasonRequest.fromOnboarding(
        result: _cachedOnboardingResult!,
        description: description,
        previousBrokenPromises: previousBrokenPromises,
      );
      final response = await ref
          .read(aiServiceProvider)
          .generatePromiseReason(request);

      final content = response['data']['suggestedReasonByAI'];
      final previousState = state.value ?? const AiExamplesState();

      state = AsyncValue.data(previousState.copyWith(promiseReason: content));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> getBreakCost({
    required String description,
    required Map<String, String?> reasons,
    Map<String, String?>? previousBrokenPromises,
  }) async {
    _cachedOnboardingResult = ref
        .read(authenticationProvider)
        .authUser
        ?.user
        .onboarding;
    if (_cachedOnboardingResult == null) return;
    state = const AsyncValue.loading();
    try {
      final request = GenerateBreakCostRequest.fromOnboarding(
        result: _cachedOnboardingResult!,
        description: description,
        reasons: reasons,
        previousBrokenPromises: previousBrokenPromises,
      );
      final response = await ref
          .read(aiServiceProvider)
          .generateBreakCost(request);

      final content = response['data']['suggestedBreakCostByAI'];
      final previousState = state.value ?? const AiExamplesState();

      state = AsyncValue.data(previousState.copyWith(breakCost: content));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // Future<void> transformPromises({
  //   required String p1,
  //   String? p2,
  //   String? p3,
  // }) async {
  //   state = const AsyncValue.loading();
  //   try {
  //     final request = TransformBrokenPromisesRequest(
  //       brokenPromise1: p1,
  //       brokenPromise2: p2,
  //       brokenPromise3: p3,
  //     );
  //     final response = await ref
  //         .read(aiServiceProvider)
  //         .transformBrokenPromises(request);

  //     final content = _extractList(response);
  //     final previousState = state.value ?? const AiExamplesState();

  //     state = AsyncValue.data(
  //       previousState.copyWith(transformedPromises: content),
  //     );
  //   } catch (e, st) {
  //     state = AsyncValue.error(e, st);
  //   }
  // }

  void reset() {
    state = const AsyncValue.data(AiExamplesState());
  }
}
