import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/dio_client.dart';
import 'package:frontend/features/auth/data/models/auth_response_model.dart';
import 'package:frontend/features/auth/data/models/login_request_model.dart';
import 'package:frontend/features/booking/data/models/appointment_model.dart';
import 'package:frontend/features/booking/data/models/create_appointment_request_model.dart';
import 'package:frontend/features/services/data/models/service_model.dart';
import 'package:frontend/features/auth/data/models/user_model.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiService(dio);
});

class ApiService {
  ApiService(this._dio);

  final Dio _dio;

  Future<AuthResponseModel> login(LoginRequestModel request) async {
    // MOCK: Replace the delay and return with your real backend call.
    // final response = await _dio.post('/auth/login', data: request.toJson());
    // return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);

    await Future.delayed(const Duration(seconds: 1));
    return AuthResponseModel(
      accessToken: 'mock-jwt-token-12345',
      user: UserModel(
        id: 'user-001',
        email: request.email,
        name: 'Demo Client',
        role: request.email.contains('admin') ? 'admin' : 'client',
      ),
    );
  }

  Future<List<ServiceModel>> fetchServices() async {
    // MOCK: Replace with your real backend call.
    // final response = await _dio.get('/services');
    // final list = response.data['data'] as List<dynamic>;
    // return list.map((e) => ServiceModel.fromJson(e)).toList();

    await Future.delayed(const Duration(seconds: 1));
    return const [
      ServiceModel(
        id: 'svc-classic-cut',
        name: 'Classic Executive Cut',
        description: 'A tailored haircut.',
        price: 45.0,
        durationMinutes: 45,
      ),
      ServiceModel(
        id: 'svc-beard-trim',
        name: 'Beard Trim & Shape',
        description: 'Expert beard care.',
        price: 25.0,
        durationMinutes: 30,
      ),
    ];
  }

  Future<AppointmentModel> createAppointment(
    CreateAppointmentRequestModel request,
  ) async {
    // MOCK: Replace with your real backend call.
    // final response = await _dio.post('/appointments', data: request.toJson());
    // return AppointmentModel.fromJson(response.data['data']);

    await Future.delayed(const Duration(seconds: 1));
    return AppointmentModel(
      id: 'apt-${DateTime.now().millisecondsSinceEpoch}',
      clientId: 'user-001',
      serviceId: request.serviceId,
      adminId: request.adminId,
      startTime: request.startTime,
      endTime: request.startTime.add(const Duration(minutes: 45)),
      status: 'scheduled',
    );
  }

  Future<List<AppointmentModel>> fetchMyAppointments() async {
    // MOCK: Replace with your real backend call.
    // final response = await _dio.get('/appointments/me');
    // return (response.data['data'] as List).map((e) => AppointmentModel.fromJson(e)).toList();

    await Future.delayed(const Duration(seconds: 1));
    return [
      AppointmentModel(
        id: 'apt-001',
        clientId: 'user-001',
        serviceId: 'svc-classic-cut',
        adminId: 'admin-julian',
        startTime: DateTime.now().add(const Duration(days: 1, hours: 10)),
        endTime: DateTime.now().add(
          const Duration(days: 1, hours: 10, minutes: 45),
        ),
        status: 'scheduled',
      ),
    ];
  }
}
