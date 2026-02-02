class AppSettingsResponse {
  final String message;
  final AppSettingsData data;

  AppSettingsResponse({required this.message, required this.data});

  factory AppSettingsResponse.fromJson(Map<String, dynamic> json) {
    return AppSettingsResponse(
      message: json['message'] ?? '',
      data: AppSettingsData.fromJson(json['data'] ?? {}),
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {'message': message, 'data': data.toJson()};
  // }
}

class AppSettingsData {
  final bool paywall;
  final String id;
  final String key;
  final bool usePendingSubscriptions;
  final String subscriptionUrl;
  final String profileShareText;
    final String profileShareSubjectText;

  final String promiseShareText;
    final String promiseShareSubjectText;

  final Map<String, dynamic> profileShareDescription;
  final DateTime createdAt;
  final DateTime updatedAt;

  AppSettingsData({
    required this.paywall,
    required this.id,
    required this.key,
    required this.usePendingSubscriptions,
    required this.subscriptionUrl,
    required this.profileShareText,
    required this.profileShareSubjectText,
    required this.promiseShareText,
    required this.promiseShareSubjectText,
    required this.profileShareDescription,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AppSettingsData.fromJson(Map<String, dynamic> json) {
    return AppSettingsData(
      paywall: json['paywall'] ?? false,
      // Mapping '_id' from JSON to 'id' in Dart
      id: json['_id'] ?? '',
      key: json['key'] ?? '',
      usePendingSubscriptions: json['usePendingSubscriptions'] ?? false,
      subscriptionUrl:
          json['subscriptionURL'] ?? "https://stopbreakingpromises.com",
      profileShareText: json['profileShareText'] ?? '',
      promiseShareText: json['promiseShareText'] ?? '',
      profileShareSubjectText: json['profileShareSubjectText'] ?? '',
      promiseShareSubjectText: json['promiseShareSubjectText'] ?? '',
      profileShareDescription: {
        "Dreamer": json['dreamerProfileShareText'] ?? "",
        "Builder": json['builderProfileShareText'] ?? "",
        "Lone Wolf": json['loneWolfProfileShareText'] ?? "",
        "Competitor": json['competitorProfileShareText'] ?? "",
        "Pleaser": json['pleaserProfileShareText'] ?? "",
        "Overgiver": json['overgiverProfileShareText'] ?? "",
        "Alchemist": json['alchemistProfileShareText'] ?? "",
        "Avoider": json['avoiderProfileShareText'] ?? "",
      },
      // Parsing ISO 8601 Date strings to DateTime objects
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'paywall': paywall,
  //     '_id': id,
  //     'key': key,
  //     'usePendingSubscriptions': usePendingSubscriptions,
  //     'profileShareText': profileShareText,
  //     'promiseShareText': promiseShareText,
  //     'profileShareSubjectText': profileShareSubjectText,
  //     'promiseShareSubjectText': promiseShareSubjectText,
  //     'profileShareDescription': {
  //       "Dreamer": json['dreamerProfileShareText'] ?? "",
  //       "Builder": json['builderProfileShareText'] ?? "",
  //       "Lone Wolf": json['loneWolfProfileShareText'] ?? "",
  //       "Competitor": json['competitorProfileShareText'] ?? "",
  //       "Pleaser": json['pleaserProfileShareText'] ?? "",
  //       "Overgiver": json['overgiverProfileShareText'] ?? "",
  //       "Alchemist": json['alchemistProfileShareText'] ?? "",
  //       "Avoider": json['avoiderProfileShareText'] ?? "",
  //     },
  //     'subscriptionURL': subscriptionUrl,
  //     'createdAt': createdAt.toIso8601String(),
  //     'updatedAt': updatedAt.toIso8601String(),
  //   };
  // }
}
