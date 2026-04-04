import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/router/route_names.dart';
import 'package:frontend/core/shared_widgets/app_colors.dart';
import 'package:frontend/features/services/data/models/service_model.dart';
import 'package:frontend/features/services/providers/services_provider.dart';
import 'package:frontend/shared/widgets/admin_bottom_nav.dart';
import 'package:frontend/shared/widgets/error_view.dart';
import 'package:frontend/shared/widgets/loading_view.dart';
import 'package:frontend/shared/widgets/section_header.dart';

class ManageServicesPage extends ConsumerWidget {
  const ManageServicesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(servicesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Service Management')),
      bottomNavigationBar: const AdminBottomNav(
        currentRoute: RouteNames.adminManageServices,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO(team): open add service form (bottom sheet or new page).
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('TODO: open Add Service form.')),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('New Service'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: servicesAsync.when(
            data: (services) {
              if (services.isEmpty) {
                return const Center(
                  child: Text('No services available. Tap "New Service" to add one.'),
                );
              }

              return Column(
                children: [
                  const SectionHeader(
                    title: 'Curate Your Service Menu',
                    subtitle:
                        'Update pricing, duration, and visibility for each service.',
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemCount: services.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        return _ServiceAdminCard(service: services[index]);
                      },
                    ),
                  ),
                ],
              );
            },
            loading: () => const LoadingView(label: 'Loading services...'),
            error: (error, _) => ErrorView(
              message: 'Could not load services.\n$error',
              onRetry: () => ref.invalidate(servicesProvider),
            ),
          ),
        ),
      ),
    );
  }
}

class _ServiceAdminCard extends StatelessWidget {
  const _ServiceAdminCard({required this.service});

  final ServiceModel service;

  @override
  Widget build(BuildContext context) {
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
                    service.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '\$${service.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(service.description, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.schedule, size: 16, color: AppColors.textMuted),
                const SizedBox(width: 6),
                Text(
                  '${service.durationMinutes} minutes',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const Spacer(),

                // Simple actions for students to replace with real update/delete APIs.
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('TODO: edit ${service.name}.')),
                    );
                  },
                  child: const Text('Edit'),
                ),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('TODO: delete ${service.name}.')),
                    );
                  },
                  style: TextButton.styleFrom(foregroundColor: AppColors.error),
                  child: const Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
