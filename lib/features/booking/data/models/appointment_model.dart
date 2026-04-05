class AppointmentModel {
  const AppointmentModel({
    required this.id,
    required this.serviceId,
    required this.clientId,
    required this.adminId,
    required this.startTime,
    required this.endTime,
    required this.status,
  });

  // Unique appointment id.
  final String id;

  // Linked service id.
  final String serviceId;

  // User id for the client.
  final String clientId;

  // User id for assigned admin/barber.
  final String adminId;

  // Appointment start in ISO date string.
  final DateTime startTime;

  // Appointment end in ISO date string.
  final DateTime endTime;

  // Example values: pending, confirmed, cancelled, completed.
  final String status;

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'].toString(),
      serviceId: json['serviceId'].toString(),
      clientId: json['clientId'].toString(),
      adminId: json['adminId'].toString(),
      startTime: DateTime.parse(json['startTime'].toString()),
      endTime: DateTime.parse(json['endTime'].toString()),
      status: json['status'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serviceId': serviceId,
      'clientId': clientId,
      'adminId': adminId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'status': status,
    };
  }
}
