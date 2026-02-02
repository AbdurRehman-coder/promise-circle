import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sbp_app/core/services/app_services.dart';
import 'package:sbp_app/core/utils/app_extensions.dart';
import 'package:sbp_app/features/auth/provider/authentication_providr.dart';
import 'package:sbp_app/features/promise/data/options.dart';
import 'package:sbp_app/features/promise/models/create_promise_payload.dart';
import 'package:sbp_app/features/promise/models/promise_model.dart';
import 'package:sbp_app/features/promise/models/promise_result.dart';
import 'package:sbp_app/features/promise/provider/promise_list_provider.dart';
import 'package:sbp_app/features/promise/services/promise_services.dart';
import 'package:sbp_app/features/shared/providers/ai_examples_provider.dart';

import '../../../core/constants/promise_examples_data.dart';

class PromiseDraftState {
  final String? brokenPromise1;
  final String? brokenPromise2;
  final String? brokenPromise3;
  final Map<String, String> transformedPromises;
  final String description;
  final List<int> selectedCategoryIndices;
  final String reason1;
  final String reason2;
  final String? reason3;
  final String breakCost;
  final List<int> whoSelections;
  final Map<int, String> whoNames;
  final List<int> feelSelections;
  final Map<int, String> feelCustomValues;
  final bool isPrivate;
  final bool openToJoin;
  final List<ReminderPayload> reminders;

  const PromiseDraftState({
    this.brokenPromise1,
    this.brokenPromise2,
    this.brokenPromise3,
    this.transformedPromises = const {},
    this.description = '',
    this.selectedCategoryIndices = const [],
    this.reason1 = '',
    this.reason2 = '',
    this.reason3,
    this.breakCost = '',
    this.whoSelections = const [],
    this.whoNames = const {},
    this.feelSelections = const [],
    this.feelCustomValues = const {},
    this.isPrivate = true,
    this.openToJoin = false,
    this.reminders = const [],
  });

  PromiseDraftState copyWith({
    String? brokenPromise1,
    String? brokenPromise2,
    String? brokenPromise3,
    Map<String, String>? transformedPromises,
    String? description,
    List<int>? selectedCategoryIndices,
    String? reason1,
    String? reason2,
    String? reason3,
    String? breakCost,
    List<int>? whoSelections,
    Map<int, String>? whoNames,
    List<int>? feelSelections,
    Map<int, String>? feelCustomValues,
    bool? isPrivate,
    bool? openToJoin,
    List<ReminderPayload>? reminders,
  }) {
    return PromiseDraftState(
      brokenPromise1: brokenPromise1 ?? this.brokenPromise1,
      brokenPromise2: brokenPromise2 ?? this.brokenPromise2,
      brokenPromise3: brokenPromise3 ?? this.brokenPromise3,
      transformedPromises: transformedPromises ?? this.transformedPromises,
      description: description ?? this.description,
      selectedCategoryIndices:
          selectedCategoryIndices ?? this.selectedCategoryIndices,
      reason1: reason1 ?? this.reason1,
      reason2: reason2 ?? this.reason2,
      reason3: reason3 ?? this.reason3,
      breakCost: breakCost ?? this.breakCost,
      whoSelections: whoSelections ?? this.whoSelections,
      whoNames: whoNames ?? this.whoNames,
      feelSelections: feelSelections ?? this.feelSelections,
      feelCustomValues: feelCustomValues ?? this.feelCustomValues,
      isPrivate: isPrivate ?? this.isPrivate,
      openToJoin: openToJoin ?? this.openToJoin,
      reminders: reminders ?? this.reminders,
    );
  }
}

final promiseStepIndexProvider = StateProvider<int>((ref) => 0);
final promiseLoadingProvider = StateProvider<bool>((ref) => false);
final promiseResultProvider = StateProvider<PromiseResult?>((ref) => null);

class PromiseController extends Notifier<PromiseDraftState> {
  PromiseModel? _selectedPromise;
  PromiseModel? get selectedPromise => _selectedPromise;
  List<String> promiseExamples = [];
  static const List<String> _apiCategories = [
    'ambition',
    'purpose',
    'health',
    'fitness',
    'money',
    'finance',
    'focus',
    'productivity',
    'relationships',
    'boundaries',
    'self-worth',
    'growth',
  ];

  @override
  PromiseDraftState build() => const PromiseDraftState();
  Completer<void>? transformBrokenCompleter;
  bool? get isBrokenPromisesTranform => transformBrokenCompleter?.isCompleted;
  Future<void> transformBrokenOnes() async {
    transformBrokenCompleter = Completer();
    final services = locator.get<PromiseServices>();
    try {
      final result = await services.transformBrokenPromises(
        p1: state.brokenPromise1 ?? "",
        p2: state.brokenPromise2 ?? "",
        p3: state.brokenPromise3 ?? "",
      );
      if (result != null) {
        state = state.copyWith(transformedPromises: result);
      }
    } catch (e) {
      debugPrint("Background transformation failed: $e");
    } finally {
      transformBrokenCompleter!.complete();
    }
  }

  void selectAndMapTransformed(int index) {
    final key = "p$index";
    final transformedValue = state.transformedPromises[key];
    if (transformedValue != null && transformedValue.isNotEmpty) {
      state = state.copyWith(description: transformedValue);
    } else {
      state = state.copyWith(description: "I Promise ");
    }
  }

  void setBrokenPromise(int index, String value) {
    if (index == 1) state = state.copyWith(brokenPromise1: value);
    if (index == 2) state = state.copyWith(brokenPromise2: value);
    if (index == 3) state = state.copyWith(brokenPromise3: value);
  }

  void setDescription(String value) =>
      state = state.copyWith(description: value);

  void toggleCategory(int index) {
    final current = List<int>.from(state.selectedCategoryIndices);
    if (current.contains(index)) {
      current.remove(index);
    } else {
      if (current.length < 3) {
        current.add(index);
      }
    }
    state = state.copyWith(selectedCategoryIndices: current);
  }

  void setReason(int index, String value) {
    if (index == 1) state = state.copyWith(reason1: value);
    if (index == 2) state = state.copyWith(reason2: value);
    if (index == 3) state = state.copyWith(reason3: value);
  }

  void setBreakCost(String value) => state = state.copyWith(breakCost: value);

  void toggleWhoOption(int index, int? maxAllowed) {
    final current = List<int>.from(state.whoSelections);
    if (current.contains(index)) {
      current.remove(index);
    } else {
      if (maxAllowed != null && current.length >= maxAllowed) return;
      current.add(index);
    }
    state = state.copyWith(whoSelections: current);
  }

  void setWhoName(int index, String name) {
    final current = Map<int, String>.from(state.whoNames);
    if (name.isEmpty) {
      current.remove(index);
    } else {
      current[index] = name;
    }
    state = state.copyWith(whoNames: current);
  }

  void toggleFeelOption(int index, int? maxAllowed) {
    final current = List<int>.from(state.feelSelections);
    if (current.contains(index)) {
      current.remove(index);
    } else {
      if (maxAllowed != null && current.length >= maxAllowed) return;
      current.add(index);
    }
    state = state.copyWith(feelSelections: current);
  }

  void setFeelCustomValue(int index, String value) {
    final current = Map<int, String>.from(state.feelCustomValues);
    if (value.isEmpty) {
      current.remove(index);
    } else {
      current[index] = value;
    }
    state = state.copyWith(feelCustomValues: current);
  }

  void setPrivacy({bool? isPrivate, bool? openToJoin}) {
    state = state.copyWith(
      isPrivate: isPrivate ?? state.isPrivate,
      openToJoin: openToJoin ?? state.openToJoin,
    );
  }

  void setReminders(List<ReminderPayload> reminders) {
    state = state.copyWith(reminders: reminders);
  }

  void reset() {
    _selectedPromise = null;
    state = const PromiseDraftState();
  }

  // YOUR LOAD FOR EDIT FUNCTION (COMPLETELY RESTORED)
  void loadForEdit(PromiseModel promise) {
    _selectedPromise = promise;

    List<int> whoIndices =
        promise.who
            ?.map(
              (e) => whoSelectOptions.indexWhere(
                (opt) => opt.label.capitalize == e.option,
              ),
            )
            .where((i) => i != -1)
            .toList() ??
        [];

    Map<int, String> whoNamesMap = {};
    for (int i = 0; i < (promise.who?.length ?? 0); i++) {
      if (whoIndices.length > i && promise.who![i].names != null) {
        whoNamesMap[whoIndices[i]] = promise.who![i].names!;
      }
    }

    List<int> feelIndices =
        promise.feel
            ?.map(
              (e) =>
                  feelSelectOptions.indexWhere((opt) => opt.label == e.option),
            )
            .where((i) => i != -1)
            .toList() ??
        [];

    Map<int, String> feelCustomMap = {};
    for (int i = 0; i < (promise.feel?.length ?? 0); i++) {
      if (feelIndices.length > i && promise.feel![i].customValue != null) {
        feelCustomMap[feelIndices[i]] = promise.feel![i].customValue!;
      }
    }

    List<int> categoryIndices = [];
    if (promise.categories != null) {
      for (var part in promise.categories!) {
        final index = _apiCategories.indexWhere(
          (c) => c.toLowerCase() == part.trim().toLowerCase(),
        );
        if (index != -1) categoryIndices.add(index);
      }
    }

    state = PromiseDraftState(
      description: promise.description ?? '',
      reason1: promise.reasons?.reason1 ?? '',
      reason2: promise.reasons?.reason2 ?? '',
      reason3: promise.reasons?.reason3,
      breakCost: promise.breakCost ?? '',
      whoSelections: whoIndices,
      whoNames: whoNamesMap,
      feelSelections: feelIndices,
      feelCustomValues: feelCustomMap,
      brokenPromise1: promise.previousBrokenPromises?.reason1,
      brokenPromise2: promise.previousBrokenPromises?.reason2,
      brokenPromise3: promise.previousBrokenPromises?.reason3,
      selectedCategoryIndices: categoryIndices,
    );
  }

  bool isContinueEnabled(int step) {
    switch (step) {
      case 0:
        return (state.brokenPromise1?.isNotEmpty ?? false);
      case 1:
        return true;
      case 2:
        return state.description.trim().isNotEmpty &&
            state.description.trim().length > 10;
      case 3:
        return state.selectedCategoryIndices.length <= 3 &&
            state.selectedCategoryIndices.isNotEmpty;
      case 4:
        return state.reason1.trim().isNotEmpty;
      case 5:
        return state.breakCost.trim().isNotEmpty;
      case 6:
        return state.whoSelections.isNotEmpty;
      case 7:
        bool hasSelection = state.feelSelections.isNotEmpty;
        bool hasOtherText = state.feelCustomValues[8]?.isNotEmpty ?? false;
        return hasSelection || hasOtherText;
      default:
        return true;
    }
  }

  Future<void> submitPromise(BuildContext context, bool isEdit) async {
    ref.read(promiseLoadingProvider.notifier).state = true;
    try {
      final payload = _buildPayload();
      final services = locator.get<PromiseServices>();
      final result = isEdit
          ? await services.updatePromise(
              answers: payload,
              promiseId: _selectedPromise!.id!,
            )
          : await services.createPromise(answers: payload);

      if (result != null) {
        ref.read(promiseResultProvider.notifier).state = result;
        ref.read(promiseStepIndexProvider.notifier).state = 8;
        ref.read(promisesProvider.notifier).fetchPromises();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      ref.read(promiseLoadingProvider.notifier).state = false;
    }
  }

  CreatePromisePayload _buildPayload() {
    List<String> categoryString = state.selectedCategoryIndices
        .map((i) => _apiCategories[i])
        .toList();

    List<Feel> feelPayload = state.feelSelections
        .map(
          (i) => Feel(
            option: feelSelectOptions[i].label,
            customValue: state.feelCustomValues[i],
          ),
        )
        .toList();

    if (state.feelCustomValues.containsKey(8) &&
        state.feelCustomValues[8]!.isNotEmpty) {
      final isAlreadyAdded = feelPayload.any(
        (f) => f.option == feelSelectOptions[8].label,
      );
      if (!isAlreadyAdded) {
        feelPayload.add(
          Feel(
            option: feelSelectOptions[8].label,
            customValue: state.feelCustomValues[8],
          ),
        );
      }
    }

    return CreatePromisePayload(
      description: state.description,
      category: categoryString,
      reasons: Reasons(
        reason1: state.reason1,
        reason2: state.reason2,
        reason3: state.reason3,
      ),
      breakCost: state.breakCost,
      who: state.whoSelections
          .map(
            (i) => Who(
              option: whoSelectOptions[i].label.capitalize,
              names: state.whoNames[i],
            ),
          )
          .toList(),
      feel: feelPayload,
      previousBrokenPromises: state.brokenPromise1 != null
          ? PreviousBrokenPromises(
              promise1: state.brokenPromise1,
              promise2: state.brokenPromise2,
              promise3: state.brokenPromise3,
            )
          : null,
      obstacles: Obstacles(),
      reminders: null,
      isPrivate: state.isPrivate,
      openToJoin: state.openToJoin,
    );
  }

  Future<void> getPromiseReasonExample(
    WidgetRef ref, {
    bool showLoading = true,
  }) async {
    if (showLoading) {
      ref.read(promiseLoadingProvider.notifier).state = true;
    }
    await ref
        .read(aiExamplesControllerProvider.notifier)
        .getPromiseReason(
          description: state.description,
          previousBrokenPromises: {
            "promise1": state.brokenPromise1,
            "promise2": state.brokenPromise2,
            "promise3": state.brokenPromise3,
          },
        );
    if (showLoading) {
      ref.read(promiseLoadingProvider.notifier).state = false;
    }
  }

  Future<void> getPromiseExampleFromBroken(
    WidgetRef ref, {
    bool showLoading = true,
  }) async {
    if (showLoading) {
      ref.read(promiseLoadingProvider.notifier).state = true;
    }
    await ref
        .read(aiExamplesControllerProvider.notifier)
        .getPromiseFromBroken(
          previousBrokenPromises: {
            "promise1": state.brokenPromise1,
            "promise2": state.brokenPromise2,
            "promise3": state.brokenPromise3,
          },
        );
    if (showLoading) {
      ref.read(promiseLoadingProvider.notifier).state = false;
    }
  }

  Future<void> getPromiseCostExample(WidgetRef ref) async {
    ref.read(promiseLoadingProvider.notifier).state = true;
    await ref
        .read(aiExamplesControllerProvider.notifier)
        .getBreakCost(
          description: state.description,
          reasons: {
            "reason1": state.reason1,
            "reason2": state.reason2,
            "reason3": state.reason3,
          },
          previousBrokenPromises: {
            "promise1": state.brokenPromise1,
            "promise2": state.brokenPromise2,
            "promise3": state.brokenPromise3,
          },
        );
    ref.read(promiseLoadingProvider.notifier).state = false;
  }

  List<String> generatePromiseExamples(List<String> userMicrotags) {
    final List<String> matchingExamples = [];

    for (final tag in userMicrotags) {
      if (promiseExamplesMap.containsKey(tag)) {
        final examples = promiseExamplesMap[tag]!;
        matchingExamples.addAll(examples);
      }
    }

    return matchingExamples;
  }

  List<String> generate(List<String> userMicrotags) {
    final List<String> matchingExamples = [];

    for (final tag in userMicrotags) {
      if (promiseExamplesMap.containsKey(tag)) {
        final examples = promiseExamplesMap[tag]!;
        matchingExamples.addAll(examples);
      }
    }

    return matchingExamples;
  }

  String getRandomPromiseExample(WidgetRef ref) {
    if (promiseExamples.isEmpty) {
      promiseExamples = generatePromiseExamples(
        (ref
                .read(authenticationProvider)
                .authUser
                ?.user
                .onboarding
                ?.microtags) ??
            [],
      );
    }
    if (promiseExamples.isEmpty) {
      return 'I Promise ';
    }
    final random = Random();
    return promiseExamples[random.nextInt(promiseExamples.length)];
  }
}

final promiseControllerProvider =
    NotifierProvider<PromiseController, PromiseDraftState>(
      PromiseController.new,
    );
