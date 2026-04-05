import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_service.dart';
import 'package:frontend/features/booking/data/models/appointment_model.dart';
import 'package:frontend/features/booking/data/models/create_appointment_request_model.dart';

final appointmentsProvider = FutureProvider<List<AppointmentModel>>((
  ref,
) async {
  final api = ref.read(apiServiceProvider);
  return api.fetchMyAppointments();
});

final adminAppointmentsProvider = FutureProvider<List<AppointmentModel>>((
  ref,
) async {
  final api = ref.read(apiServiceProvider);
  return api.fetchAppointments();
});

class AppointmentController extends StateNotifier<AsyncValue<void>> {
  AppointmentController(this._api) : super(const AsyncValue.data(null));

  final ApiService _api;

  Future<void> createAppointment(CreateAppointmentRequestModel request) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _api.createAppointment(request);
    });
  }
}

final appointmentControllerProvider =
    StateNotifierProvider<AppointmentController, AsyncValue<void>>((ref) {
      final api = ref.watch(apiServiceProvider);
      return AppointmentController(api);
    });
