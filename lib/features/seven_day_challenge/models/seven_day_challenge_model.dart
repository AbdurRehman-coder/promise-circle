// --- API Model ---

class SevenDayChallenge {
  final String id;
  final String userID;
  final bool dayOne;
  final bool dayTwo;
  final bool dayThree;
  final bool dayFour;
  final bool dayFive;
  final bool daySix;
  final bool daySeven;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? updatedFromUser;

  SevenDayChallenge({
    required this.id,
    required this.userID,
    this.dayOne = false,
    this.dayTwo = false,
    this.dayThree = false,
    this.dayFour = false,
    this.dayFive = false,
    this.daySix = false,
    this.daySeven = false,
    required this.createdAt,
    required this.updatedAt,
    required this.updatedFromUser,
  });

  bool get isCreated => id.isNotEmpty;

  bool get isCompleted => currentDayIndex > 7;

  factory SevenDayChallenge.fromJson(Map<String, dynamic> json) {
    return SevenDayChallenge(
      id: json['_id'] as String,
      userID: json['userID'] as String,
      dayOne: json['dayOne'] as bool? ?? false,
      dayTwo: json['dayTwo'] as bool? ?? false,
      dayThree: json['dayThree'] as bool? ?? false,
      dayFour: json['dayFour'] as bool? ?? false,
      dayFive: json['dayFive'] as bool? ?? false,
      daySix: json['daySix'] as bool? ?? false,
      daySeven: json['daySeven'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
      updatedFromUser: json['updatedAtFromUser'] != null
          ? DateTime.parse(json['updatedAtFromUser'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userID': userID,
      'dayOne': dayOne,
      'dayTwo': dayTwo,
      'dayThree': dayThree,
      'dayFour': dayFour,
      'dayFive': dayFive,
      'daySix': daySix,
      'daySeven': daySeven,
      'updatedAtFromUser': DateTime.now().toIso8601String(),
    };
  }

  int get currentDayIndex {
    if (!dayOne) return 1;
    if (!dayTwo) return 2;
    if (!dayThree) return 3;
    if (!dayFour) return 4;
    if (!dayFive) return 5;
    if (!daySix) return 6;
    if (!daySeven) return 7;
    return 8;
  }
}

class ChallengeDayContent {
  final String theme;
  final String title;
  final String? prompt;
  final String body;
  final List<String> examples;
  final String bottomCopy;
  final String ctaText;

  final String notifMorning;
  final String notifAfternoon;
  final String notifEvening;

  const ChallengeDayContent({
    required this.theme,
    required this.title,
    this.prompt,
    required this.body,
    this.examples = const [],
    required this.bottomCopy,
    required this.ctaText,
    required this.notifMorning,
    required this.notifAfternoon,
    required this.notifEvening,
  });
}
