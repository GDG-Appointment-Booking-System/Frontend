import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_service.dart';
import 'package:frontend/features/services/data/models/service_model.dart';

final servicesProvider = FutureProvider<List<ServiceModel>>((ref) async {
  final api = ref.read(apiServiceProvider);
  return api.fetchServices();
});

class ServiceController extends StateNotifier<AsyncValue<void>> {
  ServiceController(this._api) : super(const AsyncValue.data(null));

  final ApiService _api;

  Future<void> createService(ServiceModel service) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _api.createService(service);
    });
  }

  Future<void> updateService(ServiceModel service) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _api.updateService(service);
    });
  }

  Future<void> deleteService(String serviceId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _api.deleteService(serviceId);
    });
  }
}

final serviceControllerProvider =
    StateNotifierProvider<ServiceController, AsyncValue<void>>((ref) {
      final api = ref.watch(apiServiceProvider);
      return ServiceController(api);
    });
