import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/country.dart';

class CountryService {
  static const _base = 'https://restcountries.com/v3.1';
  static const _fields =
      'fields=name,capital,currencies,languages,population,flags,cca2';

  Future<List<Country>> getAllCountries() async {
    final res = await http.get(Uri.parse('$_base/all?$_fields'));
    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      return (data.map((e) => Country.fromJson(e)).toList())
        ..sort((a, b) => a.name.compareTo(b.name));
    }
    throw Exception('Failed to load countries (${res.statusCode})');
  }

  Future<Country> getCountryByCode(String code) async {
    final res = await http.get(Uri.parse('$_base/alpha/$code?$_fields'));
    debugPrint('Detail status: ${res.statusCode}');
    debugPrint('Detail body: ${res.body}');

    if (res.statusCode == 200) {
      final decoded = json.decode(res.body);
      if (decoded is List && decoded.isNotEmpty) {
        return Country.fromJson(decoded.first as Map<String, dynamic>);
      } else if (decoded is Map<String, dynamic>) {
        return Country.fromJson(decoded);
      }
      throw Exception('Unexpected response format');
    }
    throw Exception('Failed to load country detail (${res.statusCode})');
  }
}
