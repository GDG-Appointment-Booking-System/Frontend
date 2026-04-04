import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/router/route_names.dart';
import 'package:frontend/core/shared_widgets/app_colors.dart';
import 'package:frontend/features/services/data/models/service_model.dart';
import 'package:frontend/features/services/providers/services_provider.dart';
import 'package:frontend/shared/widgets/client_bottom_nav.dart';
import 'package:frontend/shared/widgets/error_view.dart';
import 'package:frontend/shared/widgets/loading_view.dart';
import 'package:frontend/shared/widgets/section_header.dart';
import 'package:go_router/go_router.dart';

class ServicesPage extends ConsumerWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(servicesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('SharpCut'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 14,
              child: Icon(Icons.person_outline, size: 16),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const ClientBottomNav(
        currentRoute: RouteNames.services,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: servicesAsync.when(
            data: (services) {
              if (services.isEmpty) {
                return _EmptyServicesState(
                  onExplorePressed: () => context.push(RouteNames.booking),
                );
              }

              return Column(
                children: [
                  // Header gives visual hierarchy similar to the provided mockups.
                  const SectionHeader(
                    title: 'Service Catalog',
                    subtitle: 'Precision grooming for the modern gentleman.',
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemCount: services.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final service = services[index];
                        return _ServiceCard(
                          service: service,
                          highlight: index == 0,
                          onBookPressed: () {
                            // Keep routing simple now; later pass selected service ID.
                            context.push(RouteNames.booking);
                          },
                        );
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

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({
    required this.service,
    required this.onBookPressed,
    required this.highlight,
  });

  final ServiceModel service;
  final VoidCallback onBookPressed;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (highlight)
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accentGold,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'Most Popular',
                  style: TextStyle(
                    color: AppColors.textOnPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            Container(
              height: 130,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.sectionTint,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.content_cut_rounded,
                size: 46,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    service.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Text(
                  '\$${service.price.toStringAsFixed(0)}',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              service.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(
                  Icons.schedule,
                  size: 16,
                  color: AppColors.textMuted,
                ),
                const SizedBox(width: 6),
                Text(
                  '${service.durationMinutes} minutes',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: onBookPressed,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(118, 42),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                  ),
                  child: const Text('Book Now'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyServicesState extends StatelessWidget {
  const _EmptyServicesState({required this.onExplorePressed});

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
                const Icon(
                  Icons.spa_outlined,
                  size: 36,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 10),
                Text(
                  'No Services Yet',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 6),
                const Text(
                  'Add your first service from admin mode so clients can book appointments.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 14),
                ElevatedButton(
                  onPressed: onExplorePressed,
                  child: const Text('Open Booking'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
