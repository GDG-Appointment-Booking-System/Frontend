import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/dio_client.dart';
import 'package:frontend/features/auth/data/models/auth_response_model.dart';
import 'package:frontend/features/auth/data/models/login_request_model.dart';
import 'package:frontend/features/booking/data/models/appointment_model.dart';
import 'package:frontend/features/booking/data/models/create_appointment_request_model.dart';
import 'package:frontend/features/services/data/models/service_model.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiService(dio);
});

class ApiService {
  ApiService(this._dio);

  final Dio _dio;

  Never _notImplemented(String methodName) {
    // This keeps `_dio` actively used until real endpoint logic is added.
    final baseUrl = _dio.options.baseUrl;
    throw UnimplementedError(
      '$methodName is not implemented yet. Configure endpoint under $baseUrl',
    );
  }

  Future<AuthResponseModel> login(LoginRequestModel request) async {
    // TODO(team): call your real login endpoint and parse response.
    // final response = await _dio.post('/auth/login', data: request.toJson());
    // return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
    _notImplemented('login');
  }

  Future<List<ServiceModel>> fetchServices() async {
    // TODO(team): call your service list endpoint.
    // final response = await _dio.get('/services');
    // final list = response.data['data'] as List<dynamic>;
    // return list.map((e) => ServiceModel.fromJson(e)).toList();
    _notImplemented('fetchServices');
  }

  Future<AppointmentModel> createAppointment(
    CreateAppointmentRequestModel request,
  ) async {
    // TODO(team): call your create booking endpoint.
    // final response = await _dio.post('/appointments', data: request.toJson());
    // return AppointmentModel.fromJson(response.data['data']);
    _notImplemented('createAppointment');
  }

  Future<List<AppointmentModel>> fetchMyAppointments() async {
    // TODO(team): call your "my appointments" endpoint.
    _notImplemented('fetchMyAppointments');
  }
}
