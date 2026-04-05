class CreateAppointmentRequestModel {
  const CreateAppointmentRequestModel({
    required this.serviceId,
    required this.adminId,
    required this.startTime,
  });

  // Service the client selected.
  final String serviceId;

  // Selected admin/barber id.
  final String adminId;

  // Slot start time in ISO format.
  final DateTime startTime;

  Map<String, dynamic> toJson() {
    return {
      'serviceId': serviceId,
      'adminId': adminId,
      'startTime': startTime.toIso8601String(),
    };
  }
}
