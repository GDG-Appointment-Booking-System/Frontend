import 'package:frontend/features/auth/data/models/user_model.dart';

class AuthResponseModel {
  const AuthResponseModel({required this.accessToken, required this.user});

  // JWT token used in Authorization header.
  final String accessToken;

  // Logged-in user profile returned by backend.
  final UserModel user;

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['accessToken'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {'accessToken': accessToken, 'user': user.toJson()};
  }
}
