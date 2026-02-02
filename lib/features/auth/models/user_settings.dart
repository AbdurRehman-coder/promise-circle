class UserSettings {
  final bool notifications;
  final double dailyCheckIn;

  UserSettings({
    required this.notifications,
    required this.dailyCheckIn,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      notifications: json['notifications'] as bool,
      dailyCheckIn: (json['DailyCheckIn'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notifications': notifications,
      'DailyCheckIn': dailyCheckIn,
    };
  }

  UserSettings copyWith({
    bool? notifications,
    double? dailyCheckIn,
  }) {
    return UserSettings(
      notifications: notifications ?? this.notifications,
      dailyCheckIn: dailyCheckIn ?? this.dailyCheckIn,
    );
  }
}
