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

  Future<AuthResponseModel> login(LoginRequestModel request) async {
    try {
      final response = await _dio.post('/auth/login', data: request.toJson());
      return AuthResponseModel.fromJson(_asMap(response.data));
    } catch (error) {
      _throwHandledError(error);
    }
  }

  Future<List<ServiceModel>> fetchServices() async {
    try {
      final response = await _dio.get('/services');
      return _asList(
        response.data,
      ).map((item) => ServiceModel.fromJson(_asMap(item))).toList();
    } catch (error) {
      _throwHandledError(error);
    }
  }

  Future<ServiceModel> createService(ServiceModel service) async {
    try {
      final payload = {...service.toJson()}
        ..removeWhere((_, value) => value == null);

      final response = await _dio.post('/services', data: payload);
      return ServiceModel.fromJson(_asMap(response.data));
    } catch (error) {
      _throwHandledError(error);
    }
  }

  Future<ServiceModel> updateService(ServiceModel service) async {
    try {
      final payload = {...service.toJson()}
        ..removeWhere((_, value) => value == null);

      final response = await _dio.put('/services/${service.id}', data: payload);
      return ServiceModel.fromJson(_asMap(response.data));
    } catch (error) {
      _throwHandledError(error);
    }
  }

  Future<void> deleteService(String serviceId) async {
    try {
      await _dio.delete('/services/$serviceId');
    } catch (error) {
      _throwHandledError(error);
    }
  }

  Future<AppointmentModel> createAppointment(
    CreateAppointmentRequestModel request,
  ) async {
    try {
      final response = await _dio.post('/appointments', data: request.toJson());
      return AppointmentModel.fromJson(_asMap(response.data));
    } catch (error) {
      _throwHandledError(error);
    }
  }

  Future<List<AppointmentModel>> fetchMyAppointments() async {
    try {
      final response = await _dio.get('/appointments/me');
      return _asList(
        response.data,
      ).map((item) => AppointmentModel.fromJson(_asMap(item))).toList();
    } catch (error) {
      _throwHandledError(error);
    }
  }

  Future<List<AppointmentModel>> fetchAppointments({String? clientId}) async {
    try {
      final response = await _dio.get(
        '/appointments',
        queryParameters: clientId == null ? null : {'clientId': clientId},
      );

      return _asList(
        response.data,
      ).map((item) => AppointmentModel.fromJson(_asMap(item))).toList();
    } catch (error) {
      _throwHandledError(error);
    }
  }

  Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data;
    }

    if (data is Map) {
      return data.map((key, value) => MapEntry(key.toString(), value));
    }

    throw Exception('Unexpected API response format.');
  }

  List<dynamic> _asList(dynamic data) {
    if (data is List<dynamic>) {
      return data;
    }

    if (data is List) {
      return data.cast<dynamic>();
    }

    throw Exception('Unexpected API response format.');
  }

  Never _throwHandledError(Object error) {
    if (error is DioException) {
      throw Exception(_extractDioErrorMessage(error));
    }

    throw Exception(error.toString());
  }

  String _extractDioErrorMessage(DioException error) {
    final responseData = error.response?.data;

    if (responseData is Map && responseData['message'] != null) {
      return responseData['message'].toString();
    }

    if (responseData is String && responseData.trim().isNotEmpty) {
      return responseData;
    }

    if (error.message != null && error.message!.trim().isNotEmpty) {
      return error.message!;
    }

    return 'Request failed. Please try again.';
  }
}
