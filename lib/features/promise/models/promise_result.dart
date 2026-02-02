import 'dart:convert';

/// Model for Promise creation API response
class PromiseResult {
  final String id;
  final String user;
  final String description;
  final ReasonsResult reasons;
  final String breakCost;
  final List<WhoResult> who;
  final List<FeelResult> feel;
  final List<ReminderResult> reminders;
  final ObstaclesResult obstacles;
  final bool isPrivate;
  final bool openToJoin;
  final List<String> joinedBy;
  final String? promiseCircleId;
  final String createdAt;
  final List<String> categories;
  final String updatedAt;

  PromiseResult({
    required this.id,
    required this.user,
    required this.description,
    required this.reasons,
    required this.breakCost,
    required this.who,
    required this.feel,
    required this.reminders,
    required this.obstacles,
    required this.isPrivate,
    required this.openToJoin,
    required this.joinedBy,
    this.promiseCircleId,
    required this.createdAt,
    required this.updatedAt,
    required this.categories,
  });

  factory PromiseResult.fromJson(Map<String, dynamic> json) {
    return PromiseResult(
      id: json['_id'] ?? '',
      user: (json['user'] is Map ? json['user']['_id'] : json['user']) ?? '',
      description: json['description'] ?? '',
      reasons: ReasonsResult.fromJson(json['reasons'] ?? {}),
      breakCost: json['breakCost'] ?? '',
      categories: json['categories'] == null
          ? ["Category"]
          : (json['categories'] as List<dynamic>)
                .map((e) => e as String)
                .toList(),
      who:
          (json['who'] as List<dynamic>?)
              ?.map((w) => WhoResult.fromJson(w))
              .toList() ??
          [],
      feel:
          (json['feel'] as List<dynamic>?)
              ?.map((f) => FeelResult.fromJson(f))
              .toList() ??
          [],
      reminders:
          (json['reminders'] as List<dynamic>?)
              ?.map((r) => ReminderResult.fromJson(r))
              .toList() ??
          [],
      obstacles: ObstaclesResult.fromJson(json['obstacles'] ?? {}),
      isPrivate: json['isPrivate'] ?? true,
      openToJoin: json['openToJoin'] ?? false,
      joinedBy: List<String>.from(json['joinedBy'] ?? []),
      promiseCircleId: json['promiseCircleId'],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'user': user,
    'description': description,
    'reasons': reasons.toJson(),
    'breakCost': breakCost,
    'who': who.map((w) => w.toJson()).toList(),
    'feel': feel.map((f) => f.toJson()).toList(),
    'reminders': reminders.map((r) => r.toJson()).toList(),
    'obstacles': obstacles.toJson(),
    'isPrivate': isPrivate,
    'openToJoin': openToJoin,
    'joinedBy': joinedBy,
    if (promiseCircleId != null) 'promiseCircleId': promiseCircleId,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };

  static PromiseResult fromJsonString(String jsonStr) =>
      PromiseResult.fromJson(json.decode(jsonStr));

  String toJsonString() => json.encode(toJson());
}

class ReasonsResult {
  final String reason1;
  final String reason2;
  final String? reason3;

  ReasonsResult({required this.reason1, required this.reason2, this.reason3});

  factory ReasonsResult.fromJson(Map<String, dynamic> json) {
    return ReasonsResult(
      reason1: json['reason1'] ?? '',
      reason2: json['reason2'] ?? '',
      reason3: json['reason3'],
    );
  }

  Map<String, dynamic> toJson() => {
    'reason1': reason1,
    'reason2': reason2,
    if (reason3 != null) 'reason3': reason3,
  };
}

class WhoResult {
  final String option;
  final String? names;

  WhoResult({required this.option, this.names});

  factory WhoResult.fromJson(Map<String, dynamic> json) {
    return WhoResult(option: json['option'] ?? '', names: json['names']);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{'option': option};
    if (names != null) map['names'] = names!;
    return map;
  }
}

class FeelResult {
  final String option;
  final String? customValue;

  FeelResult({required this.option, this.customValue});

  factory FeelResult.fromJson(Map<String, dynamic> json) {
    return FeelResult(
      option: json['option'] ?? '',
      customValue: json['customValue'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{'option': option};
    if (customValue != null) map['customValue'] = customValue!;
    return map;
  }
}

class ObstaclesResult {
  final String obstacle1;
  final String obstacle2;
  final String obstacle3;
  final String resetStrategy;

  ObstaclesResult({
    required this.obstacle1,
    required this.obstacle2,
    required this.obstacle3,
    required this.resetStrategy,
  });

  factory ObstaclesResult.fromJson(Map<String, dynamic> json) {
    return ObstaclesResult(
      obstacle1: json['obstacle1'] ?? '',
      obstacle2: json['obstacle2'] ?? '',
      obstacle3: json['obstacle3'] ?? '',
      resetStrategy: json['resetStrategy'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'obstacle1': obstacle1,
    'obstacle2': obstacle2,
    'obstacle3': obstacle3,
    'resetStrategy': resetStrategy,
  };
}

class ReminderResult {
  final String reminderType;
  final String? startDate;
  final String? keepDate;

  final List<int>? keepDays;
  final double? keepTime;
  final List<ReminderStepResult>? stepReminders;

  ReminderResult({
    required this.reminderType,
    this.startDate,
    this.keepDays,
    this.keepDate,
    this.keepTime,
    this.stepReminders,
  });

  factory ReminderResult.fromJson(Map<String, dynamic> json) {
    return ReminderResult(
      reminderType: json['reminderType'] ?? 'SIMPLE',
      startDate: json['startDate'],
      keepDays: (json['keepDays'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      keepTime: (json['keepTime'] as num?)?.toDouble(),
      keepDate: json['keepDate'],
      stepReminders: (json['stepReminders'] as List<dynamic>?)
          ?.map((s) => ReminderStepResult.fromJson(s))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reminderType': reminderType,
      if (startDate != null) 'startDate': startDate,
      if (keepDate != null) 'keepDate': keepDate,
      if (keepDays != null) 'keepDays': keepDays,
      if (keepTime != null) 'keepTime': keepTime,
      if (stepReminders != null)
        'stepReminders': stepReminders!.map((s) => s.toJson()).toList(),
    };
  }
}

class ReminderStepResult {
  final String text;
  final String offset;

  ReminderStepResult({required this.text, required this.offset});

  factory ReminderStepResult.fromJson(Map<String, dynamic> json) {
    return ReminderStepResult(
      text: json['text'] ?? '',
      offset: json['offset'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'text': text, 'offset': offset};
}
