import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/router/route_names.dart';
import 'package:frontend/core/shared_widgets/app_colors.dart';
import 'package:frontend/features/booking/data/models/appointment_model.dart';
import 'package:frontend/features/booking/providers/appointments_provider.dart';
import 'package:frontend/shared/widgets/client_bottom_nav.dart';
import 'package:frontend/shared/widgets/error_view.dart';
import 'package:frontend/shared/widgets/loading_view.dart';
import 'package:frontend/shared/widgets/section_header.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class MyAppointmentsPage extends ConsumerWidget {
  const MyAppointmentsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentsAsync = ref.watch(appointmentsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings')),
      bottomNavigationBar: const ClientBottomNav(
        currentRoute: RouteNames.myAppointments,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: appointmentsAsync.when(
            data: (appointments) {
              if (appointments.isEmpty) {
                return _EmptyAppointmentsState(
                  onExplorePressed: () => context.go(RouteNames.services),
                );
              }

              final upcomingCount = appointments
                  .where((apt) => apt.startTime.isAfter(DateTime.now()))
                  .length;

              return Column(
                children: [
                  // Keep top metrics short so students can replace with backend values later.
                  SectionHeader(
                    title: 'My Appointments',
                    subtitle: '$upcomingCount upcoming sessions',
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemCount: appointments.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        return _AppointmentCard(appointment: appointments[index]);
                      },
                    ),
                  ),
                ],
              );
            },
            loading: () => const LoadingView(label: 'Loading your appointments...'),
            error: (error, _) => ErrorView(
              message: 'Could not load appointments.\n$error',
              onRetry: () => ref.invalidate(appointmentsProvider),
            ),
          ),
        ),
      ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  const _AppointmentCard({required this.appointment});

  final AppointmentModel appointment;

  static const _serviceNameById = {
    'svc-classic-cut': 'Classic Executive Cut',
    'svc-signature-beard': 'Signature Beard Sculpt',
    'svc-hot-towel': 'Hot Towel Ritual',
  };

  @override
  Widget build(BuildContext context) {
    final startDate = DateFormat('EEE, dd MMM').format(appointment.startTime);
    final startTime = DateFormat('hh:mm a').format(appointment.startTime);
    final statusColor = _statusColor(appointment.status);
    final serviceName =
        _serviceNameById[appointment.serviceId] ?? appointment.serviceId;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    serviceName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    appointment.status.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '$startDate at $startTime',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.store_mall_directory_outlined, size: 16),
                const SizedBox(width: 6),
                Text(
                  'SharpCut Studio',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'TODO: open appointment details and actions.',
                        ),
                      ),
                    );
                  },
                  child: const Text('View Details'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
      case 'completed':
        return AppColors.success;
      case 'pending':
        return AppColors.warning;
      case 'cancelled':
        return AppColors.error;
      default:
        return AppColors.textMuted;
    }
  }
}

class _EmptyAppointmentsState extends StatelessWidget {
  const _EmptyAppointmentsState({required this.onExplorePressed});

  final VoidCallback onExplorePressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primarySoft,
                  child: Icon(
                    Icons.event_available,
                    size: 30,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'No Appointments Yet',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 6),
                Text(
                  'Book your first session to start tracking your schedule here.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 14),
                ElevatedButton(
                  onPressed: onExplorePressed,
                  child: const Text('Explore Services'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
