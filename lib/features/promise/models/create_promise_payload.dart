class CreatePromisePayload {
  final String description;
  final List<String> category;
  final Reasons reasons;
  final String breakCost;
  final List<Who> who;
  final List<Feel> feel;
  final List<ReminderPayload>? reminders;
  final Obstacles obstacles;
  final PreviousBrokenPromises? previousBrokenPromises;
  final bool isPrivate;
  final bool openToJoin;

  CreatePromisePayload({
    required this.description,
    required this.category,
    required this.reasons,
    required this.breakCost,
    required this.who,
    required this.feel,
    required this.reminders,
    required this.obstacles,
    this.previousBrokenPromises,
    required this.isPrivate,
    required this.openToJoin,
  });

  Map<String, dynamic> toJson() => {
    'description': description,
    'categories': category,
    'reasons': reasons.toJson(),
    'breakCost': breakCost,
    'who': who.map((e) => e.toJson()).toList(),
    'feel': feel.map((e) => e.toJson()).toList(),
    'reminders': reminders?.map((e) => e.toJson()).toList(),
    'obstacles': obstacles.toJson(),
    if (previousBrokenPromises != null)
      'previousBrokenPromises': previousBrokenPromises!.toJson(),
    'isPrivate': isPrivate,
    'openToJoin': openToJoin,
  };
}

class Reasons {
  final String reason1;
  final String reason2;
  final String? reason3;

  Reasons({required this.reason1, required this.reason2, this.reason3});

  Map<String, dynamic> toJson() => {
    'reason1': reason1,
    'reason2': reason2,
    if (reason3 != null && reason3!.isNotEmpty) 'reason3': reason3,
  };
}

class Who {
  final String option;
  final String? names;

  Who({required this.option, this.names});

  Map<String, dynamic> toJson() => {
    'option': option,
    if (names != null && names!.isNotEmpty) 'names': names,
  };
}

class Feel {
  final String option;
  final String? customValue;

  Feel({required this.option, this.customValue});

  Map<String, dynamic> toJson() => {
    'option': option,
    if (customValue != null && customValue!.isNotEmpty)
      'customValue': customValue,
  };
}

class ReminderPayload {
  final String reminderType;
  final String? date;
  final double? time;
  final List<ReminderStepPayload>? steps;

  ReminderPayload({
    required this.reminderType,
    this.date,
    this.time,
    this.steps,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {'reminderType': reminderType};
    if (reminderType == 'SIMPLE') {
      data['date'] = date;
      data['time'] = time;
    } else {
      data['steps'] = steps?.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class ReminderStepPayload {
  final int stepNumber;
  final String? description;
  final String date;
  final double time;

  ReminderStepPayload({
    required this.stepNumber,
    this.description,
    required this.date,
    required this.time,
  });

  Map<String, dynamic> toJson() => {
    'stepNumber': stepNumber,
    'description': description ?? 'Keep it',
    'date': date,
    'time': time,
  };
}

class Obstacles {
  final String obstacle1;
  final String obstacle2;
  final String obstacle3;
  final String resetStrategy;

  Obstacles({
    this.obstacle1 = 'Not specified',
    this.obstacle2 = 'Not specified',
    this.obstacle3 = 'Not specified',
    this.resetStrategy = 'Will reassess',
  });

  Map<String, dynamic> toJson() => {
    'obstacle1': obstacle1,
    'obstacle2': obstacle2,
    'obstacle3': obstacle3,
    'resetStrategy': resetStrategy,
  };
}

class PreviousBrokenPromises {
  final String? promise1;
  final String? promise2;
  final String? promise3;

  PreviousBrokenPromises({this.promise1, this.promise2, this.promise3});

  Map<String, dynamic> toJson() => {
    if (promise1 != null) 'promise1': promise1,
    if (promise2 != null) 'promise2': promise2,
    if (promise3 != null) 'promise3': promise3,
  };
}
