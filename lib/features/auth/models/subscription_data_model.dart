class SubscriptionUser {
  final String id;
  final String name;
  final String email;
  final String? profilePicture;
  final bool isOwner;
  final DateTime joinedAt;

  const SubscriptionUser({
    required this.id,
    required this.name,
    required this.email,
    this.profilePicture,
    required this.isOwner,
    required this.joinedAt,
  });

  factory SubscriptionUser.fromJson(Map<String, dynamic> json) {
    return SubscriptionUser(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown',
      email: json['email']?.toString() ?? '',
      profilePicture: json['profilePicture']?.toString(),
      isOwner: json['isOwner'] as bool? ?? false,
      joinedAt:
          DateTime.tryParse(json['joinedAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}

class SubscriptionData {
  final bool hasAccess;
  final DateTime expiryDate;
  final String planType;
  final int intervalMonths;
  final int seatsUsed;
  final int seatsTotal;
  final bool isOwner;
  final bool cancelAtPeriodEnd;
  final String? inviteCode;
  final List<SubscriptionUser> users;

  const SubscriptionData({
    required this.hasAccess,
    required this.expiryDate,
    required this.planType,
    required this.intervalMonths,
    required this.seatsUsed,
    required this.seatsTotal,
    required this.isOwner,
    this.cancelAtPeriodEnd = false,
    this.inviteCode,
    this.users = const [],
  });

  factory SubscriptionData.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data =
        json.containsKey('data') && json['data'] is Map ? json['data'] : json;

    return SubscriptionData(
      hasAccess: data['hasAccess'] as bool? ?? false,
      expiryDate:
          DateTime.tryParse(data['expiryDate']?.toString() ?? '') ??
          DateTime.now(),
      planType: data['planType'] as String? ?? 'free',
      intervalMonths: data['intervalMonths'] as int? ?? 0,
      seatsUsed: data['seatsUsed'] as int? ?? 0,
      seatsTotal: data['seatsTotal'] as int? ?? 0,
      isOwner: data['isOwner'] as bool? ?? false,
      cancelAtPeriodEnd: data['cancelAtPeriodEnd'] as bool? ?? false,
      inviteCode: data['inviteCode']?.toString(),
      users:
          (data['users'] as List<dynamic>?)
              ?.map((e) => SubscriptionUser.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hasAccess': hasAccess,
      'expiryDate': expiryDate.toIso8601String(),
      'planType': planType,
      'intervalMonths': intervalMonths,
      'seatsUsed': seatsUsed,
      'seatsTotal': seatsTotal,
      'isOwner': isOwner,
      'cancelAtPeriodEnd': cancelAtPeriodEnd,
      'inviteCode': inviteCode,
      'users': users
          .map(
            (e) => {
              'id': e.id,
              'name': e.name,
              'email': e.email,
              'isOwner': e.isOwner,
            },
          )
          .toList(),
    };
  }

  bool get isActive => hasAccess && expiryDate.isAfter(DateTime.now());

  @override
  String toString() {
    return 'SubscriptionData(plan: $planType, isOwner: $isOwner, seats: $seatsUsed/$seatsTotal)';
  }
}
