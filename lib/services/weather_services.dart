import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_forecast.dart';

class WeatherService {
  static const _base = 'https://api.open-meteo.com/v1/forecast';

  Future<WeatherForecast> fetch(double lat, double lng) async {
    final uri = Uri.parse(
      '$_base?latitude=$lat&longitude=$lng'
      '&current=temperature_2m,wind_speed_10m,weather_code'
      '&daily=temperature_2m_max,temperature_2m_min,weather_code'
      '&timezone=auto&forecast_days=7',
    );
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      return WeatherForecast.fromJson(
        json.decode(res.body) as Map<String, dynamic>,
      );
    }
    throw Exception('Weather fetch failed (${res.statusCode})');
  }
}
