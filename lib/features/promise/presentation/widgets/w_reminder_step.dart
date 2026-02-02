// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';
// import 'package:sbp_app/core/theming/app_colors.dart';
// import 'package:sbp_app/core/utils/text_styles.dart';
// import 'package:sbp_app/core/widgets/w_custom_form_field.dart';
// import 'package:sbp_app/features/promise/models/promise_answers.dart' as models;
// import 'package:sbp_app/features/promise/provider/promise_controller.dart';
// import 'package:sbp_app/features/promise/provider/promise_provider.dart';

// /// Reminder step widget with SIMPLE and STEP reminder types
// class ReminderStep extends ConsumerStatefulWidget {
//   const ReminderStep({super.key});

//   @override
//   ConsumerState<ReminderStep> createState() => _ReminderStepState();
// }

// class _ReminderStepState extends ConsumerState<ReminderStep> {
//   String _reminderType = 'SIMPLE'; // 'SIMPLE' or 'STEP'
  
//   // For SIMPLE reminder
//   DateTime? _simpleDate;
//   TimeOfDay? _simpleTime;
  
//   // For STEP reminder (4 steps)
//   final List<DateTime?> _stepDates = [null, null, null, null];
//   final List<TimeOfDay?> _stepTimes = [null, null, null, null];
//   final List<TextEditingController> _stepDescControllers = List.generate(
//     4,
//     (index) => TextEditingController(),
//   );

//   @override
//   void initState() {
//     super.initState();
//     // Load existing reminders if any
//     final existingReminders = ref.read(promiseControllerProvider.notifier).getReminders();
//     if (existingReminders.isNotEmpty) {
//       final firstReminder = existingReminders.first;
//       _reminderType = firstReminder.reminderType;
      
//       if (_reminderType == 'SIMPLE') {
//         if (firstReminder.date != null) {
//           _simpleDate = DateTime.parse(firstReminder.date!);
//         }
//         if (firstReminder.time != null) {
//           final hours = firstReminder.time!.floor();
//           final minutes = ((firstReminder.time! - hours) * 60).round();
//           _simpleTime = TimeOfDay(hour: hours, minute: minutes);
//         }
//       } else if (_reminderType == 'STEP' && firstReminder.steps != null) {
//         for (int i = 0; i < firstReminder.steps!.length && i < 4; i++) {
//           final step = firstReminder.steps![i];
//           _stepDates[i] = DateTime.parse(step.date);
//           final hours = step.time.floor();
//           final minutes = ((step.time - hours) * 60).round();
//           _stepTimes[i] = TimeOfDay(hour: hours, minute: minutes);
//           if (step.description != null && step.description!.isNotEmpty) {
//             _stepDescControllers[i].text = step.description!;
//           }
//         }
//       }
//     }
//   }

//   @override
//   void dispose() {
//     for (final controller in _stepDescControllers) {
//       controller.dispose();
//     }
//     super.dispose();
//   }

//   void _saveReminders() {
//     List<models.Reminder> reminders = [];
    
//     if (_reminderType == 'SIMPLE') {
//       if (_simpleDate != null && _simpleTime != null) {
//         final time = _simpleTime!.hour + (_simpleTime!.minute / 60.0);
//         reminders.add(models.Reminder(
//           reminderType: 'SIMPLE',
//           date: _simpleDate!.toIso8601String().split('T')[0],
//           time: time,
//         ));
//       }
//     } else if (_reminderType == 'STEP') {
//       // Check if all 4 steps have dates and times
//       bool allStepsValid = true;
//       for (int i = 0; i < 4; i++) {
//         if (_stepDates[i] == null || _stepTimes[i] == null) {
//           allStepsValid = false;
//           break;
//         }
//       }
      
//       if (allStepsValid) {
//         final steps = <models.ReminderStep>[];
//         for (int i = 0; i < 4; i++) {
//           final time = _stepTimes[i]!.hour + (_stepTimes[i]!.minute / 60.0);
//           steps.add(models.ReminderStep(
//             stepNumber: i + 1,
//             description: _stepDescControllers[i].text.trim().isEmpty
//                 ? null
//                 : _stepDescControllers[i].text.trim(),
//             date: _stepDates[i]!.toIso8601String().split('T')[0],
//             time: time,
//           ));
//         }
        
//         reminders.add(models.Reminder(
//           reminderType: 'STEP',
//           steps: steps,
//         ));
//       }
//     }
    
//     ref.read(promiseControllerProvider.notifier).saveReminders(reminders);
//   }

//   Future<void> _pickDate(BuildContext context, {bool isSimple = true, int stepIndex = 0}) async {
//     final date = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime.now().add(const Duration(days: 365)),
//     );
    
//     if (date != null) {
//       setState(() {
//         if (isSimple) {
//           _simpleDate = date;
//         } else {
//           _stepDates[stepIndex] = date;
//         }
//       });
//       _saveReminders();
//     }
//   }

//   Future<void> _pickTime(BuildContext context, {bool isSimple = true, int stepIndex = 0}) async {
//     final time = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
    
//     if (time != null) {
//       setState(() {
//         if (isSimple) {
//           _simpleTime = time;
//         } else {
//           _stepTimes[stepIndex] = time;
//         }
//       });
//       _saveReminders();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Set Reminders',
//           textAlign: TextAlign.center,
//           style: AppTextStyles.headingTextStyleBogart,
//         ),
//         const SizedBox(height: 32),
//         Text(
//           'Choose how you want to be reminded',
//           style: AppTextStyles.bodyTextStyle.copyWith(
//             fontSize: 14,
//             color: AppColors.primaryBlackColor.withValues(alpha: 0.8),
//             fontWeight: FontWeight.w400,
//           ),
//         ),
//         const SizedBox(height: 24),
        
//         // Reminder Type Selection
//         Row(
//           children: [
//             Expanded(
//               child: _buildTypeButton('SIMPLE', 'Simple Reminder'),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: _buildTypeButton('STEP', 'Step Reminders'),
//             ),
//           ],
//         ),
//         const SizedBox(height: 24),
        
//         // Simple Reminder UI
//         if (_reminderType == 'SIMPLE') ...[
//           _buildSimpleReminderUI(context),
//         ],
        
//         // Step Reminder UI
//         if (_reminderType == 'STEP') ...[
//           _buildStepReminderUI(context),
//         ],
//       ],
//     );
//   }

//   Widget _buildTypeButton(String type, String label) {
//     final isSelected = _reminderType == type;
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _reminderType = type;
//         });
//         _saveReminders();
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//         decoration: BoxDecoration(
//           color: isSelected ? AppColors.secondaryBlueColor : AppColors.whiteColor,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: isSelected ? AppColors.secondaryBlueColor : AppColors.grey200Color,
//           ),
//         ),
//         child: Text(
//           label,
//           textAlign: TextAlign.center,
//           style: AppTextStyles.bodyTextStyle.copyWith(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             color: isSelected ? AppColors.whiteColor : AppColors.primaryBlackColor,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSimpleReminderUI(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Pick a date and time',
//           style: AppTextStyles.bodyTextStyle.copyWith(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         const SizedBox(height: 12),
//         Row(
//           children: [
//             Expanded(
//               child: GestureDetector(
//                 onTap: () => _pickDate(context, isSimple: true),
//                 child: Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: AppColors.whiteColor,
//                     borderRadius: BorderRadius.circular(16),
//                     border: Border.all(color: AppColors.grey200Color),
//                   ),
//                   child: Row(
//                     children: [
//                       const Icon(Icons.calendar_today, size: 18),
//                       const SizedBox(width: 8),
//                       Text(
//                         _simpleDate != null
//                             ? DateFormat('MMM dd, yyyy').format(_simpleDate!)
//                             : 'Select Date',
//                         style: AppTextStyles.bodyTextStyle.copyWith(fontSize: 14),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: GestureDetector(
//                 onTap: () => _pickTime(context, isSimple: true),
//                 child: Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: AppColors.whiteColor,
//                     borderRadius: BorderRadius.circular(16),
//                     border: Border.all(color: AppColors.grey200Color),
//                   ),
//                   child: Row(
//                     children: [
//                       const Icon(Icons.access_time, size: 18),
//                       const SizedBox(width: 8),
//                       Text(
//                         _simpleTime != null
//                             ? _simpleTime!.format(context)
//                             : 'Select Time',
//                         style: AppTextStyles.bodyTextStyle.copyWith(fontSize: 14),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildStepReminderUI(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Set 4 steps leading to your promise',
//           style: AppTextStyles.bodyTextStyle.copyWith(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         const SizedBox(height: 16),
//         ...List.generate(4, (index) {
//           return Padding(
//             padding: const EdgeInsets.only(bottom: 16),
//             child: Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: AppColors.whiteColor,
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(color: AppColors.grey200Color),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Step ${index + 1}${index == 3 ? " (Keep it)" : ""}',
//                     style: AppTextStyles.bodyTextStyle.copyWith(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   if (index < 3)
//                     CustomTextField(
//                       controller: _stepDescControllers[index],
//                       hintText: 'Describe this step...',
//                       maxLines: 1,
//                       textCapitalization: TextCapitalization.sentences,
//                       onChange: (_) => _saveReminders(),
//                     ),
//                   const SizedBox(height: 12),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: GestureDetector(
//                           onTap: () => _pickDate(context, isSimple: false, stepIndex: index),
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
//                             decoration: BoxDecoration(
//                               color: AppColors.backgroundColor,
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 const Icon(Icons.calendar_today, size: 16),
//                                 const SizedBox(width: 6),
//                                 Expanded(
//                                   child: Text(
//                                     _stepDates[index] != null
//                                         ? DateFormat('MMM dd').format(_stepDates[index]!)
//                                         : 'Date',
//                                     style: AppTextStyles.bodyTextStyle.copyWith(fontSize: 12),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: GestureDetector(
//                           onTap: () => _pickTime(context, isSimple: false, stepIndex: index),
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
//                             decoration: BoxDecoration(
//                               color: AppColors.backgroundColor,
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 const Icon(Icons.access_time, size: 16),
//                                 const SizedBox(width: 6),
//                                 Expanded(
//                                   child: Text(
//                                     _stepTimes[index] != null
//                                         ? _stepTimes[index]!.format(context)
//                                         : 'Time',
//                                     style: AppTextStyles.bodyTextStyle.copyWith(fontSize: 12),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }),
//       ],
//     );
//   }
// }

