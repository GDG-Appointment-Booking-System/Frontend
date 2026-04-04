import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_service.dart';
import 'package:frontend/features/services/data/models/service_model.dart';
import 'package:frontend/shared/data/demo_seed_data.dart';

final servicesProvider = FutureProvider<List<ServiceModel>>((ref) async {
  final api = ref.read(apiServiceProvider);

  try {
    return await api.fetchServices();
  } on UnimplementedError {
    // Keep the page usable during class demos before backend is finished.
    return DemoSeedData.services;
  }
});
