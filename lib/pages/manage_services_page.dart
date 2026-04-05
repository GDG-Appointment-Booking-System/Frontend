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

  Future<void> _deleteService(
    BuildContext context,
    WidgetRef ref,
    ServiceModel service,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Service'),
        content: Text('Delete "${service.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete != true) return;

    await ref
        .read(serviceControllerProvider.notifier)
        .deleteService(service.id);

    if (!context.mounted) return;

    final opState = ref.read(serviceControllerProvider);
    if (opState.hasError) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(opState.error.toString())));
      return;
    }

    ref.invalidate(servicesProvider);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Deleted ${service.name}')));
  }

  void _openForm(BuildContext context, ServiceModel? service) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _EditServiceForm(service: service),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(servicesProvider);
    final operationState = ref.watch(serviceControllerProvider);
    final isBusy = operationState.isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Service Management')),
      bottomNavigationBar: const AdminBottomNav(
        currentRoute: RouteNames.adminManageServices,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: isBusy ? null : () => _openForm(context, null),
        icon: const Icon(Icons.add),
        label: const Text('New Service'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Column(
            children: [
              if (isBusy) const LinearProgressIndicator(),
              Expanded(
                child: servicesAsync.when(
                  data: (services) {
                    if (services.isEmpty) {
                      return const Center(
                        child: Text(
                          'No services available. Tap "New Service" to add one.',
                        ),
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
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final service = services[index];
                              return _ServiceAdminCard(
                                service: service,
                                isBusy: isBusy,
                                onEdit: () => _openForm(context, service),
                                onDelete: () =>
                                    _deleteService(context, ref, service),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () =>
                      const LoadingView(label: 'Loading services...'),
                  error: (error, _) => ErrorView(
                    message: 'Could not load services.\n$error',
                    onRetry: () => ref.invalidate(servicesProvider),
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

class _ServiceAdminCard extends StatelessWidget {
  const _ServiceAdminCard({
    required this.service,
    required this.onEdit,
    required this.onDelete,
    required this.isBusy,
  });

  final ServiceModel service;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isBusy;

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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
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
                TextButton(
                  onPressed: isBusy ? null : onEdit,
                  child: const Text('Edit'),
                ),
                TextButton(
                  onPressed: isBusy ? null : onDelete,
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

class _EditServiceForm extends ConsumerStatefulWidget {
  const _EditServiceForm({this.service});

  final ServiceModel? service;

  @override
  ConsumerState<_EditServiceForm> createState() => _EditServiceFormState();
}

class _EditServiceFormState extends ConsumerState<_EditServiceForm> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _descriptionCtrl = TextEditingController();
  final TextEditingController _priceCtrl = TextEditingController();
  final TextEditingController _durationCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.service != null) {
      _nameCtrl.text = widget.service!.name;
      _descriptionCtrl.text = widget.service!.description;
      _priceCtrl.text = widget.service!.price.toStringAsFixed(0);
      _durationCtrl.text = widget.service!.durationMinutes.toString();
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descriptionCtrl.dispose();
    _priceCtrl.dispose();
    _durationCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final messenger = ScaffoldMessenger.of(context);

    final name = _nameCtrl.text.trim();
    final description = _descriptionCtrl.text.trim();
    final price = double.tryParse(_priceCtrl.text.trim());
    final duration = int.tryParse(_durationCtrl.text.trim());

    if (name.isEmpty || description.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Name and description are required.')),
      );
      return;
    }

    if (price == null || price <= 0) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Enter a valid price.')),
      );
      return;
    }

    if (duration == null || duration <= 0) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Enter a valid duration.')),
      );
      return;
    }

    final service = ServiceModel(
      id: widget.service?.id ?? 'svc-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      description: description,
      price: price,
      durationMinutes: duration,
    );

    final controller = ref.read(serviceControllerProvider.notifier);

    if (widget.service == null) {
      await controller.createService(service);
    } else {
      await controller.updateService(service);
    }

    if (!mounted) return;

    final opState = ref.read(serviceControllerProvider);
    if (opState.hasError) {
      messenger.showSnackBar(SnackBar(content: Text(opState.error.toString())));
      return;
    }

    ref.invalidate(servicesProvider);
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          widget.service == null ? 'Service created' : 'Service updated',
        ),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isBusy = ref.watch(serviceControllerProvider).isLoading;

    return Padding(
      padding: EdgeInsets.only(
        top: 16,
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.service == null ? 'New Service' : 'Edit Service',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameCtrl,
            enabled: !isBusy,
            decoration: const InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descriptionCtrl,
            enabled: !isBusy,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _priceCtrl,
            enabled: !isBusy,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Price',
              prefixText: '\$',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _durationCtrl,
            enabled: !isBusy,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Duration (mins)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: isBusy ? null : _save,
            child: Text(isBusy ? 'Saving...' : 'Save Service'),
          ),
        ],
      ),
    );
  }
}
