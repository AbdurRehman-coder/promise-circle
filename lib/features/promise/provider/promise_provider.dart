// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:sbp_app/core/services/app_services.dart';
// import 'package:sbp_app/core/theming/app_colors.dart';
// import 'package:sbp_app/features/promise/data/options.dart';
// import 'package:sbp_app/features/promise/models/broken_promise.dart';
// import 'package:sbp_app/features/promise/models/promise_answers.dart';
// import 'package:sbp_app/features/promise/models/promise_model.dart';
// import 'package:sbp_app/features/promise/models/promise_result.dart';
// import 'package:sbp_app/features/promise/provider/promises_provider.dart';
// import 'package:sbp_app/features/promise/services/promise_services.dart';

// /// Provider for current step index (0-based)
// final promiseStepIndexProvider = StateProvider<int>((ref) => 0);
// final promiseBrokeStepDone = StateProvider<bool>((ref) => false);

// /// Provider for loading state
// final promiseLoadingProvider =
//     StateNotifierProvider<PromiseLoadingNotifier, bool>(
//       (_) => PromiseLoadingNotifier(),
//     );

// class PromiseLoadingNotifier extends StateNotifier<bool> {
//   PromiseLoadingNotifier() : super(false);

//   void setLoading(bool value) => state = value;
// }

// /// Provider for created promise result
// final promiseResultProvider = StateProvider<PromiseResult?>((ref) => null);

// /// Main Promise Controller - handles all state and business logic
// class PromiseController extends Notifier<Map<int, dynamic>> {
//   // State structure: Map<stepIndex, dynamic>
//   // Step 0 (Define): {'description': String}
//   // Step 1 (Why): {'reason1': String, 'reason2': String, 'reason3': String?}
//   // Step 2 (Cost): {'breakCost': String}
//   // Step 3 (Who): {'selections': List<int>, 'names': Map<int, String>}
//   // Step 4 (Feel): {'selections': List<int>, 'customValues': Map<int, String>}
//   // Step 5 (Obstacles): {'obstacle1': String, 'obstacle2': String, 'obstacle3': String, 'resetStrategy': String}
//   // Step 6 (Reminders): {'reminders': List<Reminder>}
//   // Step 7 (Privacy): {'isPrivate': bool, 'openToJoin': bool}

//   @override
//   Map<int, dynamic> build() => {};

//   /// Save text input for a specific step and key
//   void saveTextInput(int step, String key, String value) {
//     final currentStepData = state[step] ?? {};
//     state = {
//       ...state,
//       step: {...currentStepData, key: value},
//     };
//   }

//   /// Toggle option selection for multi-select steps (Who, Feel)
//   void toggleOption({
//     required int step,
//     required int optionIndex,
//     int? maxAllowed,
//   }) {
//     final currentStepData = state[step] ?? {};
//     final selections = List<int>.from(currentStepData['selections'] ?? []);

//     if (selections.contains(optionIndex)) {
//       selections.remove(optionIndex);
//     } else {
//       if (maxAllowed != null && selections.length >= maxAllowed) return;
//       selections.add(optionIndex);
//     }

//     state = {
//       ...state,
//       step: {...currentStepData, 'selections': selections},
//     };
//   }

//   /// Check if an option is selected
//   bool isSelected(int step, int optionIndex) {
//     final selections = state[step]?['selections'] as List<int>?;
//     return selections?.contains(optionIndex) ?? false;
//   }

//   /// Save name for a "who" option
//   void saveWhoName(int optionIndex, String name) {
//     final currentStepData = state[3] ?? {};
//     final names = Map<int, String>.from(currentStepData['names'] ?? {});

//     if (name.isEmpty) {
//       names.remove(optionIndex);
//     } else {
//       names[optionIndex] = name;
//     }

//     state = {
//       ...state,
//       3: {...currentStepData, 'names': names},
//     };
//   }

//   /// Get name for a "who" option
//   String getWhoName(int optionIndex) {
//     final names = state[3]?['names'] as Map<int, String>?;
//     return names?[optionIndex] ?? '';
//   }

//   /// Save custom value for "Other" feeling
//   void saveFeelCustomValue(int optionIndex, String customValue) {
//     final currentStepData = state[4] ?? {};
//     final customValues = Map<int, String>.from(
//       currentStepData['customValues'] ?? {},
//     );

//     if (customValue.isEmpty) {
//       customValues.remove(optionIndex);
//     } else {
//       customValues[optionIndex] = customValue;
//     }

//     state = {
//       ...state,
//       4: {...currentStepData, 'customValues': customValues},
//     };
//   }

//   /// Get custom value for "Other" feeling
//   String getFeelCustomValue(int optionIndex) {
//     final customValues = state[4]?['customValues'] as Map<int, String>?;
//     return customValues?[optionIndex] ?? '';
//   }

//   /// Save reminders data
//   void saveReminders(List<Reminder> reminders) {
//     state = {
//       ...state,
//       6: {'reminders': reminders},
//     };
//   }

//   /// Get reminders
//   List<Reminder> getReminders() {
//     return state[6]?['reminders'] as List<Reminder>? ?? [];
//   }

//   /// Toggle privacy settings
//   void togglePrivacy(String key, bool value) {
//     final currentStepData = state[7] ?? {};
//     state = {
//       ...state,
//       7: {...currentStepData, key: value},
//     };
//   }

//   /// Validation: Check if Continue button should be enabled for current step
//   bool isContinueEnabled(int step) {
//     switch (step) {
//       case 0:
//         final brokenPromises1 = state[0]?['promise1'] as String?;
//         final brokenPromises2 = state[0]?['promise2'] as String?;
//         return brokenPromises1 != null &&
//             brokenPromises1.trim().isNotEmpty &&
//             brokenPromises2 != null &&
//             brokenPromises2.trim().isNotEmpty;
//       case 1:
//         final description = state[1]?['description'] as String?;
//         return description != null && description.trim().isNotEmpty;
//       case 2:
//         return true;
//       case 3: // Why
//         final reason1 = state[2]?['reason1'] as String?;
//         final reason2 = state[2]?['reason2'] as String?;
//         return reason1 != null &&
//             reason1.trim().isNotEmpty &&
//             reason2 != null &&
//             reason2.trim().isNotEmpty;
//       // case 3: // Define
//       //   final description = state[1]?['description'] as String?;
//       //   return description != null && description.trim().isNotEmpty;

//       case 4: // Cost
//         final breakCost = state[3]?['breakCost'] as String?;
//         return breakCost != null && breakCost.trim().isNotEmpty;

//       case 5: // Who
//         final selections = state[4]?['selections'] as List<int>?;
//         if (selections == null || selections.isEmpty) return false;

//         // Check if names are provided for options that need them
//         // final names = state[3]?['names'] as Map<int, String>?;
//         // for (final index in selections) {
//         //   // If not "Just me" (index 0), require name
//         //   if (index != 0) {
//         //     final name = names?[index];
//         //     if (name == null || name.trim().isEmpty) return false;
//         //   }
//         // }
//         return true;

//       case 6: // Feel (second to last screen)
//         final selections = state[4]?['selections'] as List<int>?;
//         if (selections == null || selections.isEmpty) return false;

//         // Check if custom values are provided for "Other" options
//         final customValues = state[5]?['customValues'] as Map<int, String>?;
//         for (final index in selections) {
//           // Check if this is the "Other" option (last option, index 8)
//           if (index == 8) {
//             final customValue = customValues?[index];
//             if (customValue == null || customValue.trim().isEmpty) return false;
//           }
//         }
//         return true;

//       case 7: // Review - always enabled
//         return true;

//       default:
//         return false;
//     }
//   }

//   /// Build final payload for API
//   PromiseAnswers buildFinalPayload() {
//     // Who options list
//     final whoOptions = [
//       'Just me',
//       'My friends',
//       'My lover',
//       'My business',
//       'My clients',
//       'My family',
//       'Others',
//     ];

//     // Feel options list
//     final feelOptions = [
//       'Proud',
//       'Free',
//       'Confident',
//       'Calm',
//       'Grateful',
//       'Empowered',
//       'Inspired',
//       'Fulfilled',
//       'Other',
//     ];

//     // Build Who list
//     final whoSelections = state[4]?['selections'] as List<int>? ?? [];
//     final whoNames = state[4]?['names'] as Map<int, String>? ?? {};
//     final who = whoSelections.map((index) {
//       final option = whoOptions[index];
//       final names = whoNames[index];
//       return Who(option: option, names: names);
//     }).toList();

//     // Build Feel list
//     final feelSelections = state[4]?['selections'] as List<int>? ?? [];
//     final feelCustomValues =
//         state[4]?['customValues'] as Map<int, String>? ?? {};
//     final feel = feelSelections.map((index) {
//       final option = feelOptions[index];
//       final customValue = feelCustomValues[index];
//       return Feel(option: option, customValue: customValue);
//     }).toList();

//     return PromiseAnswers(
//       description: state[1]?['description'] ?? '',
//       reasons: Reasons(
//         reason1: state[2]?['reason1'] ?? '',
//         reason2: state[2]?['reason2'] ?? '',
//         reason3: state[2]?['reason3'],
//       ),
//       breakCost: state[3]?['breakCost'] ?? '',
//       who: who,
//       feel: feel,
//       // Default values for removed screens
//       obstacles: Obstacles(
//         obstacle1: 'Not specified',
//         obstacle2: 'Not specified',
//         obstacle3: 'Not specified',
//         resetStrategy: 'Will reassess and try again',
//       ),
//       previousBrokenPromises: state[0]?['promise1'] == null
//           ? null
//           : BrokenPromiseModel(
//               reason1: state[0]?['promise1'] ?? '',
//               reason2: state[0]?['promise2'] ?? '',
//               reason3: state[0]?['promise3'] ?? '',
//             ),
//       reminders: [
//         Reminder(
//           reminderType: 'SIMPLE',
//           date: DateTime.now()
//               .add(const Duration(days: 1))
//               .toIso8601String()
//               .split('T')[0],
//           time: 9.0, // 9 AM default
//         ),
//       ],
//       isPrivate: true,
//       openToJoin: false,
//     );
//   }

//   Future<void> updatePromise(BuildContext context) async {
//     final loadingNotifier = ref.read(promiseLoadingProvider.notifier);
//     loadingNotifier.setLoading(true);

//     try {
//       final payload = buildFinalPayload();
//       final services = locator.get<PromiseServices>();
//       final result = await services.updatePromise(
//         answers: payload,
//         promiseId: selectedPromise!.id!,
//       );

//       if (result != null) {
//         ref.read(promiseResultProvider.notifier).state = result;
//         // Move to review screen
//         ref.read(promiseStepIndexProvider.notifier).state = 7;
//         // selectedPromise = null;
//         // state = {};
//         ref.read(promisesProvider.notifier).getPromises();
//       } else {
//         if (context.mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text("Something went wrong. Please try again."),
//             ),
//           );
//         }
//       }
//     } catch (e) {
//       log("❌ Error updating promise: ", error: e);
//       if (context.mounted) {
//         log("❌ Error updating promise: ", error: e);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("Failed to update promise: ${e.toString()}"),
//             backgroundColor: AppColors.errorColor,
//           ),
//         );
//       }
//     } finally {
//       loadingNotifier.setLoading(false);
//     }
//   }

//   /// Create promise via API
//   Future<void> createPromise(BuildContext context) async {
//     final loadingNotifier = ref.read(promiseLoadingProvider.notifier);
//     loadingNotifier.setLoading(true);

//     try {
//       final payload = buildFinalPayload();
//       final services = locator.get<PromiseServices>();
//       final result = await services.createPromise(answers: payload);

//       if (result != null) {
//         ref.read(promiseResultProvider.notifier).state = result;
//         // Move to review screen
//         ref.read(promiseStepIndexProvider.notifier).state = 7;
//         ref.read(promisesProvider.notifier).getPromises();
//       } else {
//         if (context.mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text("Something went wrong. Please try again."),
//             ),
//           );
//         }
//       }
//     } catch (e) {
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("Failed to create promise: ${e.toString()}"),
//             backgroundColor: AppColors.errorColor,
//           ),
//         );
//       }
//     } finally {
//       loadingNotifier.setLoading(false);
//     }
//   }

//   PromiseModel? selectedPromise;

//   void selectPromise(PromiseModel promise) {
//     selectedPromise = promise;
//     List<int> whoOptionsSelections =
//         promise.who?.map((e) => whoOptions.indexOf(e.option!)).toList() ?? [];
//     int index = whoOptionsSelections.indexOf(-1);
//     if (index != -1) {
//       whoOptionsSelections[index] = 2;
//     }

//     List<int> feelOptionsSelections =
//         promise.feel?.map((e) => feelOptions.indexOf(e.option!)).toList() ?? [];
//     state = {
//       0: {
//         'reason1': promise.previousBrokenPromises?.reason1,
//         'reason2': promise.previousBrokenPromises?.reason2,
//         'reason3': promise.previousBrokenPromises?.reason3,
//       },
//       1: {'description': promise.description},
//       2: {
//         'reason1': promise.reasons?.reason1,
//         'reason2': promise.reasons?.reason2,
//         'reason3': promise.reasons?.reason3,
//       },
//       3: {"breakCost": promise.breakCost},
//       4: {
//         "selections": whoOptionsSelections,
//         'names': {
//           for (int i = 0; i < whoOptionsSelections.length; i++)
//             whoOptionsSelections[i]: promise.who?[i].names ?? '',
//         },
//       },
//       5: {
//         "selections": feelOptionsSelections,
//         'customValues': {
//           for (int i = 0; i < feelOptionsSelections.length; i++)
//             feelOptionsSelections[i]: promise.feel?[i].customValue ?? '',
//         },
//       },
//       6: {},
//     };
//   }
// }

// final promiseControllerProvider =
//     NotifierProvider<PromiseController, Map<int, dynamic>>(
//       PromiseController.new,
//     );
