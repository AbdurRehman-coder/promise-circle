import 'package:sbp_app/features/auth/models/user_model.dart';

class AuthResponse {
  final User user;
  String accessToken;
  String refreshToken;

  AuthResponse({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;

    return AuthResponse(
      user: User.fromJson(data),
      accessToken: data['accessToken'] as String,
      refreshToken: data['refreshToken'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': {
        ...user.toJson(),
        'accessToken': accessToken,
        'refreshToken': refreshToken,
      },
    };
  }

  AuthResponse copyWith({
    User? user,
    String? accessToken,
    String? refreshToken,
  }) {
    return AuthResponse(
      user: user ?? this.user,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}

// import 'package:sbp_app/features/auth/models/user_model.dart';
//
// class AuthResponse {
//   final User user;
//   final String accessToken;
//   final String refreshToken;
//
//   AuthResponse({
//     required this.user,
//     required this.accessToken,
//     required this.refreshToken,
//   });
//
//   factory AuthResponse.fromJson(Map<String, dynamic> json) {
//     // Extract data object safely with containsKey check
//     final data =
//         (json.containsKey('data') && json['data'] is Map<String, dynamic>)
//         ? json['data'] as Map<String, dynamic>
//         : json;
//
//     // Try to get user from either 'user' or 'newUser' field with containsKey checks
//     dynamic rawUser;
//     if (data.containsKey('user')) {
//       rawUser = data['user'];
//     } else if (data.containsKey('newUser')) {
//       rawUser = data['newUser'];
//     }
//     final user = (rawUser is Map<String, dynamic>)
//         ? User.fromJson(rawUser)
//         : User.empty();
//
//     // Extract tokens safely with containsKey checks
//     final accessToken =
//         data.containsKey('accessToken') && data['accessToken'] is String
//         ? data['accessToken'] as String
//         : '';
//     final refreshToken =
//         data.containsKey('refreshToken') && data['refreshToken'] is String
//         ? data['refreshToken'] as String
//         : '';
//
//     return AuthResponse(
//       user: user,
//       accessToken: accessToken,
//       refreshToken: refreshToken,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       "user": user.toJson(),
//       "accessToken": accessToken,
//       "refreshToken": refreshToken,
//     };
//   }
//
//   /// ✅ copyWith method
//   AuthResponse copyWith({
//     User? user,
//     String? accessToken,
//     String? refreshToken,
//   }) {
//     return AuthResponse(
//       user: user ?? this.user,
//       accessToken: accessToken ?? this.accessToken,
//       refreshToken: refreshToken ?? this.refreshToken,
//     );
//   }
// }
