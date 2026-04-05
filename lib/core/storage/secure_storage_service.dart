import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  SecureStorageService({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userRoleKey = 'user_role';

  Future<void> saveAccessToken(String token) async {
    // This correctly saves the token to local secure-storage after login.
    await _storage.write(key: accessTokenKey, value: token);
  }

  Future<String?> readAccessToken() async {
    return _storage.read(key: accessTokenKey);
  }

  Future<void> saveRole(String role) async {
    await _storage.write(key: userRoleKey, value: role);
  }

  Future<String?> readRole() async {
    return _storage.read(key: userRoleKey);
  }

  Future<void> clearSession() async {
    await _storage.delete(key: accessTokenKey);
    await _storage.delete(key: refreshTokenKey);
    await _storage.delete(key: userRoleKey);
  }
}
