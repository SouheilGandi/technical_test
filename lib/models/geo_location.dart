class GeoLocation {
  final String name;
  final double latitude;
  final double longitude;
  final String? country;

  GeoLocation({
    required this.name,
    required this.latitude,
    required this.longitude,
    this.country,
  });

  factory GeoLocation.fromOpenCage(Map<String, dynamic> json) {
    final geometry = json['geometry'] as Map<String, dynamic>;
    final components = (json['components'] ?? {}) as Map<String, dynamic>;
    return GeoLocation(
      name: json['formatted'] ?? '',
      latitude: (geometry['lat'] as num).toDouble(),
      longitude: (geometry['lng'] as num).toDouble(),
      country: components['country'] as String?,
    );
  }
}
