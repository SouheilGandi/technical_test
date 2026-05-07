import 'package:flutter/material.dart';

class WeatherInfo {
  final String label;
  final IconData icon;
  const WeatherInfo(this.label, this.icon);
}

class WmoCodes {
  static WeatherInfo info(int code) {
    switch (code) {
      case 0:
        return const WeatherInfo('Clear sky', Icons.wb_sunny_rounded);
      case 1:
        return const WeatherInfo('Mainly clear', Icons.wb_sunny_rounded);
      case 2:
        return const WeatherInfo('Partly cloudy', Icons.wb_cloudy_rounded);
      case 3:
        return const WeatherInfo('Overcast', Icons.cloud_rounded);
      case 45:
      case 48:
        return const WeatherInfo('Fog', Icons.foggy);
      case 51:
      case 53:
      case 55:
        return const WeatherInfo('Drizzle', Icons.grain_rounded);
      case 56:
      case 57:
        return const WeatherInfo('Freezing drizzle', Icons.ac_unit_rounded);
      case 61:
      case 63:
      case 65:
        return const WeatherInfo('Rain', Icons.water_drop_rounded);
      case 66:
      case 67:
        return const WeatherInfo('Freezing rain', Icons.ac_unit_rounded);
      case 71:
      case 73:
      case 75:
        return const WeatherInfo('Snow', Icons.ac_unit_rounded);
      case 77:
        return const WeatherInfo('Snow grains', Icons.ac_unit_rounded);
      case 80:
      case 81:
      case 82:
        return const WeatherInfo('Rain showers', Icons.water_drop_rounded);
      case 85:
      case 86:
        return const WeatherInfo('Snow showers', Icons.ac_unit_rounded);
      case 95:
        return const WeatherInfo('Thunderstorm', Icons.thunderstorm_rounded);
      case 96:
      case 99:
        return const WeatherInfo(
          'Thunderstorm w/ hail',
          Icons.thunderstorm_rounded,
        );
      default:
        return const WeatherInfo('Unknown', Icons.help_outline);
    }
  }
}
