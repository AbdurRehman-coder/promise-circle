import 'package:sbp_app/features/onboarding/model/onboarding_result.dart';
import 'user_settings.dart';

class User {
  final String? id;
  final String? email;
  final String? name;
  final String? role;
  final bool? emailVerified;
  final bool? banned;
  final String? dateOfBirth;
  final String? gender;
  final String? username;
  final String? description;
  final String? displayPictureURL;
  final String? displayBannerURL;
  final String? authProvider;
  final bool? deleted;
  final UserSettings? settings;
  final OnboardingResult? onboarding;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? phone;
  final String? timezone;
  final String? timezoneRegion;
  final int? promisesKept;
  final int? reflectionsCount;
  final int? promisesCount;

  const User({
    this.id,
    this.email,
    this.name,
    this.role,
    this.emailVerified,
    this.banned,
    this.dateOfBirth,
    this.gender,
    this.username,
    this.description,
    this.displayPictureURL,
    this.displayBannerURL,
    this.authProvider,
    this.deleted,
    this.settings,
    this.onboarding,
    this.createdAt,
    this.updatedAt,
    this.phone,
    this.timezone,
    this.timezoneRegion,
    this.promisesKept,
    this.reflectionsCount,
    this.promisesCount,
  });

  User.empty()
    : id = '',
      email = '',
      name = '',
      role = '',
      emailVerified = false,
      banned = false,
      dateOfBirth = '',
      gender = '',
      username = '',
      description = '',
      displayPictureURL = '',
      displayBannerURL = '',
      authProvider = '',
      deleted = false,
      settings = null,
      onboarding = null,
      phone = '',
      timezone = '',
      timezoneRegion = '',
      promisesKept = 0,
      reflectionsCount = 0,
      promisesCount = 0,
      createdAt = DateTime.fromMicrosecondsSinceEpoch(0),
      updatedAt = DateTime.fromMicrosecondsSinceEpoch(0);

  /// Safe date parser
  static DateTime? _parseDate(dynamic value) {
    if (value is String && value.isNotEmpty) {
      try {
        return DateTime.parse(value);
      } catch (_) {}
    }
    return null;
  }

  factory User.fromJson(Map<String, dynamic>? json) {
    if (json == null) return User.empty();

    final data = json['data'] ?? json;

    return User(
      id: data['_id'],
      email: data['email'],
      name: data['name'],
      role: data['role'],
      emailVerified: data['emailVerified'],
      banned: data['banned'],
      dateOfBirth: data['dateOfBirth'],
      gender: data['gender'],
      username: data['username'],
      description: data['description'],
      displayPictureURL: data['displayPictureURL'],
      displayBannerURL: data['displayBannerURL'],
      authProvider: data['authProvider'],
      deleted: data['deleted'],
      phone: data['phone'],
      timezone: data['timezone'],
      timezoneRegion: data['timezoneRegion'],
      promisesKept: data['promisesKept'],
      reflectionsCount: data['reflectionsCount'],
      promisesCount: data['promisesCount'],
      settings: data['settings'] is Map
          ? UserSettings.fromJson(data['settings'])
          : null,
      onboarding: data['onboarding'] is Map
          ? OnboardingResult.fromJson(data)
          : null,
      createdAt: _parseDate(data['createdAt']),
      updatedAt: _parseDate(data['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "email": email,
      "name": name,
      "role": role,
      "emailVerified": emailVerified,
      "banned": banned,
      "dateOfBirth": dateOfBirth,
      "gender": gender,
      "username": username,
      "description": description,
      "displayPictureURL": displayPictureURL,
      "displayBannerURL": displayBannerURL,
      "authProvider": authProvider,
      "phone": phone,
      "deleted": deleted,
      "timezone": timezone,
      "timezoneRegion": timezoneRegion,
      "promisesKept": promisesKept,
      "reflectionsCount": reflectionsCount,
      "promisesCount": promisesCount,
      "settings": settings?.toJson(),
      "onboarding": onboarding?.toJson(),
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
    }..removeWhere(
      (key, value) => value == null || (value is String && value.isEmpty),
    );
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? role,
    bool? emailVerified,
    bool? banned,
    String? dateOfBirth,
    String? gender,
    String? username,
    String? description,
    String? displayPictureURL,
    String? displayBannerURL,
    String? authProvider,
    bool? deleted,
    UserSettings? settings,
    OnboardingResult? onboarding,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? phone,
    String? timezone,
    String? timezoneRegion,
    int? promisesKept,
    int? reflectionsCount,
    int? promisesCount,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      emailVerified: emailVerified ?? this.emailVerified,
      banned: banned ?? this.banned,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      username: username ?? this.username,
      description: description ?? this.description,
      displayPictureURL: displayPictureURL ?? this.displayPictureURL,
      displayBannerURL: displayBannerURL ?? this.displayBannerURL,
      authProvider: authProvider ?? this.authProvider,
      deleted: deleted ?? this.deleted,
      settings: settings ?? this.settings,
      onboarding: onboarding ?? this.onboarding,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      phone: phone ?? this.phone,
      timezone: timezone ?? this.timezone,
      timezoneRegion: timezoneRegion ?? this.timezoneRegion,
      promisesKept: promisesKept ?? this.promisesKept,
      reflectionsCount: reflectionsCount ?? this.reflectionsCount,
      promisesCount: promisesCount ?? this.promisesCount,
    );
  }
}
