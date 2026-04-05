class UserModel {
  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
  });

  // Unique identifier from backend (UUID or ObjectId string).
  final String id;

  // Name displayed in app header/profile.
  final String fullName;

  // User login email.
  final String email;

  // Expected values for MVP: "client" or "admin".
  final String role;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      fullName: json['fullName'].toString(),
      email: json['email'].toString(),
      role: json['role'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'fullName': fullName, 'email': email, 'role': role};
  }
}
