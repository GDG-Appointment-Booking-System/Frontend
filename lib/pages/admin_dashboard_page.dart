import 'package:flutter/material.dart';
import 'package:frontend/core/router/route_names.dart';
import 'package:frontend/core/shared_widgets/app_colors.dart';
import 'package:frontend/shared/data/demo_seed_data.dart';
import 'package:frontend/shared/widgets/admin_bottom_nav.dart';
import 'package:frontend/shared/widgets/section_header.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appointments = DemoSeedData.appointments();
    final today = DateTime.now();
    final confirmedToday = appointments.where((apt) {
      final sameDay = apt.startTime.year == today.year &&
          apt.startTime.month == today.month &&
          apt.startTime.day == today.day;
      return sameDay && apt.status != 'cancelled';
    }).toList();

    final completedCount = appointments
        .where((apt) => apt.status == 'completed')
        .length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 14,
              child: Icon(Icons.admin_panel_settings_outlined, size: 16),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AdminBottomNav(
        currentRoute: RouteNames.adminDashboard,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top heading + subtitle for the analytics overview.
              const SectionHeader(
                title: 'Executive Insights',
                subtitle: 'Quick view of bookings, revenue, and operations.',
              ),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _MetricCard(
                    label: 'Revenue',
                    value: '\$${DemoSeedData.estimatedRevenue().toStringAsFixed(0)}',
                    icon: Icons.payments_outlined,
                  ),
                  _MetricCard(
                    label: 'Completed',
                    value: '$completedCount',
                    icon: Icons.check_circle_outline,
                  ),
                  _MetricCard(
                    label: 'Today',
                    value: '${confirmedToday.length}',
                    icon: Icons.event_available,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const SectionHeader(
                title: 'Today\'s Schedule',
                subtitle: 'Tap manage services to edit prices, durations, and visibility.',
                padding: EdgeInsets.only(bottom: 10),
              ),
              if (confirmedToday.isEmpty)
                const _NoScheduleCard()
              else
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      children: confirmedToday.map((appointment) {
                        final time = DateFormat('hh:mm a').format(appointment.startTime);
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const CircleAvatar(
                            backgroundColor: AppColors.primarySoft,
                            child: Icon(Icons.content_cut, color: AppColors.primary),
                          ),
                          title: Text('Client booking #${appointment.id}'),
                          subtitle: Text('Starts at $time'),
                          trailing: Text(
                            appointment.status.toUpperCase(),
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              const SizedBox(height: 14),
              Card(
                color: AppColors.primary,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Curate Your Service Menu',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.textOnPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add new services or adjust availability based on demand.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFFD9E6F3),
                        ),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => context.go(RouteNames.adminManageServices),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.textOnPrimary,
                            foregroundColor: AppColors.primary,
                          ),
                          child: const Text('Manage Services'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(height: 8),
              Text(
                value,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 2),
              Text(label, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}

class _NoScheduleCard extends StatelessWidget {
  const _NoScheduleCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: AppColors.primarySoft,
              child: Icon(Icons.event_busy, color: AppColors.primary),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'No confirmed appointments today. Promote top services to boost bookings.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
