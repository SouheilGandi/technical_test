import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:technical_test/services/geo_coding_services.dart';
import 'package:technical_test/services/weather_services.dart';
import '../models/geo_location.dart';
import '../models/weather_forecast.dart';

class WeatherProvider extends ChangeNotifier {
  final _geo = GeocodingService();
  final _weather = WeatherService();
  static const _kLastCity = 'last_city';

  GeoLocation? location;
  WeatherForecast? forecast;
  bool loading = false;
  String? error;

  Future<void> loadLastCity() async {
    final prefs = await SharedPreferences.getInstance();
    final last = prefs.getString(_kLastCity);
    if (last != null && last.isNotEmpty) {
      await searchCity(last);
    }
  }

  Future<void> searchCity(String city) async {
    if (city.trim().isEmpty) return;
    loading = true;
    error = null;
    notifyListeners();

    try {
      // SEQUENTIAL chain: geocode → weather
      final loc = await _geo.resolveCity(city);
      final fc = await _weather.fetch(loc.latitude, loc.longitude);
      location = loc;
      forecast = fc;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kLastCity, city);
    } on CityNotFoundException catch (e) {
      error = 'City "${e.city}" not found. Try another name.';
    } catch (_) {
      error = 'Failed to load weather. Check your connection.';
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
