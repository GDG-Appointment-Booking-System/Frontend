import 'package:frontend/features/booking/data/models/appointment_model.dart';
import 'package:frontend/features/services/data/models/service_model.dart';

class DemoSeedData {
  DemoSeedData._();

  // Demo service list used only while API endpoints are still TODO.
  static const List<ServiceModel> services = [
    ServiceModel(
      id: 'svc-classic-cut',
      name: 'Classic Executive Cut',
      description: 'A precision haircut with consultation and styling.',
      price: 45,
      durationMinutes: 45,
    ),
    ServiceModel(
      id: 'svc-signature-beard',
      name: 'Signature Beard Sculpt',
      description: 'Shape, trim, and blend for a refined beard profile.',
      price: 35,
      durationMinutes: 30,
    ),
    ServiceModel(
      id: 'svc-hot-towel',
      name: 'Hot Towel Ritual',
      description: 'Relaxing towel treatment with deep cleanse and finish.',
      price: 25,
      durationMinutes: 25,
    ),
  ];

  // Creates appointment examples relative to "now" so dates stay realistic.
  static List<AppointmentModel> appointments({DateTime? now}) {
    final base = now ?? DateTime.now();
    final today = DateTime(base.year, base.month, base.day);

    return [
      AppointmentModel(
        id: 'apt-001',
        serviceId: 'svc-classic-cut',
        clientId: 'client-demo',
        adminId: 'admin-julian',
        startTime: today.add(const Duration(days: 1, hours: 10, minutes: 30)),
        endTime: today.add(const Duration(days: 1, hours: 11, minutes: 15)),
        status: 'confirmed',
      ),
      AppointmentModel(
        id: 'apt-002',
        serviceId: 'svc-signature-beard',
        clientId: 'client-demo',
        adminId: 'admin-julian',
        startTime: today.add(const Duration(days: 2, hours: 13)),
        endTime: today.add(const Duration(days: 2, hours: 13, minutes: 30)),
        status: 'pending',
      ),
      AppointmentModel(
        id: 'apt-003',
        serviceId: 'svc-hot-towel',
        clientId: 'client-demo',
        adminId: 'admin-julian',
        startTime: today.subtract(const Duration(days: 1, hours: 15)),
        endTime: today.subtract(const Duration(days: 1, hours: 14, minutes: 35)),
        status: 'completed',
      ),
    ];
  }

  // Quick helper for dashboard cards.
  static double estimatedRevenue() {
    const servicePriceById = {
      'svc-classic-cut': 45.0,
      'svc-signature-beard': 35.0,
      'svc-hot-towel': 25.0,
    };

    final completed = appointments().where((apt) => apt.status == 'completed');
    return completed.fold<double>(0, (total, apt) {
      return total + (servicePriceById[apt.serviceId] ?? 0);
    });
  }
}
