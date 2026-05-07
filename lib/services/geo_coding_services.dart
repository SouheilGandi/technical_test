import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants.dart';
import '../models/geo_location.dart';

class CityNotFoundException implements Exception {
  final String city;
  CityNotFoundException(this.city);
}

class GeocodingService {
  static const _base = 'https://api.opencagedata.com/geocode/v1/json';

  Future<GeoLocation> resolveCity(String city) async {
    final uri = Uri.parse(
      '$_base?q=${Uri.encodeComponent(city)}&key=${ApiKeys.openCage}&limit=1&no_annotations=1',
    );
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final data = json.decode(res.body) as Map<String, dynamic>;
      final results = data['results'] as List;
      if (results.isEmpty) throw CityNotFoundException(city);
      return GeoLocation.fromOpenCage(results.first as Map<String, dynamic>);
    }
    throw Exception('Geocoding failed (${res.statusCode})');
  }
}
