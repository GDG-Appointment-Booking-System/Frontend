import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/router/route_names.dart';
import 'package:frontend/core/shared_widgets/app_colors.dart';
import 'package:frontend/features/booking/data/models/create_appointment_request_model.dart';
import 'package:frontend/features/booking/providers/appointments_provider.dart';
import 'package:frontend/features/services/data/models/service_model.dart';
import 'package:frontend/features/services/providers/services_provider.dart';
import 'package:frontend/shared/widgets/client_bottom_nav.dart';
import 'package:frontend/shared/widgets/section_header.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class BookingPage extends ConsumerStatefulWidget {
  const BookingPage({super.key});

  @override
  ConsumerState<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends ConsumerState<BookingPage> {
  late DateTime _selectedDate;
  DateTime? _selectedTime;
  String? _selectedServiceId;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    _selectedDate = DateTime(today.year, today.month, today.day);
  }

  List<DateTime> _slotsForDate(DateTime day) {
    const hours = [9, 10, 11, 13, 14, 15];
    return hours
        .map((hour) => DateTime(day.year, day.month, day.day, hour, 30))
        .toList();
  }

  Future<void> _submitBooking() async {
    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select a time slot first.')),
      );
      return;
    }

    final services = ref.read(servicesProvider).valueOrNull ?? const [];
    final selectedService = _findSelectedService(services);

    if (selectedService == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Select a service first.')));
      return;
    }

    final request = CreateAppointmentRequestModel(
      serviceId: selectedService.id,
      adminId: 'admin-julian',
      startTime: _selectedTime!,
    );

    await ref
        .read(appointmentControllerProvider.notifier)
        .createAppointment(request);

    if (!mounted) return;
    final createState = ref.read(appointmentControllerProvider);
    if (createState.hasError) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(createState.error.toString())));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Appointment created successfully.')),
    );

    ref.invalidate(appointmentsProvider);
    context.go(RouteNames.myAppointments);
  }

  ServiceModel? _findSelectedService(List<ServiceModel> services) {
    for (final service in services) {
      if (service.id == _selectedServiceId) {
        return service;
      }
    }
    return null;
  }

  bool _hasSelectedService(List<ServiceModel> services) {
    for (final service in services) {
      if (service.id == _selectedServiceId) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final servicesAsync = ref.watch(servicesProvider);
    final services = servicesAsync.valueOrNull ?? const <ServiceModel>[];

    if (services.isNotEmpty && !_hasSelectedService(services)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() => _selectedServiceId = services.first.id);
      });
    }

    final selectedService = _findSelectedService(services);
    final createState = ref.watch(appointmentControllerProvider);
    final slots = _slotsForDate(_selectedDate);
    final formattedDate = DateFormat('EEE, dd MMM').format(_selectedDate);

    return Scaffold(
      appBar: AppBar(title: const Text('SharpCut')),
      bottomNavigationBar: const ClientBottomNav(
        currentRoute: RouteNames.booking,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Step heading mirrors the clean "schedule" style in your references.
              const SectionHeader(
                title: 'Find Your Perfect Moment',
                subtitle:
                    'Pick a date and time for your next grooming appointment.',
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Service',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 10),
                      servicesAsync.when(
                        data: (loadedServices) {
                          if (loadedServices.isEmpty) {
                            return const Text(
                              'No services available right now.',
                            );
                          }

                          return DropdownButtonFormField<String>(
                            key: ValueKey(_selectedServiceId),
                            initialValue: _selectedServiceId,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            items: loadedServices.map((service) {
                              return DropdownMenuItem<String>(
                                value: service.id,
                                child: Text(
                                  '${service.name} - \$${service.price.toStringAsFixed(0)}',
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() => _selectedServiceId = value);
                            },
                          );
                        },
                        loading: () => const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: LinearProgressIndicator(),
                        ),
                        error: (error, _) => Text(
                          'Could not load services: $error',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Select Date',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 10),
                      CalendarDatePicker(
                        initialDate: _selectedDate,
                        firstDate: DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                          DateTime.now().day,
                        ),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        onDateChanged: (DateTime date) {
                          setState(() {
                            _selectedDate = date;
                            _selectedTime = null;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Available Slots',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formattedDate,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 10),

                      // Slot chips are beginner-friendly and easy to replace with API data.
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: slots.map((slot) {
                          final isSelected = _selectedTime == slot;
                          return ChoiceChip(
                            label: Text(DateFormat('hh:mm a').format(slot)),
                            selected: isSelected,
                            onSelected: (_) =>
                                setState(() => _selectedTime = slot),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Booking Summary',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      _SummaryRow(
                        label: 'Service',
                        value: selectedService?.name ?? 'Not selected',
                      ),
                      _SummaryRow(
                        label: 'Date',
                        value: DateFormat(
                          'EEE, dd MMM yyyy',
                        ).format(_selectedDate),
                      ),
                      _SummaryRow(
                        label: 'Time',
                        value: _selectedTime == null
                            ? 'Not selected'
                            : DateFormat('hh:mm a').format(_selectedTime!),
                      ),
                      _SummaryRow(
                        label: 'Estimated Price',
                        value: selectedService == null
                            ? '-'
                            : '\$${selectedService.price.toStringAsFixed(0)}',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: createState.isLoading ? null : _submitBooking,
                  child: Text(
                    createState.isLoading
                        ? 'Confirming...'
                        : 'Confirm Selection',
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

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label:',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
          ),
          const Spacer(),
          Text(value, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
