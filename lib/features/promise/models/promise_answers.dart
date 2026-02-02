import 'package:sbp_app/features/promise/models/broken_promise.dart';

/// Model for Promise creation request payload
class PromiseAnswers {
  final String description;
  final Reasons reasons;
  final String breakCost;
  final List<Who> who;
  final List<Feel> feel;
  final Obstacles obstacles;
  final List<Reminder> reminders;
  final bool isPrivate;
  final bool openToJoin;
  final List<String>? joinedBy;
  final String? promiseCircleId;
  final BrokenPromiseModel? previousBrokenPromises;

  PromiseAnswers({
    required this.description,
    required this.reasons,
    required this.breakCost,
    required this.who,
    required this.feel,
    required this.obstacles,
    required this.reminders,
    required this.isPrivate,
    required this.openToJoin,
    this.joinedBy,
    this.promiseCircleId,
    this.previousBrokenPromises
  });

  Map<String, dynamic> toJson() => {
        "description": description,
        "reasons": reasons.toJson(),
        "breakCost": breakCost,
        "who": who.map((w) => w.toJson()).toList(),
        "feel": feel.map((f) => f.toJson()).toList(),
        "obstacles": obstacles.toJson(),
        "reminders": reminders.map((r) => r.toJson()).toList(),
        "isPrivate": isPrivate,
        "openToJoin": openToJoin,
        if(previousBrokenPromises!=null )"previousBrokenPromises":previousBrokenPromises?.toJson(),
        if (joinedBy != null) "joinedBy": joinedBy,
        if (promiseCircleId != null) "promiseCircleId": promiseCircleId,
      };
}

class Reasons {
  final String reason1;
  final String reason2;
  final String? reason3;

  Reasons({
    required this.reason1,
    required this.reason2,
    this.reason3,
  });

  Map<String, dynamic> toJson() => {
        "reason1": reason1,
        "reason2": reason2,
        if (reason3 != null && reason3!.isNotEmpty) "reason3": reason3,
      };
}

class Who {
  final String option; // 'Just me' | 'My friends' | 'My lover' | 'My business' | 'My clients' | 'My family' | 'Others'
  final String? names; // Required unless option === 'Just me'

  Who({
    required this.option,
    this.names,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{"option": option};
    if (names != null && names!.isNotEmpty) {
      map["names"] = names!;
    }
    return map;
  }
}

class Feel {
  final String option; // 'Proud' | 'Free' | 'Confident' | 'Calm' | 'Grateful' | 'Empowered' | 'Inspired' | 'Fulfilled' | 'Other'
  final String? customValue; // Required when option === 'Other'

  Feel({
    required this.option,
    this.customValue,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{"option": option};
    if (customValue != null && customValue!.isNotEmpty) {
      map["customValue"] = customValue!;
    }
    return map;
  }
}

class Obstacles {
  final String obstacle1;
  final String obstacle2;
  final String obstacle3;
  final String resetStrategy;

  Obstacles({
    required this.obstacle1,
    required this.obstacle2,
    required this.obstacle3,
    required this.resetStrategy,
  });

  Map<String, dynamic> toJson() => {
        "obstacle1": obstacle1,
        "obstacle2": obstacle2,
        "obstacle3": obstacle3,
        "resetStrategy": resetStrategy,
      };
}

class Reminder {
  final String reminderType; // 'SIMPLE' | 'STEP'
  final String? date; // ISO date when type === SIMPLE
  final double? time; // 0-24 float (24h), required with SIMPLE date
  final List<ReminderStep>? steps; // exactly 4 items when type === STEP

  Reminder({
    required this.reminderType,
    this.date,
    this.time,
    this.steps,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{"reminderType": reminderType};
    
    if (reminderType == 'SIMPLE') {
      if (date != null) map["date"] = date;
      if (time != null) map["time"] = time;
    } else if (reminderType == 'STEP') {
      if (steps != null) {
        map["steps"] = steps!.map((s) => s.toJson()).toList();
      }
    }
    
    return map;
  }
}

class ReminderStep {
  final int stepNumber; // 1 | 2 | 3 | 4
  final String? description; // auto-set to "Keep it" for step 4
  final String date; // ISO date per step
  final double time; // 0-24 float per step

  ReminderStep({
    required this.stepNumber,
    this.description,
    required this.date,
    required this.time,
  });

  Map<String, dynamic> toJson() => {
        "stepNumber": stepNumber,
        if (description != null && description!.isNotEmpty) "description": description,
        "date": date,
        "time": time,
      };
}

