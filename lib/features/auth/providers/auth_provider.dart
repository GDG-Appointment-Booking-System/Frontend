import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_service.dart';
import 'package:frontend/core/network/dio_client.dart';
import 'package:frontend/core/storage/secure_storage_service.dart';
import 'package:frontend/features/auth/data/models/login_request_model.dart';
import 'package:frontend/features/auth/data/models/user_model.dart';

enum UserRole { client, admin }

class AuthSession {
  const AuthSession({required this.token, required this.user});

  final String token;
  final UserModel user;
}

final authProvider =
    StateNotifierProvider<AuthController, AsyncValue<AuthSession?>>((ref) {
      final api = ref.watch(apiServiceProvider);
      final storage = ref.watch(secureStorageProvider);
      return AuthController(apiService: api, storage: storage);
    });

class AuthController extends StateNotifier<AsyncValue<AuthSession?>> {
  AuthController({
    required ApiService apiService,
    required SecureStorageService storage,
  }) : _apiService = apiService,
       _storage = storage,
       super(const AsyncValue.data(null));

  final ApiService _apiService;
  final SecureStorageService _storage;

  Future<void> login({required String email, required String password}) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      try {
        final response = await _apiService.login(
          LoginRequestModel(email: email, password: password),
        );

        await _storage.saveAccessToken(response.accessToken);
        await _storage.saveRole(response.user.role);

        return AuthSession(token: response.accessToken, user: response.user);
      } on UnimplementedError {
        // Beginner-friendly fallback: any email containing "admin" logs in as admin.
        final role = email.toLowerCase().contains('admin')
            ? UserRole.admin.name
            : UserRole.client.name;

        final demoSession = AuthSession(
          token: 'demo-token-for-class-project',
          user: UserModel(
            id: role == UserRole.admin.name ? 'admin-demo' : 'client-demo',
            fullName: role == UserRole.admin.name
                ? 'SharpCut Admin'
                : 'SharpCut Client',
            email: email,
            role: role,
          ),
        );

        await _storage.saveAccessToken(demoSession.token);
        await _storage.saveRole(demoSession.user.role);

        return demoSession;
      }
    });
  }

  Future<void> logout() async {
    await _storage.clearSession();
    state = const AsyncValue.data(null);
  }
}
