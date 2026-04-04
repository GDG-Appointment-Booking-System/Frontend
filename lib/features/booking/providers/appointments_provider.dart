import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_service.dart';
import 'package:frontend/features/booking/data/models/appointment_model.dart';
import 'package:frontend/features/booking/data/models/create_appointment_request_model.dart';
import 'package:frontend/shared/data/demo_seed_data.dart';

final appointmentsProvider = FutureProvider<List<AppointmentModel>>((
  ref,
) async {
  final api = ref.read(apiServiceProvider);

  try {
    return await api.fetchMyAppointments();
  } on UnimplementedError {
    // Show realistic sample cards while waiting for backend endpoint.
    return DemoSeedData.appointments();
  }
});

class AppointmentController extends StateNotifier<AsyncValue<void>> {
  AppointmentController(this._api) : super(const AsyncValue.data(null));

  final ApiService _api;

  Future<void> createAppointment(CreateAppointmentRequestModel request) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      try {
        await _api.createAppointment(request);
      } on UnimplementedError {
        // Simulate API delay for smoother demo UX in class.
        await Future<void>.delayed(const Duration(milliseconds: 700));
      }
    });
  }
}

final appointmentControllerProvider =
    StateNotifierProvider<AppointmentController, AsyncValue<void>>((ref) {
      final api = ref.watch(apiServiceProvider);
      return AppointmentController(api);
    });
