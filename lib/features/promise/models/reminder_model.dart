// class ReminderModel {
//   final String? reminderType;
//   final DateTime? date;
//   final int? time;
//   final List<dynamic>? steps;

//   ReminderModel({
//     this.reminderType,
//     this.date,
//     this.time,
//     this.steps,
//   });

//   ReminderModel copyWith({
//     String? reminderType,
//     DateTime? date,
//     int? time,
//     List<dynamic>? steps,
//   }) {
//     return ReminderModel(
//       reminderType: reminderType ?? this.reminderType,
//       date: date ?? this.date,
//       time: time ?? this.time,
//       steps: steps ?? this.steps,
//     );
//   }

//   factory ReminderModel.fromJson(Map<String, dynamic> json) {
//     return ReminderModel(
//       reminderType: json['reminderType'],
//       date: json['date'] != null ? DateTime.parse(json['date']) : null,
//       time: json['time'],
//       steps: json['steps'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       "reminderType": reminderType,
//       "date": date?.toIso8601String(),
//       "time": time,
//       "steps": steps,
//     };
//   }
// }
