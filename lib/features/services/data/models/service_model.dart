class ServiceModel {
  const ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.durationMinutes,
    this.imageUrl,
  });

  // Unique service identifier.
  final String id;

  // Display name (e.g., Classic Haircut).
  final String name;

  // Short description shown in list/detail card.
  final String description;

  // Price from backend.
  final double price;

  // Service duration used for slot booking.
  final int durationMinutes;

  // Optional hero image URL.
  final String? imageUrl;

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'].toString(),
      name: (json['name'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      price: (json['price'] as num).toDouble(),
      durationMinutes: (json['durationMinutes'] as num).toInt(),
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'durationMinutes': durationMinutes,
      'imageUrl': imageUrl,
    };
  }
}
